{
  programs.nixvim.extraConfigLua = ''
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- 引数 'path' を受け取って処理するグローバル関数
    _G.dashboard_project_select_handler = function(path)
      if not path or path == "" then return end

      -- 1. カレントディレクトリを選択されたプロジェクトのパスに変更
      vim.fn.chdir(path)

      -- 2. そのパスを cwd に指定して Telescope のファイル検索を起動
      require("telescope.builtin").find_files({
        cwd = path,
        attach_mappings = function(prompt_bufnr, map)
          
          -- ファイル選択時のEnterキーの挙動を上書き
          local open_and_neotree = function()
            actions.select_default(prompt_bufnr)
            
            -- ファイルが開いた直後に安全にNeo-treeを起動
            vim.schedule(function()
              vim.cmd("Neotree reveal")
            end)
          end

          map("i", "<CR>", open_and_neotree)
          map("n", "<CR>", open_and_neotree)
          return true
        end
      })
    end

    _G.dashboard_project_file_neotree = function()
      -- プロジェクト一覧を取得
      require("telescope").extensions.projects.projects({
        attach_mappings = function(prompt_bufnr, map)
          
          local on_project_select = function()
            local entry = action_state.get_selected_entry()
            if not entry then return end
            
            local project_path = entry.value or entry.path
            actions.close(prompt_bufnr)
            
            -- cwdの変更
            vim.fn.chdir(project_path)
            
            -- 移動先のプロジェクト内でファイル検索
            require("telescope.builtin").find_files({
              cwd = project_path,
              attach_mappings = function(f_prompt_bufnr, f_map)
                local open_and_neotree = function()
                  actions.select_default(f_prompt_bufnr)
                  vim.schedule(function()
                    vim.cmd("Neotree reveal")
                  end)
                end
                
                f_map("i", "<CR>", open_and_neotree)
                f_map("n", "<CR>", open_and_neotree)
                return true
              end
            })
          end
          
          map("i", "<CR>", on_project_select)
          map("n", "<CR>", on_project_select)
          return true
        end
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
          limit = 20;
        };
        project = {
          enable = true;
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
