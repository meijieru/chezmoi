local normal_command = require("core.utils.keymap").normal_command

return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
    event = "User AstroGitFile",
  },

  { import = "astrocommunity.git.gitlinker-nvim" },
  {
    "gitlinker.nvim",
    opts = {
      callbacks = {
        ["direct.meijieru.com"] = function(url_data)
          url_data.host = "gitea.meijieru.com"
          return require("gitlinker.hosts").get_gitea_type_url(url_data)
        end,
      },
    },
    -- TODO(meijieru): use snacks.gitbrowse
    enabled = true,
  },

  { import = "astrocommunity.git.diffview-nvim" },
  {
    "diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        view = {
          default = {
            winbar_info = true,
          },
          merge_tool = {
            layout = "diff3_mixed",
            winbar_info = true,
          },
          file_history = {
            winbar_info = true,
          },
        },
        keymaps = {
          file_panel = {
            ["cc"] = normal_command "Git commit",
            ["q"] = normal_command "tabclose",
          },
          file_history_panel = {
            ["q"] = normal_command "tabclose",
          },
        },
      })
    end,
  },

  { import = "astrocommunity.git.mini-diff" },
  {
    "mini.diff",
    opts = function()
      local mini_diff = require "mini.diff"
      local mercurial_source = {
        name = "mercurial",

        attach = function(buf_id)
          local buf_path = vim.api.nvim_buf_get_name(buf_id)
          if buf_path == "" then return mini_diff.fail_attach(buf_id) end

          -- Get directory of the buffer file
          local buf_dir = vim.fs.dirname(buf_path)

          -- Find Mercurial root directory
          local repo_root_result = vim.system({ "hg", "root" }, { cwd = buf_dir, text = true }):wait()

          if repo_root_result.code ~= 0 then return mini_diff.fail_attach(buf_id) end
          -- vim.print(repo_root_result.stdout:gsub("\n$", "")[1])
          -- local repo_root = vim.fs.normalize(repo_root_result.stdout:gsub("\n$", "")[1])

          local repo_root_stdout = (repo_root_result.stdout or ""):gsub("\n$", "")
          local repo_root = vim.fs.normalize(repo_root_stdout)
          vim.print(repo_root)

          -- Get relative path within repo
          local rel_path = vim.fn.fnamemodify(buf_path, ":." .. repo_root)

          -- Check if file is tracked
          local status_result = vim.system({ "hg", "status", "-A", rel_path }, { cwd = repo_root, text = true }):wait()

          if status_result.code ~= 0 or status_result.stdout == "" then return mini_diff.fail_attach(buf_id) end

          -- Return success with necessary data
          return {
            repo_root = repo_root,
            rel_path = rel_path,
          }
        end,

        detach = function(buf_id, data)
          -- Nothing to clean up
        end,

        apply_hunks = function(buf_id, hunks, data)
          -- Get current buffer content
          local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

          -- Apply hunks to create new content
          local new_lines = MiniDiff.apply_hunks(lines, hunks)
          local new_content = table.concat(new_lines, "\n")

          -- Use hg import to apply changes
          local import_result = vim
            .system({
              "hg",
              "import",
              "--no-commit",
              "--quiet",
              "--bypass",
              "--partial",
              "--similarity",
              "100",
              "-",
              data.rel_path,
            }, {
              cwd = data.repo_root,
              stdin = new_content,
            })
            :wait()

          if import_result.code ~= 0 then
            vim.notify(
              "Failed to apply changes via Mercurial: " .. (import_result.stderr or "unknown error"),
              vim.log.levels.ERROR,
              { title = "mini.diff" }
            )
          end
        end,
      }

      return {
        source = { mini_diff.gen_source.git(), mercurial_source },
        view = {
          style = "number",
        },
        mappings = {
          apply = "",
          reset = "",
          textobject = "",
          goto_first = "",
          goto_prev = "",
          goto_next = "",
          goto_last = "",
        },
        opts = {
          wrap_goto = true,
        },
      }
    end,
    event = { "User AstroFile" },
  },
}
