{
  config,
  pkgs,
  ...
}:

let
  # Runner plugin (SugarHashira/bruno.nvim): creates :Bruno* commands
  brunoRunner = pkgs.vimUtils.buildVimPlugin {
    pname = "bruno-nvim";
    version = "2026-03-04";
    src = pkgs.fetchFromGitHub {
      owner = "SugarHashira";
      repo = "bruno.nvim";
      rev = "5e6675d0a1efa5d9e71e890e5a03af54aecddcd5";
      hash = "sha256-100odCUDN28BZT/kqVpJdhYMlz3iLrrw4ll1+TCFxFM=";
    };
  };
  # Syntax plugin (kristoferssolo/bruno.nvim): .bru filetype, queries, folding
  brunoSyntax = pkgs.vimUtils.buildVimPlugin {
    pname = "bruno-syntax-nvim";
    version = "2026-03-18";
    src = pkgs.fetchFromGitHub {
      owner = "kristoferssolo";
      repo = "bruno.nvim";
      rev = "305c5081f35e541fed846fbd468b72b12dbc2aaa";
      hash = "sha256-Qg8MJuK+q5Zd+/HCQWQWSjsihfY1jSgWnr3w6MzZZks=";
    };
    # The plugin calls nvim-treesitter's legacy `get_parser_configs` API at
    # startup; it's gone in the 2026 rewrite. Parser is installed
    # declaratively via grammarPackages, so skip registration on new API.
    patches = [
      (pkgs.writeText "bruno-treesitter-new-api.patch" ''
        --- a/lua/bruno/treesitter.lua
        +++ b/lua/bruno/treesitter.lua
        @@ -15,3 +15,3 @@
         	local ok, parsers = pcall(require, "nvim-treesitter.parsers")
        -	if not ok then
        +	if not ok or not parsers.get_parser_configs then
         		return
         	end
      '')
    ];
  };
  # Both plugins ship lua/bruno/init.lua, so merge them (runner wins the
  # collision; syntax plugin's ftdetect/ftplugin/queries are all unique).
  brunoPlugins = pkgs.symlinkJoin {
    name = "bruno-nvim-plugins";
    paths = [
      brunoRunner
      brunoSyntax
    ];
  };
  brunoGrammar = pkgs.tree-sitter.buildGrammar {
    language = "bruno";
    version = "0.1.0";
    src = pkgs.fetchFromCodeberg {
      owner = "kristoferssolo";
      repo = "tree-sitter-bruno";
      rev = "c6d42e349353f02ad051dd9c88a38df639ef688f";
      hash = "sha256-7XWWAT0PB29TllAo0HWAgGmdflmmtyFscl6XSA12tpU=";
    };
    # The syntax plugin ships the same queries; drop the grammar's copy to
    # avoid a plugin-dir collision.
    postInstall = "rm -rf $out/queries";
  };
in
{
  programs.nixvim = {
    extraPlugins = [
      brunoPlugins
      pkgs.vimPlugins.plenary-nvim
    ];

    plugins.treesitter = {
      grammarPackages = config.programs.nixvim.plugins.treesitter.package.allGrammars ++ [ brunoGrammar ];
      languageRegister.bruno = "bruno";
    };

    extraConfigLua = ''
      require("bruno").setup({
        collection_paths = {},
        picker = "telescope",
        default_view = "body",
      })
    '';

    keymaps = [
      {
        key = "<leader>hr";
        action = "<cmd>BrunoRun<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Run request";
        };
      }
      {
        key = "<leader>hR";
        action = "<cmd>BrunoReplay<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Replay last request";
        };
      }
      {
        key = "<leader>he";
        action = "<cmd>BrunoEnv<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Switch environment";
        };
      }
      {
        key = "<leader>hs";
        action = "<cmd>BrunoSearch<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Search requests";
        };
      }
      {
        key = "<leader>ht";
        action = "<cmd>BrunoToggleView<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Toggle view";
        };
      }
      {
        key = "<leader>hc";
        action = "<cmd>BrunoCopy<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Copy as cURL";
        };
      }
      {
        key = "<leader>hi";
        action = "<cmd>BrunoInspect<cr>";
        mode = "n";
        options = {
          desc = "Bruno: Inspect last request";
        };
      }
    ];
  };
}
