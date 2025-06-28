local M = {}

-- Define the input received from wakastat().wakatime()
-- This is a table containing the output string.
-- local waka_output = { "6 hrs 24 mins Coding, 17 secs Debugging\n" }
local waka_output = require("wakastat").wakatime()

-- Define the mapping from activity name to the desired single letter prefix
local ActivityMapping = {
  -- Add standard Wakatime activity names here and their desired single letter
  Coding = "C",
  Debugging = "D",
  ["Pair Programming"] = "P", -- Example for multi-word activity
  -- Add more as needed based on your Wakatime activities
}

--- Maps an activity name string to a single letter prefix based on a lookup table.
-- If the name is not found in the lookup, it uses the first character (uppercase).
-- @param activity_name string The activity name extracted from the Wakatime string.
-- @return string A single character prefix.
local function map_activity_to_letter(activity_name)
  -- Trim whitespace from the activity name
  local trimmed_name = activity_name:match("^%s*(.-)%s*$")
  if #trimmed_name == 0 then
    return "?" -- Return a placeholder if the name is empty
  end

  -- Check if the trimmed name exists in our mapping
  -- Use lowercase for lookup keys if Wakatime output varies in capitalization
  -- if ActivityMapping[trimmed_name:lower()] then
  --     return ActivityMapping[trimmed_name:lower()]
  -- end
  -- Keeping uppercase lookup based on your provided example
  if ActivityMapping[trimmed_name] then return ActivityMapping[trimmed_name] end

  -- If not found in mapping, use the first character, uppercase
  return trimmed_name:sub(1, 1):upper()
end

--- Processes a single activity section string (e.g., "6 hrs 24 mins Coding").
-- Extracts time and activity by finding the split point, reformats time,
-- maps activity to letter, and formats the section.
-- @param section_string string A single activity section string (without leading/trailing comma/space/newline).
-- @return string The formatted section string (e.g., "C 6 hr 24 min").
local function process_waka_section(section_string)
  local section = section_string:match("^%s*(.-)%s*$") -- Trim leading/trailing whitespace

  local time_part = section
  local activity_name = ""

  -- --- Simplified Split Logic ---
  -- Split the string into words. Find the first word from the right that
  -- is NOT a time unit (hrs?, mins?, secs?). Everything from that word
  -- to the end is the activity name. Everything before it is the time part.

  local words = {}
  -- Use gmatch to split into words (sequences of non-space characters)
  for word in section:gmatch("%S+") do
    table.insert(words, word)
  end

  local activity_words_rev = {} -- Collect activity words in reverse order
  local time_words_rev = {} -- Collect time words in reverse order
  local split_found = false
  -- List of potential time unit words (both plural and singular)
  local units = { "hrs", "mins", "secs", "hr", "min", "sec" }

  -- Iterate words from the end of the list
  for i = #words, 1, -1 do
    local word = words[i]

    -- Check if the current word is one of the known time units (case-insensitive check)
    local is_unit = false
    for _, unit in ipairs(units) do
      if word:lower() == unit then
        is_unit = true
        break
      end
    end

    if is_unit and not split_found then
      -- This word is a unit, and we haven't found the activity name split yet.
      -- It belongs to the time part. Add it to time words (in reverse).
      table.insert(time_words_rev, word)
      -- Optionally, add a check here if the *previous* word was a number to be more certain this is a number-unit pair.
      -- local prev_word = words[i-1]
      -- if prev_word and tonumber(prev_word) then
      --     table.insert(time_words_rev, word)
      -- else
      --     -- Unit without number? Treat as activity name word (unlikely but safer fallback)
      --      table.insert(activity_words_rev, word)
      -- end
    else
      -- This word is either NOT a unit, or the split was already found.
      -- If the split hasn't been found yet, this word (and others to the right)
      -- must be part of the activity name.
      if not split_found then
        table.insert(activity_words_rev, word) -- Add to activity words (in reverse)
      else
        -- Split was found. All remaining words to the left belong to the time part.
        table.insert(time_words_rev, word) -- Add to time words (in reverse)
      end
      -- Mark split found if we encountered a word that is NOT a unit
      -- (and we weren't already past the split point).
      if not is_unit then split_found = true end
    end
  end

  -- Reconstruct the time part and activity name by reversing the collected words
  -- and joining them with spaces.
  activity_name = table.concat(vim.fn.reverse(activity_words_rev), "")
  time_part = table.concat(vim.fn.reverse(time_words_rev), " ")

  -- --- End Simplified Split Logic ---

  -- Reformat the time part: replace hrs/mins/secs with hr/min/sec and remove spaces
  local reformatted_time = time_part:gsub("hrs", "hr"):gsub("mins", "min"):gsub("secs", "sec")
  -- Remove ALL spaces between numbers and time units (e.g., "1 hr 5 sec" -> "1hr 5sec")
  while reformatted_time:match("(%d+)%s+([a-z]+)") do
    reformatted_time = reformatted_time:gsub("(%d+)%s+([a-z]+)", "%1%2")
  end
  -- Clean up multiple spaces and trim final result
  reformatted_time = reformatted_time:gsub("%s+", " "):match("^%s*(.-)%s*$")

  -- Map activity name to letter
  local activity_letter = map_activity_to_letter(activity_name)

  -- Assemble the formatted section
  if #reformatted_time > 0 then
    return activity_letter .. " " .. reformatted_time
  else
    -- If time part was empty (e.g., only activity name was present), just use the letter
    -- This might happen for categories with 0 time.
    return activity_letter
  end
end

-- --- Main transformation (Simplified) ---
local function transform()
  -- Get the string from the table and remove trailing newline if present
  local input_string = waka_output[1]:gsub("\n$", "")

  -- Split the string by ", " using string.gmatch
  -- gmatch returns an iterator that yields substrings matching the pattern "([^,]+)" (one or more characters that are not a comma)
  local sections = {}
  for section_string in input_string:gmatch("([^,]+)") do
    table.insert(sections, section_string) -- gmatch provides the substring directly
  end

  -- Process each section and collect results
  local processed_sections = {}
  for _, section_string in ipairs(sections) do
    table.insert(processed_sections, process_waka_section(section_string))
  end

  -- Join the processed sections with the requested separator " , "
  local final_formatted_string = table.concat(processed_sections, " , ")

  -- Print the result (or use the variable final_formatted_string)
  print(final_formatted_string)

  -- The variable final_formatted_string now holds the transformed string
  -- "C 6 hr 24 min , D 17 sec" (based on the example input)
end

function example()
  -- Example with a different input format:
  local waka_output_single = { "56 mins Debugging\n" }
  local input_string_single = waka_output_single[1]:gsub("\n$", "")
  local sections_single = {}
  for section_string in input_string_single:gmatch("([^,]+)") do
    table.insert(sections_single, section_string)
  end
  local processed_sections_single = {}
  for _, section_string in ipairs(sections_single) do
    table.insert(processed_sections_single, process_waka_section(section_string))
  end
  local final_formatted_string_single = table.concat(processed_sections_single, " , ")
  print("Example 2:", final_formatted_string_single)

  -- Example with hours and seconds:
  local waka_output_h_s = { "1 hr 5 secs Coding\n" }
  local input_string_h_s = waka_output_h_s[1]:gsub("\n$", "")
  local sections_h_s = {}
  for section_string in input_string_h_s:gmatch("([^,]+)") do
    table.insert(sections_h_s, section_string)
  end
  local processed_sections_h_s = {}
  for _, section_string in ipairs(sections_h_s) do
    table.insert(processed_sections_h_s, process_waka_section(section_string))
  end
  local final_formatted_string_h_s = table.concat(processed_sections_h_s, " , ")
  print("Example 3:", final_formatted_string_h_s)
end

return M
