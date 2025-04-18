function()
  local attach = function(buf_id)
    -- Try attaching only once
    if H.hg_cache[buf_id] ~= nil then return false end

    local path = H.get_buf_realpath(buf_id)
    if path == '' then return mini_diff.fail_attach(buf_id) end -- Use mini.diff's failure function

    local buf_dir = vim.fs.dirname(path)
    local repo_root = H.hg_get_repo_root(buf_dir)

    if repo_root == nil then return mini_diff.fail_attach(buf_id) end -- Not in a hg repo

    -- Add to cache
    H.hg_cache[buf_id] = { repo_root = repo_root }
    -- vim.notify("Hg source attached to buffer: " .. buf_id) -- Optional debug notification
    return true
  end

  local detach = function(buf_id)
    if H.hg_cache[buf_id] == nil then return end
    H.hg_cache[buf_id] = nil
    -- vim.notify("Hg source detached from buffer: " .. buf_id) -- Optional debug notification
  end

  local get_reference_lines = function(buf_id)
    local cache = H.hg_cache[buf_id]
    if cache == nil then
        vim.notify("Hg cache miss for buffer " .. buf_id, vim.log.levels.WARN)
        return nil
    end

    local path = H.get_buf_realpath(buf_id)
    if path == '' then return nil end

    local rel_path = H.get_relative_path(path, cache.repo_root)
    if rel_path == nil then
       vim.notify("Failed to get relative path for " .. path, vim.log.levels.WARN)
       return nil
    end

    local content = H.hg_get_reference_content(cache.repo_root, rel_path)
    if content == nil then return nil end -- Error handled inside the function

    local lines = vim.split(content, "\n", { plain = true, trimempty = false })
     -- 移除 vim.split 可能在末尾添加的空字符串
    if #lines > 0 and lines[#lines] == '' then
       table.remove(lines)
    end
    return lines
  end

  local apply_hunks = function(buf_id, hunks)
    local cache = H.hg_cache[buf_id]
    if cache == nil then return end

    local path = H.get_buf_realpath(buf_id)
    if path == '' then return end

    local rel_path = H.get_relative_path(path, cache.repo_root)
    if rel_path == nil then return end

    local patch = H.hg_format_patch(buf_id, hunks, cache.repo_root, rel_path)
    if patch == nil then
      vim.notify("无法生成补丁或无变化", vim.log.levels.INFO)
      return
    end

    if H.hg_apply_patch(cache.repo_root, patch) then
      -- Trigger diff view refresh after successful apply
      MiniDiff.refresh(buf_id)
    end
  end

  return {
    name = 'hg',
    attach = attach,
    detach = detach,
    get_reference_lines = get_reference_lines,
    apply_hunks = apply_hunks,
  }
end
