local util = require("model.util")
local sse = require("model.util.sse")

---@class GeminiHarmCategory
---@field HARM_CATEGORY_UNSPECIFIED string # Unspecified harm category
---@field HARM_CATEGORY_HATE_SPEECH string # Hate speech category
---@field HARM_CATEGORY_DANGEROUS_CONTENT string # Dangerous content category
---@field HARM_CATEGORY_HARASSMENT string # Harassment category
---@field HARM_CATEGORY_SEXUALLY_EXPLICIT string # Sexually explicit content category
---@field HARM_CATEGORY_CIVIC_INTEGRITY string # Civic integrity category

---@class GeminiHarmBlockMethod
---@field HARM_BLOCK_METHOD_UNSPECIFIED string # Unspecified block method
---@field SEVERITY string # Block based on severity score
---@field PROBABILITY string # Block based on probability score

---@class GeminiHarmBlockThreshold
---@field HARM_BLOCK_THRESHOLD_UNSPECIFIED string # Unspecified threshold
---@field BLOCK_LOW_AND_ABOVE string # Block low threshold and above
---@field BLOCK_MEDIUM_AND_ABOVE string # Block medium threshold and above
---@field BLOCK_ONLY_HIGH string # Block only high threshold
---@field BLOCK_NONE string # Don't block based on threshold
---@field OFF string # Safety settings are disabled

---@class GeminiSafetySetting
---@field category? GeminiHarmCategory # Required. Harm category
---@field threshold? GeminiHarmBlockThreshold # Required. The harm block threshold
---@field method? GeminiHarmBlockMethod # Determines if the threshold is used for probability or severity score

---@class GeminiSchema
---@field type? string # The type of the data
---@field description? string # The description of the data
---@field properties? table<string, GeminiSchema> # Properties of Type.OBJECT
---@field required? string[] # Required properties of Type.OBJECT
---@field items? GeminiSchema # Schema of the elements of Type.ARRAY
---@field enum? string[] # Possible values for enum format
---@field format? string # The format of the data

---@class GeminiGenerationConfigRoutingConfigAutoRoutingMode
---@field modelRoutingPreference? string # The model routing preference ("UNKNOWN", "PRIORITIZE_QUALITY", "BALANCED", or "PRIORITIZE_COST")

---@class GeminiGenerationConfigRoutingConfigManualRoutingMode
---@field modelName? string # The model name to use. Only public LLM models are accepted

---@class GeminiGenerationConfigRoutingConfig
---@field autoMode? GeminiGenerationConfigRoutingConfigAutoRoutingMode # Automated routing
---@field manualMode? GeminiGenerationConfigRoutingConfigManualRoutingMode # Manual routing

---@class GeminiModelSelectionConfig
---@field featureSelectionPreference? string # Options for feature selection preference

---@class GeminiSpeechConfig
---@field voiceConfig? table # The configuration for the speaker to use
---@field languageCode? string # Language code for speech synthesization

---@class GeminiGroundingMetadata
---@field searchEntryPoint? { renderedContent: string } # Search entry point information
---@field webSearchQueries? string[] # Web search queries used for grounding

---@class GeminiCandidate
---@field content? { parts: table[], role?: string } # The content of the candidate response
---@field finishReason? string # The reason why the model stopped generating (e.g., "STOP", "MAX_TOKENS", "SAFETY")
---@field finishMessage? string # Additional message about why generation finished
---@field index? number # The index of the candidate
---@field safetyRatings? { category: string, probability: string }[] # Safety ratings for the generated content
---@field groundingMetadata? GeminiGroundingMetadata # Metadata related to grounding information

---@class GeminiPromptFeedback
---@field blockReason? string # The reason why the prompt was blocked (e.g., "SAFETY")
---@field safetyRatings? { category: string, probability: string }[] # Safety ratings for the prompt

---@class GeminiFunctionCall
---@field name string # The name of the function to call
---@field args table # The arguments to pass to the function

---@class GeminiContentPart
---@field text? string # The text content of the part
---@field functionCall? GeminiFunctionCall # Function call information if this part is a function call
---@field thought? boolean # Whether this part contains model's thinking process
---@field inlineData? { data: string, mimeType: string } # Inline data if this part contains media

---@class GeminiThinkingConfig
---@field includeThoughts? boolean # Indicates whether to include thoughts in the response. If true, thoughts are returned only if the model supports thought and thoughts are available.
---@field thinkingBudget? number # Indicates the thinking budget in tokens.

---@class GeminiGenerationConfig
---@field temperature? number # Value that controls the degree of randomness in token selection (0.0 to 1.0)
---@field topP? number # Tokens are selected from most to least probable until the sum of their probabilities equals this value (0.0 to 1.0)
---@field topK? number # For each token selection step, the top_k tokens with the highest probabilities are sampled (1 to infinity)
---@field candidateCount? number # Number of response variations to return
---@field maxOutputTokens? number # Maximum number of tokens that can be generated in the response
---@field stopSequences? string[] # List of strings that tells the model to stop generating text if encountered
---@field responseLogprobs? boolean # Whether to return the log probabilities of the tokens that were chosen by the model at each step
---@field logprobs? number # Number of top candidate tokens to return the log probabilities for at each generation step
---@field presencePenalty? number # Positive values penalize tokens that already appear in the generated text
---@field frequencyPenalty? number # Positive values penalize tokens that repeatedly appear in the generated text
---@field seed? number # When fixed to a specific number, the model makes a best effort to provide the same response for repeated requests
---@field responseMimeType? string # Output response media type of the generated candidate text
---@field responseSchema? GeminiSchema # Schema that the generated candidate text must adhere to
---@field routingConfig? GeminiGenerationConfigRoutingConfig # Configuration for model router requests
---@field modelSelectionConfig? GeminiModelSelectionConfig # Configuration for model selection
---@field safetySettings? GeminiSafetySetting[] # Safety settings to block unsafe content in the response
---@field tools? GeminiTool[] # Code that enables the system to interact with external systems to perform an action outside of the knowledge and scope of the model.
---@field toolConfig? GeminiToolConfig # Tool configuration
---@field mediaResolution? string # If specified, the media resolution specified will be used
---@field speechConfig? GeminiSpeechConfig # The speech generation configuration
---@field audioTimestamp? boolean # If enabled, audio timestamp will be included in the request to the model
---@field thinkingConfig? GeminiThinkingConfig # The thinking features configuration

---@class GeminiFunctionDeclaration
---@field name string # The name of the function to call
---@field description? string # Description and purpose of the function
---@field parameters? GeminiSchema # Describes the parameters to this function in JSON Schema Object format
---@field response? GeminiSchema # Describes the output from the function

---@class GeminiGoogleSearch Tool to support Google Search in Model. Powered by Google.
-- ---@field googleSearch table # Google Search tool configuration

---@class GeminiDynamicRetrievalConfig
---@field mode? string
---@field dynamicThreshold? number

---@class GeminiGoogleSearchRetrieval
---@field dynamicRetrievalConfig? GeminiDynamicRetrievalConfig # Google Search Retrieval tool configuration

---@class GeminiRetrieval
---@field retrieval { disableAttribution?: boolean, vertexAiSearch?: table, vertexRagStore?: table } # Retrieval tool configuration

---@class GeminiToolCodeExecution
---@field codeExecution table # Code execution tool configuration

---@class GeminiTool
---@field functionDeclarations? GeminiFunctionDeclaration[] # List of function declarations
---@field googleSearch? GeminiGoogleSearch # Google Search tool - Specialized retrieval tool that is powered by Google Search
---@field googleSearchRetrieval? GeminiGoogleSearchRetrieval # Google Search Retrieval tool
---@field retrieval? GeminiRetrieval # Retrieval tool
---@field codeExecution? GeminiToolCodeExecution # Code execution tool

---@class GeminiFunctionCallingConfig
---@field mode? string # Function calling mode ("MODE_UNSPECIFIED", AUTO", "ANY", or "NONE")
---@field allowedFunctionNames? string[] # Function names to call when mode is "ANY"

---@class GeminiToolConfig
---@field functionCallingConfig? GeminiFunctionCallingConfig # Function calling configuration

local M = {}

-- Module-level counter for tool calls
local tool_call_counter = 0
local in_reasoning_tag = false

--- Converts a tool configuration to the format expected by the Gemini API
--- @param tool GeminiTool The tool configuration to convert
--- @return table The converted tool configuration
local function convert_tool(tool)
  local result = {}
  -- Handle functionDeclarations
  if tool.functionDeclarations then
    result.functionDeclarations = {}
    for i, func_decl in ipairs(tool.functionDeclarations) do
      local converted_func = {
        name = func_decl.name,
      }
      if func_decl.description then converted_func.description = func_decl.description end
      if func_decl.parameters then converted_func.parameters = func_decl.parameters end
      -- Note: response field is not supported in Gemini API according to the TypeScript code
      result.functionDeclarations[i] = converted_func
    end
  end

  -- Handle googleSearch
  if tool.googleSearch then
    result.googleSearch = vim.empty_dict() -- Ensure it's encoded as an object {} not an array []
  end

  -- Handle googleSearchRetrieval
  if tool.googleSearchRetrieval then
    result.googleSearchRetrieval = {}
    if tool.googleSearchRetrieval.dynamicRetrievalConfig then
      result.googleSearchRetrieval.dynamicRetrievalConfig = {}

      if tool.googleSearchRetrieval.dynamicRetrievalConfig.mode then
        result.googleSearchRetrieval.dynamicRetrievalConfig.mode =
          tool.googleSearchRetrieval.dynamicRetrievalConfig.mode
      end

      if tool.googleSearchRetrieval.dynamicRetrievalConfig.dynamicThreshold then
        result.googleSearchRetrieval.dynamicRetrievalConfig.dynamicThreshold =
          tool.googleSearchRetrieval.dynamicRetrievalConfig.dynamicThreshold
      end
    end
  end

  -- Handle codeExecution
  if tool.codeExecution then result.codeExecution = tool.codeExecution end

  return result
end

--- Creates the full API request body with optional generation config and tools.
--- @param params table The base parameters (like contents).
--- @param generation_config GeminiGenerationConfig|nil Optional generation configuration.
--- @return table The complete API request body.
local function build_request_body(params, generation_config)
  local body = params

  if generation_config then
    body.generationConfig = generation_config

    -- Handle tools configuration
    if generation_config.tools and #generation_config.tools > 0 then
      -- Create a new array for the converted tools
      local converted_tools = {}

      -- Convert each tool to the format expected by the API
      for i, tool in ipairs(generation_config.tools) do
        converted_tools[i] = convert_tool(tool)
      end

      -- Replace the tools in the generation config with the converted tools
      -- API Error: Invalid JSON payload received. Unknown name \"googleSearch\" at 'tools[0]': {"tools":[{"googleSearch":[]}],"contents":[{"role":"user","parts":[{"text":""}]},{"role":"model","parts":[{"text":"Hello"}]}],"generationConfig":{"thinkingConfig":{"includeThoughts":true}}}
      body.tools = converted_tools

      -- Remove tools from generationConfig as it should be at the top level
      body.generationConfig.tools = nil
    end

    -- Handle toolConfig if present
    if generation_config.toolConfig then
      body.toolConfig = {}

      if generation_config.toolConfig.functionCallingConfig then
        body.toolConfig.functionCallingConfig = {}

        if generation_config.toolConfig.functionCallingConfig.mode then
          body.toolConfig.functionCallingConfig.mode = generation_config.toolConfig.functionCallingConfig.mode
        end

        if generation_config.toolConfig.functionCallingConfig.allowedFunctionNames then
          body.toolConfig.functionCallingConfig.allowedFunctionNames =
            generation_config.toolConfig.functionCallingConfig.allowedFunctionNames
        end
      end

      -- Remove toolConfig from generationConfig as it should be at the top level
      body.generationConfig.toolConfig = nil
    end
  end

  return body
end

local function construct_metadata_message(metadata)
  local message = ""
  local footnoted_text = nil

  -- Helper function to get segment texts for a specific chunk index
  local function grounding_support_texts_from_chunk_index(chunk_index)
    local chunk_index_segment_texts = {}
    for _, support in ipairs(metadata.groundingSupports or {}) do
      if support.groundingChunkIndices and vim.tbl_contains(support.groundingChunkIndices, chunk_index) then
        if support.segment and support.segment.text then
          table.insert(chunk_index_segment_texts, support.segment.text)
        end
      end
    end
    if #chunk_index_segment_texts > 0 then return chunk_index_segment_texts end
    return nil
  end

  -- Process groundingSupports to create footnote references
  if metadata.groundingSupports and #metadata.groundingSupports > 0 then
    footnoted_text = metadata.text or ""

    for _, support in ipairs(metadata.groundingSupports) do
      if
        support.segment
        and support.segment.text
        and support.groundingChunkIndices
        and #support.groundingChunkIndices > 0
      then
        local segment_text = support.segment.text

        -- Create footnote references like [1,2] for each segment
        local footnote_refs = {}
        for _, idx in ipairs(support.groundingChunkIndices) do
          table.insert(footnote_refs, tostring(idx + 1))
        end

        local footnote_str = string.format("[%s]", table.concat(footnote_refs, ","))

        -- Find the exact position of the segment text in the full text
        local start_pos, end_pos = footnoted_text:find(segment_text, 1, true)

        if start_pos then
          -- Insert the footnote reference after the segment text
          footnoted_text = footnoted_text:sub(1, end_pos) .. footnote_str .. footnoted_text:sub(end_pos + 1)

          -- Debug output
          -- stylua: ignore
          -- vim.api.nvim_echo({ { vim.inspect({
          --   segment_text = segment_text,
          --   footnote_str = footnote_str,
          --   start_pos = start_pos,
          --   end_pos = end_pos,
          --   footnoted_text = footnoted_text,
          -- }), "Normal" } }, true, {})
        else
          -- If exact match fails, try with pattern escaping as fallback
          local escaped_text = segment_text:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
          footnoted_text = footnoted_text:gsub(escaped_text, segment_text .. footnote_str, 1)
          
          -- Debug output
          -- stylua: ignore
          vim.api.nvim_echo({ { vim.inspect({
            escaped_text = escaped_text,
            footnoted_text = footnoted_text,
          }), "Normal" } }, true, {})
        end
      end
    end
  end

  -- Add sources section
  if metadata.groundingChunks and #metadata.groundingChunks > 0 then
    message = message .. "\n\n### Sources\n"
    for idx, chunk in ipairs(metadata.groundingChunks) do
      if chunk.web and chunk.web.title and chunk.web.uri then
        message = message .. string.format("%d. [%s](%s)\n", idx + 1, chunk.web.title, chunk.web.uri)

        -- Add supporting text reasons if available
        local grounding_support_texts = grounding_support_texts_from_chunk_index(idx)
        if grounding_support_texts and #grounding_support_texts > 0 then
          message = message .. "   Cited for:\n"
          for _, grounding_support_text in ipairs(grounding_support_texts) do
            message = message .. string.format("   > %s\n", grounding_support_text)
          end
        end
      end
    end
  end

  -- Add web search queries section
  if metadata.webSearchQueries and #metadata.webSearchQueries > 0 then
    message = message .. "\n### Web Search Queries\n"
    for _, query in ipairs(metadata.webSearchQueries) do
      message = message .. string.format("* %s\n", query)
    end
  end

  return message, footnoted_text
end

-- --- Important: Also check for grounding metadata if needed ---
-- If you want to access grounding metadata like in the Python example:
-- print(response.candidates[0].grounding_metadata.search_entry_point.rendered_content)
-- You would need to process `item.candidates[1].grounding_metadata` here
-- and potentially pass it to your handler or store it.
-- Note: Grounding metadata is typically only present in the final chunk.
-- The structure is usually `groundingMetadata: { searchEntryPoint: { renderedContent: "..." } }`
---@param candidate GeminiCandidate The candidate response to check for grounding metadata
local function check_grounding_metadata(candidate, current_text)
  if candidate.groundingMetadata then
    -- Add the current text to the metadata for footnoting
    if current_text then candidate.groundingMetadata.text = current_text end

    local metadata_message, footnoted_text = construct_metadata_message(candidate.groundingMetadata)

    -- Return both the metadata message and the footnoted text if available
    return metadata_message, footnoted_text
  end
  return nil, nil
end

---@class Provider
---@field request_completion fun(handler: table, params: table): any

--- Creates a Gemini model provider with the specified configuration
---@param model_name string The name of the model to use (e.g., "gemini-1.5-flash")
---@param generation_config GeminiGenerationConfig|nil Optional generation configuration
---@return Provider The configured Gemini model provider
function M.model(model_name, generation_config)
  generation_config = generation_config or nil
  ---@type Provider
  ---@diagnostic disable-next-line: missing-fields
  return {
    request_completion = function(handler, params)
      local body = build_request_body(params, generation_config)

      -- Debug request
      -- local json_body_string = vim.json.encode(body)
      -- vim.notify("Request JSON Body:\n" .. json_body_string, vim.log.levels.INFO)

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
          -- reference: js-genai/src/models.ts:168
          local item = util.json.decode(msg.data)
          require("util.log").log("gemini", vim.fn.json_encode(item))
          if item and item.candidates then
            local candidate
            local current_text = ""

            if item.candidates[1] then
              candidate = item.candidates[1]
              if candidate.content and candidate.content.parts then
                local text_parts = candidate.content.parts
                -- local is_last_message = candidate.finishReason == "STOP" or candidate.finishReason == "SAFETY"
                for _, part in ipairs(text_parts) do
                  -- Handle thoughts
                  if part.thought then
                    -- Clean up thought text by removing <br> tags and excessive newlines at the end
                    -- Also replace the first \n\n after the heading with a colon
                    -- Clean up thought text by removing <br> tags and excessive newlines
                    local cleaned_thought = part.text

                    -- Remove <br> tags
                    cleaned_thought = cleaned_thought:gsub("<br>", "")

                    -- Remove trailing newlines
                    cleaned_thought = cleaned_thought:gsub("\n+$", "")

                    -- Replace the first \n\n with a colon if it follows a heading pattern
                    cleaned_thought = cleaned_thought:gsub("^%*%*(.-)%*%*\n\n", "**%1**: ")

                    if not in_reasoning_tag then
                      handler.on_partial("\n\n<llm_sidekick_thinking>\n")
                      in_reasoning_tag = true
                    else
                      -- Add a single newline between thoughts
                      handler.on_partial("\n")
                    end
                    --stylua: ignore
                    vim.api.nvim_echo({ {"Thought: ", "Title"},{ cleaned_thought, "Normal" } }, true, {})
                    handler.on_partial(cleaned_thought)
                  -- Handle tool calls
                  elseif part.functionCall then
                    -- Increment the module-level counter for tool calls
                    tool_call_counter = tool_call_counter + 1
                    local message = string.format(
                      "Tool call (%d): %s with parameters: %s",
                      tool_call_counter,
                      part.functionCall.name,
                      vim.inspect(part.functionCall.args)
                    )
                    handler.on_partial(message)
                  -- Handle text parts
                  else
                    -- The API might return different part types, only handle text for now
                    if part.text then
                      current_text = current_text .. part.text
                      if in_reasoning_tag then
                        in_reasoning_tag = false
                        handler.on_partial("\n</llm_sidekick_thinking>\n\n")
                      end
                      handler.on_partial(part.text)
                    end
                  end
                end
              end

              -- Check for grounding metadata and footnotes
              local metadata_message, footnoted_text = check_grounding_metadata(candidate, current_text)

              if metadata_message then
                handler.on_partial(metadata_message)
              elseif footnoted_text then
                --stylua: ignore
                vim.api.nvim_echo({ { "Footnoted text:\n", "Title" },{ vim.inspect({ footnoted_text = footnoted_text }), "Normal" } }, true, {})
                handler.on_partial(footnoted_text)
              end
            end

            -- Candidate might exist but be blocked etc.
            if item.promptFeedback and item.promptFeedback.blockReason then
              if candidate and candidate.finishReason == "SAFETY" then
                --stylua: ignore
                vim.api.nvim_echo({ { "Safety Ratings:\n", "Title" }, { vim.inspect({ safetyRatings = candidate.safetyRatings }), "Normal" } }, true, {})
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
              if item and item.usageMetadata then
                handler.on_error("Got usageMetadata: " .. vim.inspect(item.usageMetadata))
              else
                vim.api.nvim_echo({ { "Item:\n", "Title" }, { vim.inspect({ item = item }), "Normal" } }, true, {})
                handler.on_error("Unrecognized SSE response or empty candidates")
              end
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
