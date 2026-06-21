{
  programs.nixvim.plugins = {
    # Core plugins
    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      settings = {
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
    };

    # Treesitter addons
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
        min_window_height = 20;
      };
    };

    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = {
              query = "@function.outer";
              desc = "Select outer function";
            };
            "if" = {
              query = "@function.inner";
              desc = "Select inner function";
            };
            "ac" = {
              query = "@class.outer";
              desc = "Select outer class";
            };
            "ic" = {
              query = "@class.inner";
              desc = "Select inner class";
            };
            "aa" = {
              query = "@parameter.outer";
              desc = "Select outer parameter";
            };
            "ia" = {
              query = "@parameter.inner";
              desc = "Select inner parameter";
            };
            "ai" = {
              query = "@conditional.outer";
              desc = "Select outer conditional";
            };
            "ii" = {
              query = "@conditional.inner";
              desc = "Select inner conditional";
            };
            "al" = {
              query = "@loop.outer";
              desc = "Select outer loop";
            };
            "il" = {
              query = "@loop.inner";
              desc = "Select inner loop";
            };
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]f" = {
              query = "@function.outer";
              desc = "Next function start";
            };
            "]c" = {
              query = "@class.outer";
              desc = "Next class start";
            };
            "]a" = {
              query = "@parameter.inner";
              desc = "Next parameter start";
            };
          };
          goto_next_end = {
            "]F" = {
              query = "@function.outer";
              desc = "Next function end";
            };
            "]C" = {
              query = "@class.outer";
              desc = "Next class end";
            };
          };
          goto_previous_start = {
            "[f" = {
              query = "@function.outer";
              desc = "Previous function start";
            };
            "[c" = {
              query = "@class.outer";
              desc = "Previous class start";
            };
            "[a" = {
              query = "@parameter.inner";
              desc = "Previous parameter start";
            };
          };
          goto_previous_end = {
            "[F" = {
              query = "@function.outer";
              desc = "Previous function end";
            };
            "[C" = {
              query = "@class.outer";
              desc = "Previous class end";
            };
          };
        };
        swap = {
          enable = true;
          swap_next = {
            "<leader>sa" = {
              query = "@parameter.inner";
              desc = "Swap parameter with next";
            };
          };
          swap_previous = {
            "<leader>sA" = {
              query = "@parameter.inner";
              desc = "Swap parameter with previous";
            };
          };
        };
      };
    };
  };
}
