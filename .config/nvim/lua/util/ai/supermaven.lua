--- @class util.ai.supermaven
local M = {}

function M.override_accept_suggestion()
  local u = require("supermaven-nvim.util")
  CompletionPreview = require("supermaven-nvim.completion_preview")

  ---@diagnostic disable-next-line: duplicate-set-field
  CompletionPreview.on_accept_suggestion = function(is_partial)
    --
    local accept_completion = CompletionPreview:accept_completion_text(is_partial)
    if accept_completion ~= nil and accept_completion.is_active then
      local completion_text = accept_completion.completion_text
      local prior_delete = accept_completion.prior_delete
      local cursor = vim.api.nvim_win_get_cursor(0)
      local end_col
      local original_completion_text = completion_text
      if is_partial then
        -- local prior_text = vim.api.nvim_get_current_line():sub(1, cursor[2] - prior_delete)
        local after_text = vim.api.nvim_get_current_line():sub(cursor[2] + 1)
        -- completion_text = completion_text .. vim.api.nvim_get_current_line():sub(cursor[2] + 1)
        completion_text = completion_text .. after_text
        end_col = cursor[2] + #completion_text
      else
        end_col = vim.fn.col("$")
      end
      vim.api.nvim_echo({
        {
          vim.inspect({
            completion_text = completion_text,
            end_col = end_col,
            cursor = cursor,
            prior_delete = prior_delete,
          }),
        },
      }, true, {})
      local range = {
        start = {
          line = cursor[1] - 1,
          character = math.max(cursor[2] - prior_delete, 0),
        },
        ["end"] = {
          line = cursor[1] - 1,
          -- character = vim.fn.col("$"),
          character = end_col,
        },
      }

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Space><Left><Del>", true, false, true), "n", false)
      vim.lsp.util.apply_text_edits(
        { { range = range, newText = completion_text } },
        vim.api.nvim_get_current_buf(),
        "utf-8"
      )

      local lines = u.line_count(completion_text)
      local last_line = u.get_last_line(completion_text)
      local new_cursor_pos
      -- local last_cursor_pos = { cursor[2]}
      if is_partial then
        new_cursor_pos = { cursor[1], cursor[2] + #original_completion_text }
      else
        new_cursor_pos = { cursor[1] + lines, cursor[2] + #last_line + 1 }
      end
      vim.api.nvim_win_set_cursor(0, new_cursor_pos)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
    end
  end
end
function M.accept_suggestion(only_one_word)
  local suggestion = require("supermaven-nvim.completion_preview")

  if suggestion.has_suggestion() then
    -- There's a suggestion being displayed!

    local shadow_text = suggestion.inlay_instance.completion_text

    if only_one_word then
      if shadow_text:sub(1, 1) == "\n" then
        -- The text starts with \n, we run the native completion
        suggestion.on_accept_suggestion(true)
        return
      end

      shadow_text = shadow_text:match("^.-%f[a-z0-9_][a-z0-9_]+")
      if shadow_text == nil then
        -- We can't find the end of the next word... We just run the native completion
        suggestion.on_accept_suggestion()
        return
      end

      -- We found the end of the next word, we insert it, without removing anything from the line.
      vim.fn.feedkeys(shadow_text, "i")
      return
    end

    -- If the shadow_text starts with \n, we just trigger the completion
    if shadow_text:sub(1, 1) == "\n" then
      suggestion.on_accept_suggestion()
      return
    end

    local line_after_cursor = suggestion.inlay_instance.line_after_cursor

    if line_after_cursor:len() == 0 then
      suggestion.on_accept_suggestion()
      return
    end

    -- Otherwise, we check if the completion end is the same as the end of the current line
    local identical_count = 0
    for i = 1, #shadow_text do
      local current_char = line_after_cursor:sub(line_after_cursor:len() - i, line_after_cursor:len() - i)
      local shadow_char = shadow_text:sub(shadow_text:len() - i, shadow_text:len() - i)
      if current_char == shadow_char then
        identical_count = identical_count + 1
      else
        break
      end
    end

    if identical_count == 0 then
      suggestion.on_accept_suggestion()
      return
    end

    local current_col = vim.api.nvim_win_get_cursor(0)[2]

    local amount_to_delete = line_after_cursor:len() - identical_count
    local text_to_feed = shadow_text:sub(1, -identical_count - 2)

    if text_to_feed:len() == 0 and amount_to_delete == 0 then
      -- There's a suggestion which is identical to the end of the line,
      -- We just accept it (a.k.a move the cursor to the end of the line)
      suggestion.on_accept_suggestion()
      return
    end

    print(line_after_cursor:sub(line_after_cursor:len() - identical_count + 1, line_after_cursor:len()))

    -- Feeding <delete amount_to_delete times
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<delete>", true, true, true):rep(amount_to_delete - 1), "n")

    -- Feeding the completion text
    vim.fn.feedkeys(text_to_feed, "n")
  end
end

return M
