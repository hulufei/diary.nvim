-- [nfnl] Compiled from fnl/nfnl/api.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl-plugin-example.nfnl.module")
local autoload = _local_1_["autoload"]
local compile = autoload("nfnl-plugin-example.nfnl.compile")
local config = autoload("nfnl-plugin-example.nfnl.config")
local notify = autoload("nfnl-plugin-example.nfnl.notify")
local fs = autoload("nfnl-plugin-example.nfnl.fs")
local mod = {}
mod["compile-all-files"] = function(dir)
  local dir0 = (dir or vim.fn.getcwd())
  local _let_2_ = config["find-and-load"](dir0)
  local config0 = _let_2_["config"]
  local root_dir = _let_2_["root-dir"]
  local cfg = _let_2_["cfg"]
  if config0 then
    local results = compile["all-files"]({["root-dir"] = root_dir, cfg = cfg})
    notify.info("Compilation complete.\n", results)
    return results
  else
    notify.warn("No .nfnl.fnl configuration found.")
    return {}
  end
end
mod.dofile = function(file)
  return dofile(fs["fnl-path->lua-path"](vim.fn.expand((file or "%"))))
end
return mod
