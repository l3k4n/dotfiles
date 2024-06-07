local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

---@class ServerConfig
---@field cmd string[]|nil
---@field filetypes string[]|nil
---@field settings any|nil

---@class ServerConfigTable
---@field [string] ServerConfig

local M = {}

---@param servers ServerConfigTable
function M.setup_servers(servers)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
      function(server_name)
        local server = require('lspconfig')[server_name]
        local server_config = servers[server_name] or {}
        local setup = {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = server_config.settings,
          filetypes = server_config.filetypes
        }

        -- `setup.cmd` must not be nil
        if (server_config.cmd ~= nil) then
          setup.cmd = server_config.cmd
        end

        server.setup(setup)
      end,
    }
  })
end

return M
