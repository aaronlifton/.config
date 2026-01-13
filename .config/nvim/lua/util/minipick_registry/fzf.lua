---FZF-like scoring adapted from snacks.nvim (itself ported from fzf).
---Summary:
---  - Finds a subsequence match for the query.
---  - Scores each candidate by rewarding boundaries, camelCase, and consecutive runs.
---  - Penalizes gaps, prefers earlier and filename-segment matches.
---Example behavior (approximate):
---  - "rag ar" matches "docs/rag_architecture.md" with a high score
---  - "ar" prefers "anthropic.rs" over "wiki-parser/Cargo.toml"
---Tunable constants (opts.constants):
---  - score_match, score_gap_start, score_gap_extension
---  - bonus_first_char_multiplier, bonus_consecutive
---  - bonus_boundary, bonus_nonword, bonus_camel_123
---  - bonus_boundary_white, bonus_boundary_delimiter
---  - bonus_no_path_sep
---Presets (opts.preset):
---  - "fzf" (defaults)
---  - "filename_bias"
local M = {}

local DEFAULT_CONSTANTS = {
  score_match = 16,
  score_gap_start = -3,
  score_gap_extension = -1,
  bonus_boundary = 8,
  bonus_nonword = 8,
  bonus_camel_123 = 7,
  bonus_consecutive = 4,
  bonus_first_char_multiplier = 2,
  bonus_no_path_sep = 6,
  bonus_boundary_white = 10,
  bonus_boundary_delimiter = 9,
}

local PRESETS = {
  fzf = {},
  filename_bias = {
    bonus_no_path_sep = 12,
    bonus_boundary = 10,
    bonus_boundary_white = 12,
    bonus_boundary_delimiter = 11,
  },
}

local Score = {}
Score.__index = Score

local PATH_SEP = package.config:sub(1, 1)

-- ASCII char classes (simplified); adapt as needed:
local CHAR_WHITE = 0
local CHAR_NONWORD = 1
local CHAR_DELIMITER = 2
local CHAR_LOWER = 3
local CHAR_UPPER = 4
local CHAR_LETTER = 5
local CHAR_NUMBER = 6

-- Table to classify ASCII bytes quickly:
local CHAR_CLASS = {} ---@type number[]
for b = 0, 255 do
  local c = CHAR_NONWORD
  local char = string.char(b)
  if char:match("%s") then
    c = CHAR_WHITE
  elseif char:match("[/\\,:;|]") then
    c = CHAR_DELIMITER
  elseif b >= 48 and b <= 57 then -- '0'..'9'
    c = CHAR_NUMBER
  elseif b >= 65 and b <= 90 then -- 'A'..'Z'
    c = CHAR_UPPER
  elseif b >= 97 and b <= 122 then -- 'a'..'z'
    c = CHAR_LOWER
  end
  CHAR_CLASS[b] = c
end

---@param opts? {history_bonus?: boolean, filename_bonus?: boolean, constants?: table}
function Score.new(opts)
  local self = setmetatable({}, Score)
  self.opts = opts or {}
  self.constants = vim.tbl_deep_extend("force", {}, DEFAULT_CONSTANTS, self.opts.constants or {})
  self.score = 0
  self.is_file = true
  self.consecutive = 0
  self.prev_class = CHAR_WHITE
  self.str = ""
  self.first_bonus = 0
  self.bonus_matrix = {}
  self.bonus_boundary_white = self.constants.bonus_boundary_white
  self.bonus_boundary_delimiter = self.constants.bonus_boundary_delimiter
  if self.opts.history_bonus then
    self.bonus_boundary_white = self.constants.bonus_boundary
    self.bonus_boundary_delimiter = self.constants.bonus_boundary
  end
  self:compute_bonus_matrix()
  return self
end

function Score:compute_bonus_matrix()
  for prev = 0, 6 do
    self.bonus_matrix[prev] = {}
    for curr = 0, 6 do
      self.bonus_matrix[prev][curr] = self:compute_bonus(prev, curr)
    end
  end
end

-- Helper to compute boundary/camelCase bonuses (mimics fzf approach)
function Score:compute_bonus(prev, curr)
  -- If transitioning from whitespace/delimiter/nonword to letter => boundary bonus
  if curr > CHAR_NONWORD then
    if prev == CHAR_WHITE then
      return self.bonus_boundary_white
    elseif prev == CHAR_DELIMITER then
      return self.bonus_boundary_delimiter
    elseif prev == CHAR_NONWORD then
      return self.constants.bonus_boundary
    end
  end

  -- camelCase transitions or letter->number transitions
  if (prev == CHAR_LOWER and curr == CHAR_UPPER) or (prev ~= CHAR_NUMBER and curr == CHAR_NUMBER) then
    return self.constants.bonus_camel_123
  end

  if curr == CHAR_NONWORD or curr == CHAR_DELIMITER then
    return self.constants.bonus_nonword
  elseif curr == CHAR_WHITE then
    return self.constants.bonus_boundary_white
  end
  return 0
end

---@param str string
---@param pos number
function Score:is_left_boundary(str, pos)
  return pos == 1 or CHAR_CLASS[str:byte(pos - 1)] < CHAR_LOWER
end

---@param str string
---@param pos number
function Score:is_right_boundary(str, pos)
  return pos == #str or CHAR_CLASS[str:byte(pos + 1)] < CHAR_LOWER
end

---@param str string
---@param first number
function Score:init(str, first)
  self.str = str
  self.score = 0
  self.consecutive = 0
  self.prev_class = CHAR_WHITE
  self.prev = nil
  self.first_bonus = 0
  if first > 1 then
    self.prev_class = CHAR_CLASS[str:byte(first - 1)] or CHAR_NONWORD
  end
  if
    self.is_file
    and self.opts.filename_bonus ~= false
    and not str:find(PATH_SEP, first + 1, true)
    and not (PATH_SEP ~= "/" and str:find("/", first + 1, true))
  then
    self.score = self.score + self.constants.bonus_no_path_sep
  end
  self:update(first)
end

---@param pos number
function Score:update(pos)
  local b = self.str:byte(pos)
  local class = CHAR_CLASS[b] or CHAR_NONWORD
  local bonus = 0
  local gap = self.prev and pos - self.prev - 1 or 0

  if gap > 0 then
    self.prev_class = CHAR_CLASS[self.str:byte(pos - 1)] or CHAR_NONWORD
    bonus = self.bonus_matrix[self.prev_class][class] or 0
    self.score = self.score + self.constants.score_gap_start + (gap - 1) * self.constants.score_gap_extension
    self.consecutive = 0
    self.first_bonus = 0
  else
    bonus = self.bonus_matrix[self.prev_class][class] or 0
    -- No gap => consecutive chunk
    if self.consecutive == 0 then
      -- New chunk => store the boundary/camel bonus
      self.first_bonus = bonus
    else
      -- If we see a bigger boundary/camel bonus than what started the chunk, update
      if bonus >= self.constants.bonus_boundary and bonus > self.first_bonus then
        self.first_bonus = bonus
      end
      -- Take the max of the current bonus, the chunk's firstBonus, or bonus_consecutive
      bonus = math.max(bonus, self.first_bonus, self.constants.bonus_consecutive)
    end
    self.consecutive = self.consecutive + 1
  end

  if not self.prev then
    bonus = bonus * self.constants.bonus_first_char_multiplier
  end

  self.score = self.score + self.constants.score_match + bonus

  -- Update for next iteration
  self.prev_class = class
  self.prev = pos
end

---@param str string
---@param from number
---@param to number
function Score:get(str, from, to)
  self:init(str, from)
  for i = from + 1, to do
    self:update(i)
  end
  return self.score
end

local Fzf = {}
Fzf.__index = Fzf

---@param opts? {ignorecase?: boolean, smartcase?: boolean, filename_bonus?: boolean, constants?: table}
function Fzf.new(opts)
  local self = setmetatable({}, Fzf)
  self.opts = vim.tbl_deep_extend("force", {
    ignorecase = true,
    smartcase = true,
    filename_bonus = true,
    constants = {},
  }, opts or {})
  if type(self.opts.preset) == "string" and PRESETS[self.opts.preset] then
    self.opts.constants = vim.tbl_deep_extend("force", {}, PRESETS[self.opts.preset], self.opts.constants or {})
  end
  self.score_engine = Score.new({
    filename_bonus = self.opts.filename_bonus,
    constants = self.opts.constants,
  })
  return self
end

---@param str string
---@param pattern string
---@param opts? {is_file?: boolean}
---@return number? score
function Fzf:match_score(str, pattern, opts)
  if pattern == "" then
    return 0
  end

  self.score_engine.is_file = opts == nil or opts.is_file ~= false

  local hay = str
  local needle = pattern
  if self.opts.ignorecase then
    if not (self.opts.smartcase and pattern:find("%u")) then
      hay = str:lower()
      needle = pattern:lower()
    end
  end

  local chars = {}
  for i = 1, #needle do
    chars[i] = needle:sub(i, i)
  end

  return self:fuzzy(hay, str, chars)
end

---@param str string
---@param str_orig string
---@param pattern string[]
---@param init? number
---@return number? from, number? to
function Fzf:fuzzy_find(str, str_orig, pattern, init)
  local from = string.find(str, pattern[1], init or 1, true)
  if not from then
    return
  end
  self.score_engine:init(str_orig, from)
  local last = from
  for i = 2, #pattern do
    last = string.find(str, pattern[i], last + 1, true)
    if last then
      self.score_engine:update(last)
    else
      return
    end
  end
  return from, last
end

--- Does a forward scan followed by a backward scan for each end position,
--- to find the best match.
---@param str string
---@param str_orig string
---@param pattern string[]
---@return number? score
function Fzf:fuzzy(str, str_orig, pattern)
  local from, to = self:fuzzy_find(str, str_orig, pattern)
  if not from then
    return
  end
  local best_score = self.score_engine.score
  while from do
    if self.score_engine.score > best_score then
      best_score = self.score_engine.score
    end
    from, to = self:fuzzy_find(str, str_orig, pattern, from + 1)
  end
  return best_score
end

M.new = function(opts)
  return Fzf.new(opts)
end

M.presets = PRESETS

return M
