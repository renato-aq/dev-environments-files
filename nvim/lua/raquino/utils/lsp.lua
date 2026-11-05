local M = {}

-- The source definition in TypeScript, skipping the .d.ts. The implementation in other languages.
function M.source_definition()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not client then
		Snacks.picker.lsp_implementations()
		return
	end

	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("workspace/executeCommand", {
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			vim.notify("No source definition found", vim.log.levels.WARN)
			return
		end
		vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
	end)
end

return M
