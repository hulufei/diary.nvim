-- [nfnl] Compiled from fnl/nfnl/callback.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("diary.nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("diary.nfnl.core")
local str = autoload("diary.nfnl.string")
local fs = autoload("diary.nfnl.fs")
local nvim = autoload("diary.nfnl.nvim")
local compile = autoload("diary.nfnl.compile")
local config = autoload("diary.nfnl.config")
local api = autoload("diary.nfnl.api")
local notify = autoload("diary.nfnl.notify")
local function fennel_buf_write_post_callback_fn(root_dir, cfg)
  local function _2_(ev)
    compile["into-file"]({["root-dir"] = root_dir, cfg = cfg, path = fs["full-path"](ev.file), source = nvim["get-buf-content-as-string"](ev.buf)})
    return nil
  end
  return _2_
end
local function supported_path_3f(file_path)
  local _3_
  if core["string?"](file_path) then
    _3_ = not file_path:find("^[%w-]+:/")
  else
    _3_ = nil
  end
  return (_3_ or false)
end
local function fennel_filetype_callback(ev)
  local file_path = fs["full-path"](ev.file)
  if supported_path_3f(file_path) then
    local file_dir = fs.basename(file_path)
    local _let_5_ = config["find-and-load"](file_dir)
    local config0 = _let_5_["config"]
    local root_dir = _let_5_["root-dir"]
    local cfg = _let_5_["cfg"]
    if config0 then
      if cfg({"verbose"}) then
        notify.info("Found nfnl config, setting up autocmds: ", root_dir)
      else
      end
      vim.api.nvim_create_autocmd({"BufWritePost"}, {group = vim.api.nvim_create_augroup(str.join({"nfnl-on-write", root_dir, ev.buf}), {}), buffer = ev.buf, callback = fennel_buf_write_post_callback_fn(root_dir, cfg)})
      local function _7_(_241)
        return api.dofile(core.first(core.get(_241, "fargs")))
      end
      vim.api.nvim_buf_create_user_command(ev.buf, "NfnlFile", _7_, {desc = "Run the matching Lua file for this Fennel file from disk. Does not recompile the Lua, you must use nfnl to compile your Fennel to Lua first. Calls nfnl.api/dofile under the hood.", force = true, complete = "file", nargs = "?"})
      local function _8_(_241)
        return api["compile-all-files"](core.first(core.get(_241, "fargs")))
      end
      return vim.api.nvim_buf_create_user_command(ev.buf, "NfnlCompileAllFiles", _8_, {desc = "Executes (nfnl.api/compile-all-files) which will, you guessed it, compile all of your files.", force = true, complete = "file", nargs = "?"})
    else
      return nil
    end
  else
    return nil
  end
end
return {["fennel-filetype-callback"] = fennel_filetype_callback, ["supported-path?"] = supported_path_3f}