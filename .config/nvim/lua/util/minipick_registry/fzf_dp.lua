---DP-based fuzzy matcher (Smith-Waterman style) tuned for file paths.
---This is a dynamic-programming alternative to the greedy fzf scorer.
local M = {}

local DEFAULT_CONSTANTS = {
  score_match = 16,
  -- Example: f___zy
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

local Matcher = {}
Matcher.__index = Matcher

---@param opts? {ignorecase?: boolean, smartcase?: boolean, filename_bonus?: boolean, constants?: table}
function Matcher.new(opts)
  local self = setmetatable({}, Matcher)
  self.opts = vim.tbl_deep_extend("force", {
    ignorecase = true,
    smartcase = true,
    filename_bonus = true,
    constants = {},
  }, opts or {})
  self.constants = vim.tbl_deep_extend("force", {}, DEFAULT_CONSTANTS, self.opts.constants or {})
  return self
end

local function compute_bonus(constants, prev_class, curr_class)
  -- If transitioning from whitespace/delimiter/nonword to letter => boundary bonus
  if curr_class > CHAR_NONWORD then
    if prev_class == CHAR_WHITE then
      return constants.bonus_boundary_white
    elseif prev_class == CHAR_DELIMITER then
      return constants.bonus_boundary_delimiter
    elseif prev_class == CHAR_NONWORD then
      return constants.bonus_boundary
    end
  end

  -- camelCase transitions or letter->number transitions
  if
    (prev_class == CHAR_LOWER and curr_class == CHAR_UPPER) or (prev_class ~= CHAR_NUMBER and curr_class == CHAR_NUMBER)
  then
    return constants.bonus_camel_123
  end

  if curr_class == CHAR_NONWORD or curr_class == CHAR_DELIMITER then
    return constants.bonus_nonword
  elseif curr_class == CHAR_WHITE then
    return constants.bonus_boundary_white
  end
  return 0
end

local function build_bonuses(str, constants, filename_bonus)
  local n = #str
  local bonuses = {}
  local prev_class = CHAR_WHITE
  local last_sep = str:match("^.*()" .. vim.pesc(PATH_SEP))
  if not last_sep and PATH_SEP ~= "/" then last_sep = str:match("^.*()/") end
  for i = 1, n do
    local class = CHAR_CLASS[str:byte(i)] or CHAR_NONWORD
    local bonus = compute_bonus(constants, prev_class, class)
    if filename_bonus and last_sep and i > last_sep then bonus = bonus + constants.bonus_no_path_sep end
    bonuses[i] = bonus
    prev_class = class
  end
  return bonuses
end

---@param str string
---@param pattern string
---@param opts? {is_file?: boolean}
---@return number? score
function Matcher:match_score(str, pattern, opts)
  if pattern == "" then return 0 end

  local hay = str
  local needle = pattern
  if self.opts.ignorecase then
    if not (self.opts.smartcase and pattern:find("%u")) then
      hay = str:lower()
      needle = pattern:lower()
    end
  end

  local m, n = #needle, #hay
  if m == 0 then return 0 end
  if m > n then return end

  local constants = self.constants
  local bonuses = build_bonuses(str, constants, opts == nil or opts.is_file ~= false and self.opts.filename_bonus)

  local neg_inf = -1e9
  local D = {}
  local M = {}
  for i = 0, m do
    D[i] = {}
    M[i] = {}
    for j = 0, n do
      D[i][j] = neg_inf
      M[i][j] = neg_inf
    end
  end

  -- empty pattern has 0 score regardless of position
  for j = 0, n do
    M[0][j] = 0
  end

  for i = 1, m do
    local pchar = needle:sub(i, i)
    for j = 1, n do
      local schar = hay:sub(j, j)
      if pchar == schar then
        local match_bonus = constants.score_match + bonuses[j]
        if i == 1 then match_bonus = match_bonus + bonuses[j] * (constants.bonus_first_char_multiplier - 1) end

        local score_from_match = M[i - 1][j - 1] + match_bonus
        local score_from_consecutive = D[i - 1][j - 1] + match_bonus + constants.bonus_consecutive
        D[i][j] = math.max(score_from_match, score_from_consecutive)
      end

      -- propagate best score with gap penalties
      local gap_extend = M[i][j - 1] + constants.score_gap_extension
      local gap_open = D[i][j - 1] + constants.score_gap_start
      M[i][j] = math.max(D[i][j], gap_extend, gap_open)
    end
  end

  local best = M[m][n]
  if best <= neg_inf / 2 then return end
  return best
end

M.new = function(opts)
  return Matcher.new(opts)
end

return M
