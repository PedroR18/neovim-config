local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({

	on_init = function(new_client, _)
		new_client.offset_encoding = "utf-32"
	end,

	sources = {
		require("null-ls").builtins.formatting.prettier.with({
			extra_filetypes = { "svelte" },
		}),
		require("null-ls").builtins.formatting.dart_format,
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.clang_format,
	},

	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})
