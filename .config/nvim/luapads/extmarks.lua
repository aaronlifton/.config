local bufnr = 125
local ns_ids = vim.api.nvim_get_namespaces()
for name, id in pairs(ns_ids) do
	-- local extmarks = vim.api.nvim_buf_get_extmarks(0, id, 0, -1, { details = true })
	local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, id, 0, -1, { details = true })
	if #extmarks > 0 then
		print("Namespace: " .. name .. " (ID: " .. id .. ")")
		for _, mark in ipairs(extmarks) do
			print("  Line " .. mark[2] .. ", Col " .. mark[3] .. ": " .. vim.inspect(mark[4]))
		end
	end
end

-- "Namespace: lsp-lens (ID: 138)"
-- "Namespace: rubocop/diagnostic/underline (ID: 57)"
-- "Namespace: rubocop/diagnostic/virtual_text (ID: 58)"
-- "Namespace: vim_lsp_semantic_tokens:1 (ID: 63)"
-- "Namespace: rubocop/diagnostic/signs (ID: 59)"
-- '  Line 9, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "             󰌹 Ref: 243", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 13, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "           󰌹 Ref: 258", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 14, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "          󰌹 Ref: 48", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 20, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 21, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 22, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 23, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 24, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 25, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
-- '  Line 26, Col 0: {\n  ns_id = 138,\n  priority = 4096,\n  right_gravity =
-- true,\n  virt_lines = { { { "        󰌹 Ref: 411", "LspLens" } } },\n
-- virt_lines_above = true,\n  virt_lines_leftcol = false\n}'
