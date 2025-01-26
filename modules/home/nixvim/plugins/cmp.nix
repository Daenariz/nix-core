{ config, lib, ... }:

let
  cfg = config.programs.nixvim;
  plugin = cfg.plugins.cmp;

  inherit (lib) mkDefault mkIf;
in
{
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = mkDefault true;
        settings = {
          autoEnableSources = mkDefault true;
          experimental.ghost_text = mkDefault true;
          snippet.expand = mkDefault "luasnip";
          formatting.fields = mkDefault [
            "kind"
            "abbr"
            "menu"
          ];
          sources = mkDefault [
            { name = "git"; }
            { name = "nvim_lsp"; }
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            { name = "copilot"; }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];
          mapping = mkDefault {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
              })
            '';
          };
        };
      };
      cmp-buffer = mkIf plugin.enable { enable = mkDefault true; };
      cmp-cmdline = mkIf plugin.enable { enable = mkDefault false; }; # autocomplete for cmdline
      cmp-nvim-lsp = mkIf plugin.enable { enable = mkDefault true; }; # lsp
      cmp-path = mkIf plugin.enable { enable = mkDefault true; }; # file system paths
      cmp_luasnip = mkIf plugin.enable { enable = mkDefault true; }; # snippets
      copilot-cmp = mkIf plugin.enable { enable = mkDefault true; };
    };
  };
}
