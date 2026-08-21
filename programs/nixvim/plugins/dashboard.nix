{
  programs.nixvim.extraConfigLua = ''
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- 指定 cwd で Telescope のファイル検索を起動し、ファイル選択時に Neo-tree も開く
    local function find_files_with_neotree(cwd)
      require("telescope.builtin").find_files({
        cwd = cwd,
        attach_mappings = function(prompt_bufnr, map)
          local open_and_neotree = function()
            actions.select_default(prompt_bufnr)
            vim.schedule(function()
              local current_win = vim.api.nvim_get_current_win()
              vim.cmd("Neotree reveal")
              if vim.api.nvim_win_is_valid(current_win) then
                vim.api.nvim_set_current_win(current_win)
              end
            end)
          end
          map("i", "<CR>", open_and_neotree)
          map("n", "<CR>", open_and_neotree)
          return true
        end,
      })
    end

    _G.dashboard_project_select_handler = function(path)
      if not path or path == "" then return end
      vim.fn.chdir(path)
      find_files_with_neotree(path)
    end

    _G.dashboard_project_file_neotree = function()
      require("telescope").extensions.projects.projects({
        attach_mappings = function(prompt_bufnr, map)
          local on_project_select = function()
            local entry = action_state.get_selected_entry()
            if not entry then return end
            local project_path = entry.value or entry.path
            actions.close(prompt_bufnr)
            vim.fn.chdir(project_path)
            find_files_with_neotree(project_path)
          end
          map("i", "<CR>", on_project_select)
          map("n", "<CR>", on_project_select)
          return true
        end,
      })
    end
  '';

  programs.nixvim.plugins.dashboard = {
    enable = true;
    settings = {
      change_to_vcs_root = true;
      theme = "hyper";
      config = {
        footer = [
          "Made with ❤️"
        ];
        header = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        mru = {
          limit = 10;
        };
        project = {
          enable = true;
          limit = 10;
          action = {
            __raw = "function(path) _G.dashboard_project_select_handler(path) end";
          };
        };
        shortcut = [
          {
            action = {
              __raw = "function(path) vim.cmd('Telescope find_files') end";
            };
            desc = "Files";
            group = "Label";
            icon = " ";
            icon_hl = "@variable";
            key = "f";
          }
          {
            action = "lua _G.dashboard_project_file_neotree()";
            desc = " Projects";
            group = "DiagnosticHint";
            key = "p";
          }
        ];
      };
    };
  };
}
