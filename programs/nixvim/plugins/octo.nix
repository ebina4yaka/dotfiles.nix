{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>or";
        # Octo search は引数をそのまま GitHub の検索構文として渡す。
        # PR 一覧に「自分がレビュワー」の絞り込みがないのでこちらを使う。
        action = "<cmd>Octo search is:open is:pr review-requested:@me<cr>";
        options = {
          desc = "PRs awaiting my review";
        };
      }
      {
        mode = "n";
        key = "<leader>op";
        action = "<cmd>Octo pr list<cr>";
        options = {
          desc = "List PRs";
        };
      }
      {
        mode = "n";
        key = "<leader>ov";
        action = "<cmd>Octo review start<cr>";
        options = {
          desc = "Start PR review";
        };
      }
      {
        mode = "n";
        key = "<leader>oc";
        action = "<cmd>Octo pr checkout<cr>";
        options = {
          desc = "Checkout PR branch";
        };
      }
    ];
    plugins.octo = {
      enable = true;
      settings = {
        picker = "telescope";
      };
    };
  };
}
