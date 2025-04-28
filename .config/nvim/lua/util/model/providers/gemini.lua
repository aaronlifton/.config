local util = require("model.util")
local sse = require("model.util.sse")

local M = {}

--- Defines the Google Search tool configuration for the API request.
-- @return table The API-compatible tool configuration table.
local function create_google_search_tool_config()
  return {
    googleSearch = {}, -- Represents the Google Search tool with default configuration
  }
end

--- Creates the full API request body with optional generation config and tools.
-- @param params table The base parameters (like contents).
-- @param generation_config table|nil Optional generation configuration.
-- @param tools table|nil Optional list of tool configurations.
-- @return table The complete API request body.
local function build_request_body(params, generation_config, tools)
  local body = params

  if generation_config then body.generationConfig = generation_config end

  if tools and #tools > 0 then
    -- Explicitly create a Lua array/list for the 'tools' field
    body.tools = {}
    for i, tool_config_object in ipairs(tools) do
      -- Ensure we're assigning to numerically indexed keys for Lua array behavior
      body.tools[i] = tool_config_object
    end
  end

  return body
end

-- --- Important: Also check for grounding metadata if needed ---
-- If you want to access grounding metadata like in the Python example:
-- print(response.candidates[0].grounding_metadata.search_entry_point.rendered_content)
-- You would need to process `item.candidates[1].grounding_metadata` here
-- and potentially pass it to your handler or store it.
-- Note: Grounding metadata is typically only present in the final chunk.
-- The structure is usually `groundingMetadata: { searchEntryPoint: { renderedContent: "..." } }`
local function check_grounding_metadata(candidate)
  if candidate.groundingMetadata and candidate.groundingMetadata.searchEntryPoint then
    local grounding_content = candidate.groundingMetadata.searchEntryPoint.renderedContent
    -- You might want to have a dedicated handler method for grounding info
    -- handler.on_grounding(grounding_content)
    -- Or just print it for now:
    vim.api.nvim_echo({ { vim.inspect({ grounding_metadata = grounding_content }), "Normal" } }, true, {})
  end
end

function M.model(model_name, generation_config, tools)
  generation_config = generation_config or nil
  tools = tools or {}

  ---@type Provider|function
  return {
    request_completion = function(handler, params)
      -- `params` here should contain the "contents" field
      -- Example `params`: { contents = { { parts = { { text = "your prompt" } }, role = "user" } } }

      -- Build the request body, including the Google Search tool
      local body = build_request_body(
        params,
        generation_config, -- Use the generation_config passed to M.model
        tools -- Add the Google Search tool in a list
      )

      local json_body_string = vim.json.encode(body)
      vim.notify("Request JSON Body:\n" .. json_body_string, vim.log.levels.INFO)

      return sse.curl_client({
        url = string.format(
          "https://generativelanguage.googleapis.com/v1beta/models/%s:streamGenerateContent?alt=sse&key=",
          model_name
        ) .. util.env("GOOGLE_API_KEY"),
        headers = {
          ["Content-Type"] = "application/json",
        },
        body = body,
      }, {
        on_message = function(msg, raw)
          local item = util.json.decode(msg.data)
          if item and item.candidates then
            if item.candidates[1] then
              candidate = item.candidates[1]
              if candidate.content and candidate.content.parts then
                local text_parts = candidate.content.parts
                for _, part in ipairs(text_parts) do
                  -- Handle thoughts
                  if part.thought then
                    handler.on_partial(part.thought)
                  -- Handle tool calls
                  elseif part.functionCall then
                    -- https://github.com/default-anton/llm-sidekick.nvim/blob/3f262324f014af82e2d3f038bd0732d11f3ab2f7/lua/llm-sidekick/gemini.lua#L210
                    vim.g.llm_sidekick_gemini_tool_call_counter = (vim.g.llm_sidekick_gemini_tool_call_counter or 0) + 1
                    local message = string.format(
                      "Tool call (%d): %s with parameters: %s",
                      vim.g.llm_sidekick_gemini_tool_call_counter,
                      part.functionCall.name,
                      vim.inspect(part.functionCall.args)
                    )
                    handler.on_partial(message)
                  -- Handle text parts
                  else
                    -- The API might return different part types, only handle text for now
                    if part.text then handler.on_partial(part.text) end
                  end
                end
              end

              check_grounding_metadata(candidate)
            end

            -- Candidate might exist but be blocked etc.
            if item.promptFeedback and item.promptFeedback.blockReason then
              if candidate and candidate.finishReason == "SAFETY" then
                vim.api.nvim_echo({ { vim.inspect({ safetyRatings = candidate.safetyRatings }), "Normal" } }, true, {})
              end
              handler.on_error("Prompt blocked: " .. item.promptFeedback.blockReason)
            end
          else
            -- Handle top-level errors outside of candidates
            local err_response = util.json.decode(raw)
            if err_response and err_response.error then
              handler.on_error(
                "API Error: " .. err_response.error.message .. " (Code: " .. err_response.error.code .. ")"
              )
            elseif err_response then
              handler.on_error(err_response)
            else
              handler.on_error("Unrecognized SSE response or empty candidates")
            end
          end
        end,
        on_error = handler.on_error,
        on_other = handler.on_error,
        on_exit = handler.on_finish,
      })
    end,
  }
end

------@type Provider
---local M = {
---  request_completion = function(handler, params)
---    return sse.curl_client({
---      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:streamGenerateContent?alt=sse&key="
---        .. util.env("GOOGLE_API_KEY"),
---      headers = {
---        ["Content-Type"] = "application/json",
---      },
---      body = params,
---    }, {
---      on_message = function(msg, raw)
---        local item = util.json.decode(msg.data)
---        if item and item.candidates then
---          if item.candidates[1].content then
---            local text_parts = item.candidates[1].content.parts
---            for _, part in ipairs(text_parts) do
---              handler.on_partial(part.text)
---            end
---          else
---            handler.on_error(item)
---          end
---        else
---          local err_response = util.json.decode(raw)
---
---          if err_response then
---            handler.on_error(err_response)
---          else
---            handler.on_error("Unrecognized SSE response")
---          end
---        end
---      end,
---      on_error = handler.on_error,
---      on_other = handler.on_error,
---      on_exit = handler.on_finish,
---    })
---  end,
---}

return M
