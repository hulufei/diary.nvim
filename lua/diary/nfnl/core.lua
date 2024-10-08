-- [nfnl] Compiled from fnl/nfnl/core.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("diary.nfnl.module")
local autoload = _local_1_["autoload"]
local fennel = autoload("diary.nfnl.fennel")
local function rand(n)
  return (math.random() * (n or 1))
end
local function nil_3f(x)
  return (nil == x)
end
local function number_3f(x)
  return ("number" == type(x))
end
local function boolean_3f(x)
  return ("boolean" == type(x))
end
local function string_3f(x)
  return ("string" == type(x))
end
local function table_3f(x)
  return ("table" == type(x))
end
local function function_3f(value)
  return ("function" == type(value))
end
local function keys(t)
  local result = {}
  if t then
    for k, _ in pairs(t) do
      table.insert(result, k)
    end
  else
  end
  return result
end
local function count(xs)
  if table_3f(xs) then
    local maxn = table.maxn(xs)
    if (0 == maxn) then
      return table.maxn(keys(xs))
    else
      return maxn
    end
  elseif not xs then
    return 0
  else
    return #xs
  end
end
local function empty_3f(xs)
  return (0 == count(xs))
end
local function first(xs)
  if xs then
    return xs[1]
  else
    return nil
  end
end
local function second(xs)
  if xs then
    return xs[2]
  else
    return nil
  end
end
local function last(xs)
  if xs then
    return xs[count(xs)]
  else
    return nil
  end
end
local function inc(n)
  return (n + 1)
end
local function dec(n)
  return (n - 1)
end
local function even_3f(n)
  return ((n % 2) == 0)
end
local function odd_3f(n)
  return not even_3f(n)
end
local function vals(t)
  local result = {}
  if t then
    for _, v in pairs(t) do
      table.insert(result, v)
    end
  else
  end
  return result
end
local function kv_pairs(t)
  local result = {}
  if t then
    for k, v in pairs(t) do
      table.insert(result, {k, v})
    end
  else
  end
  return result
end
local function run_21(f, xs)
  if xs then
    local nxs = count(xs)
    if (nxs > 0) then
      for i = 1, nxs do
        f(xs[i])
      end
      return nil
    else
      return nil
    end
  else
    return nil
  end
end
local function complement(f)
  local function _12_(...)
    return not f(...)
  end
  return _12_
end
local function filter(f, xs)
  local result = {}
  local function _13_(x)
    if f(x) then
      return table.insert(result, x)
    else
      return nil
    end
  end
  run_21(_13_, xs)
  return result
end
local function remove(f, xs)
  return filter(complement(f), xs)
end
local function map(f, xs)
  local result = {}
  local function _15_(x)
    local mapped = f(x)
    local function _16_()
      if (0 == select("#", mapped)) then
        return nil
      else
        return mapped
      end
    end
    return table.insert(result, _16_())
  end
  run_21(_15_, xs)
  return result
end
local function map_indexed(f, xs)
  return map(f, kv_pairs(xs))
end
local function identity(x)
  return x
end
local function reduce(f, init, xs)
  local result = init
  local function _17_(x)
    result = f(result, x)
    return nil
  end
  run_21(_17_, xs)
  return result
end
local function some(f, xs)
  local result = nil
  local n = 1
  while (nil_3f(result) and (n <= count(xs))) do
    local candidate = f(xs[n])
    if candidate then
      result = candidate
    else
    end
    n = inc(n)
  end
  return result
end
local function butlast(xs)
  local total = count(xs)
  local function _20_(_19_)
    local n = _19_[1]
    local v = _19_[2]
    return (n ~= total)
  end
  return map(second, filter(_20_, kv_pairs(xs)))
end
local function rest(xs)
  local function _22_(_21_)
    local n = _21_[1]
    local v = _21_[2]
    return (n ~= 1)
  end
  return map(second, filter(_22_, kv_pairs(xs)))
end
local function concat(...)
  local result = {}
  local function _23_(xs)
    local function _24_(x)
      return table.insert(result, x)
    end
    return run_21(_24_, xs)
  end
  run_21(_23_, {...})
  return result
end
local function mapcat(f, xs)
  return concat(unpack(map(f, xs)))
end
local function pr_str(...)
  local s
  local function _25_(x)
    return fennel.view(x, {["one-line"] = true})
  end
  s = table.concat(map(_25_, {...}), " ")
  if (nil_3f(s) or ("" == s)) then
    return "nil"
  else
    return s
  end
end
local function str(...)
  local function _27_(acc, s)
    return (acc .. s)
  end
  local function _28_(s)
    if string_3f(s) then
      return s
    else
      return pr_str(s)
    end
  end
  return reduce(_27_, "", map(_28_, {...}))
end
local function println(...)
  local function _30_(acc, s)
    return (acc .. s)
  end
  local function _32_(_31_)
    local i = _31_[1]
    local s = _31_[2]
    if (1 == i) then
      return s
    else
      return (" " .. s)
    end
  end
  local function _34_(s)
    if string_3f(s) then
      return s
    else
      return pr_str(s)
    end
  end
  return print(reduce(_30_, "", map_indexed(_32_, map(_34_, {...}))))
end
local function pr(...)
  return println(pr_str(...))
end
local function slurp(path)
  if path then
    local _36_, _37_ = io.open(path, "r")
    if ((_36_ == nil) and true) then
      local _msg = _37_
      return nil
    elseif (nil ~= _36_) then
      local f = _36_
      local content = f:read("*all")
      f:close()
      return content
    else
      return nil
    end
  else
    return nil
  end
end
local function get(t, k, d)
  local res
  if table_3f(t) then
    local val = t[k]
    if not nil_3f(val) then
      res = val
    else
      res = nil
    end
  else
    res = nil
  end
  if nil_3f(res) then
    return d
  else
    return res
  end
end
local function spit(path, content, opts)
  if path then
    local _43_, _44_ = nil, nil
    local function _45_()
      if get(opts, "append") then
        return "a"
      else
        return "w"
      end
    end
    _43_, _44_ = io.open(path, _45_())
    if ((_43_ == nil) and (nil ~= _44_)) then
      local msg = _44_
      return error(("Could not open file: " .. msg))
    elseif (nil ~= _43_) then
      local f = _43_
      f:write(content)
      f:close()
      return nil
    else
      return nil
    end
  else
    return nil
  end
end
local function merge_21(base, ...)
  local function _48_(acc, m)
    if m then
      for k, v in pairs(m) do
        acc[k] = v
      end
    else
    end
    return acc
  end
  return reduce(_48_, (base or {}), {...})
end
local function merge(...)
  return merge_21({}, ...)
end
local function select_keys(t, ks)
  if (t and ks) then
    local function _50_(acc, k)
      if k then
        acc[k] = t[k]
      else
      end
      return acc
    end
    return reduce(_50_, {}, ks)
  else
    return {}
  end
end
local function get_in(t, ks, d)
  local res
  local function _53_(acc, k)
    if table_3f(acc) then
      return get(acc, k)
    else
      return nil
    end
  end
  res = reduce(_53_, t, ks)
  if nil_3f(res) then
    return d
  else
    return res
  end
end
local function assoc(t, ...)
  local _let_56_ = {...}
  local k = _let_56_[1]
  local v = _let_56_[2]
  local xs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_56_, 3)
  local rem = count(xs)
  local t0 = (t or {})
  if odd_3f(rem) then
    error("assoc expects even number of arguments after table, found odd number")
  else
  end
  if not nil_3f(k) then
    t0[k] = v
  else
  end
  if (rem > 0) then
    assoc(t0, unpack(xs))
  else
  end
  return t0
end
local function assoc_in(t, ks, v)
  local path = butlast(ks)
  local final = last(ks)
  local t0 = (t or {})
  local function _60_(acc, k)
    local step = get(acc, k)
    if nil_3f(step) then
      return get(assoc(acc, k, {}), k)
    else
      return step
    end
  end
  assoc(reduce(_60_, t0, path), final, v)
  return t0
end
local function update(t, k, f)
  return assoc(t, k, f(get(t, k)))
end
local function update_in(t, ks, f)
  return assoc_in(t, ks, f(get_in(t, ks)))
end
local function constantly(v)
  local function _62_()
    return v
  end
  return _62_
end
local function distinct(xs)
  local function _63_(acc, x)
    acc[x] = true
    return acc
  end
  return keys(reduce(_63_, {}, xs))
end
local function sort(xs)
  local copy = map(identity, xs)
  table.sort(copy)
  return copy
end
local function clear_table_21(t)
  if t then
    for k, _ in pairs(t) do
      t[k] = nil
    end
  else
  end
  return nil
end
return {rand = rand, ["nil?"] = nil_3f, ["number?"] = number_3f, ["boolean?"] = boolean_3f, ["string?"] = string_3f, ["table?"] = table_3f, ["function?"] = function_3f, keys = keys, count = count, ["empty?"] = empty_3f, first = first, second = second, last = last, inc = inc, dec = dec, ["even?"] = even_3f, ["odd?"] = odd_3f, vals = vals, ["kv-pairs"] = kv_pairs, ["run!"] = run_21, complement = complement, filter = filter, remove = remove, map = map, ["map-indexed"] = map_indexed, identity = identity, reduce = reduce, some = some, butlast = butlast, rest = rest, concat = concat, mapcat = mapcat, ["pr-str"] = pr_str, str = str, println = println, pr = pr, slurp = slurp, spit = spit, ["merge!"] = merge_21, merge = merge, ["select-keys"] = select_keys, get = get, ["get-in"] = get_in, assoc = assoc, ["assoc-in"] = assoc_in, update = update, ["update-in"] = update_in, constantly = constantly, distinct = distinct, sort = sort, ["clear-table!"] = clear_table_21}
