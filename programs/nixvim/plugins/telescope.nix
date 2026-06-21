{
  programs.nixvim.plugins.telescope = {
    enable = true;
    settings = {
      defaults = {
        file_ignore_patterns = [
          # .gitディレクトリを除外
          "^.git/"
        ];
      };
      pickers = {
        find_files = {
          # 隠しファイルを表示する
          hidden = true;
        };
      };
    };
    keymaps = {
      # find word
      "<leader>fw" = {
        action = "live_grep";
      };
      # find file
      "<leader>ff" = {
        action = "find_files";
      };
    };
  };
}
