-- [nfnl] Compiled from fnl/diary/init.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("diary.nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("diary.nfnl.core")
local fs = autoload("diary.nfnl.fs")
local config = {["diary-dir"] = "~/diary/"}
local function member_3f(val, list)
  local function _2_(_241)
    return (_241 == val)
  end
  return core.complement(core["empty?"])(core.filter(_2_, list))
end
local function list_bufs_match(test)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local val_23_auto
    if (vim.api.nvim_buf_is_loaded(buf) and test(buf)) then
      val_23_auto = buf
    else
      val_23_auto = nil
    end
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function list_bufs_match_dir(path)
  local function _5_(buf)
    return string.find(vim.api.nvim_buf_get_name(buf), path, 1, true)
  end
  return list_bufs_match(_5_)
end
local function filter_current_tab_wins(wins)
  local current_wins = vim.api.nvim_tabpage_list_wins(0)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, win in ipairs(wins) do
    local val_23_auto
    if member_3f(win, current_wins) then
      val_23_auto = nil
    else
      val_23_auto = win
    end
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function list_wins_with_bufs(bufs)
  if unpack(bufs) then
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local val_23_auto
      if (vim.api.nvim_win_is_valid(win) and member_3f(vim.api.nvim_win_get_buf(win), bufs)) then
        val_23_auto = win
      else
        val_23_auto = nil
      end
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    return tbl_21_auto
  else
    return {}
  end
end
local function get_win_match_dir(path)
  local path0 = vim.fn.expand(path)
  local bufs = list_bufs_match_dir(path0)
  return unpack(filter_current_tab_wins(list_wins_with_bufs(bufs)))
end
local function tab_view(name)
  local dir_3f = (vim.fn.isdirectory(name) == 1)
  local dir
  if dir_3f then
    dir = name
  else
    dir = vim.fs.dirname(name)
  end
  local memo_tab_win_2_auto = get_win_match_dir(dir)
  if memo_tab_win_2_auto then
    vim.fn.win_gotoid(memo_tab_win_2_auto)
    if not dir_3f then
      return vim.cmd.edit(name)
    else
      return nil
    end
  else
    if dir_3f then
      vim.cmd.tabnew()
    else
      vim.cmd.tabnew(name)
    end
    return vim.cmd.tcd(dir)
  end
end
local function tab_view_diary(filename)
  return tab_view((config["diary-dir"] .. filename))
end
local function tab_new_diary()
  local diary = (os.date("%Y-%m-%d") .. ".md")
  return tab_view_diary(diary)
end
local function get_diary_file_list()
  local tbl_21_auto = {}
  local i_22_auto = 0
  for name, type in vim.fs.dir(config["diary-dir"]) do
    local val_23_auto
    if ((type == "file") and string.match(name, "^%d%d%d%d%-%d%d%-%d%d%.md$")) then
      val_23_auto = name
    else
      val_23_auto = nil
    end
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function review_random_diary()
  local diary_files = get_diary_file_list()
  local rand_index = math.random(#diary_files)
  local rand_diary = diary_files[rand_index]
  return tab_view_diary(rand_diary)
end
local function find_yesterday_once_more_diary()
  local pattern = string.gsub(os.date("%m-%d"), "%-", "%%-")
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, diary in ipairs(get_diary_file_list()) do
    local val_23_auto
    if string.match(diary, pattern) then
      val_23_auto = diary
    else
      val_23_auto = nil
    end
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function gen_location_list(filenames)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, filename in ipairs(filenames) do
    local val_23_auto
    do
      local diary = (config["diary-dir"] .. filename)
      val_23_auto = {filename = diary, lnum = 0, col = 0, text = fs["read-first-line"](diary)}
    end
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function review_yesterday_once_more()
  local matched_diaries = find_yesterday_once_more_diary()
  local _20_ = #matched_diaries
  if (_20_ == 0) then
    return nil
  elseif (_20_ == 1) then
    return tab_view_diary(core.first(matched_diaries))
  else
    local _ = _20_
    vim.fn.setloclist(0, gen_location_list(matched_diaries))
    return vim.cmd.lopen()
  end
end
local function group_diary()
  local results = {}
  for _, diary in ipairs(get_diary_file_list()) do
    local _let_22_ = vim.split(diary, "-")
    local year = _let_22_[1]
    local month = _let_22_[2]
    if not results[year] then
      results[year] = {}
    else
    end
    if not results[year][month] then
      results[year][month] = {}
    else
    end
    table.insert(results[year][month], diary)
  end
  return results
end
local function desc_strnum(xs)
  local function _25_(_241, _242)
    return (tonumber(_241) > tonumber(_242))
  end
  table.sort(xs, _25_)
  return xs
end
local function parse_diary_day(diary)
  return tonumber(string.match(diary, "(%d%d)%.md$"))
end
local function desc_diary_monthly(xs)
  local function _26_(_241, _242)
    return (parse_diary_day(_241) > parse_diary_day(_242))
  end
  table.sort(xs, _26_)
  return xs
end
local function write_diary_index()
  local group = group_diary()
  local outfile = "index.md"
  do
    local fout = io.open((config["diary-dir"] .. outfile), "w")
    local function close_handlers_12_auto(ok_13_auto, ...)
      fout:close()
      if ok_13_auto then
        return ...
      else
        return error(..., 0)
      end
    end
    local function _28_()
      fout:write("# Diary\n\n")
      for _, year in ipairs(desc_strnum(core.keys(group))) do
        fout:write(("## " .. year .. "\n\n"))
        for _0, month in ipairs(desc_strnum(core.keys(group[year]))) do
          local full_month_name = os.date("%B", os.time({year = year, month = month, day = 1}))
          fout:write(("### " .. full_month_name .. "\n\n"))
          for _1, diary in ipairs(desc_diary_monthly(group[year][month])) do
            local first_line = fs["read-first-line"]((config["diary-dir"] .. diary))
            local title = string.match(first_line, "^#+%s+(.+)")
            fout:write(("- [" .. (title or vim.fn.trim(diary, ".md", 2)) .. "](" .. diary .. ")\n"))
          end
          fout:write("\n")
        end
      end
      return nil
    end
    close_handlers_12_auto(_G.xpcall(_28_, (package.loaded.fennel or _G.debug or {}).traceback))
  end
  return tab_view_diary(outfile)
end
local function setup(opts)
  if opts["diary-dir"] then
    config["diary-dir"] = (vim.fs.normalize(opts["diary-dir"]) .. "/")
  else
  end
  vim.api.nvim_create_user_command("DiaryNew", tab_new_diary, {})
  vim.api.nvim_create_user_command("DiaryReviewRandom", review_random_diary, {})
  vim.api.nvim_create_user_command("YesterdayOnceMore", review_yesterday_once_more, {})
  return vim.api.nvim_create_user_command("DiaryGenerateLinks", write_diary_index, {})
end
return {setup = setup, tab_view = tab_view}
