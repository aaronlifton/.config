-- [nfnl] Compiled from fennel/lib/fun.fnl by https://github.com/Olical/nfnl, do not edit.
local exports = {}
local methods = {}
local function clone_function(x)
  local dumped = string.dump(x)
  local cloned = loadstring(dumped)
  local i = 1
  while true do
    local name = debug.getupvalue(x, i)
    if not name then
      break
    else
    end
    debug.upvaluejoin(cloned, i, x, i)
    i = (i + 1)
  end
  return cloned
end
local function return_if_not_empty(state_x, ...)
  if (state_x == nil) then
    return nil
  else
  end
  return ...
end
local function call_if_not_empty(fun, state_x, ...)
  if (state_x == nil) then
    return nil
  else
  end
  return state_x, fun(...)
end
local function deepcopy(orig)
  local orig_type = type(orig)
  local copy = nil
  if (orig_type == "table") then
    copy = {}
    for orig_key, orig_value, next, orig0 in nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
  else
    copy = orig
  end
  return copy
end
local iterator_mt
local function _5_(self, param, state)
  return self.gen(param, state)
end
local function _6_(self)
  return "<generator>"
end
iterator_mt = {__call = _5_, __tostring = _6_, __index = methods}
local function wrap(gen, param, state)
  return setmetatable({gen = gen, param = param, state = state}, iterator_mt), param, state
end
exports.wrap = wrap
local function unwrap(self)
  return self.gen, self.param, self.state
end
methods.unwrap = unwrap
local function nil_gen(_param, _state)
  return nil
end
local function string_gen(param, state)
  local state0 = (state + 1)
  if (state0 > #param) then
    return nil
  else
  end
  local r = string.sub(param, state0, state0)
  return state0, r
end
local ipairs_gen = ipairs({})
local pairs_gen = pairs({a = 0})
local function kv_iter_gen(tab, key)
  local value = nil
  local key0, value0 = pairs_gen(tab, key)
  return key0, key0, value0
end
local function rawiter(obj, param, state)
  assert((obj ~= nil), "invalid iterator")
  if (type(obj) == "table") then
    local mt = getmetatable(obj)
    if (mt ~= nil) then
      if (mt == iterator_mt) then
        local earlyrtn_1 = obj.gen
        local earlyrtn_2 = obj.param
        local earlyrtn_3 = obj.state
        return earlyrtn_1, earlyrtn_2, earlyrtn_3
      elseif (mt.__ipairs ~= nil) then
        local earlyrtns_1 = {mt.__ipairs(obj)}
        return (table.unpack or _G.unpack)(earlyrtns_1)
      elseif (mt.__pairs ~= nil) then
        local earlyrtns_1 = {mt.__pairs(obj)}
        return (table.unpack or _G.unpack)(earlyrtns_1)
      else
      end
    else
    end
    if (#obj > 0) then
      local earlyrtns_1 = {ipairs(obj)}
      return (table.unpack or _G.unpack)(earlyrtns_1)
    else
      local earlyrtn_1 = kv_iter_gen
      local earlyrtn_2 = obj
      local earlyrtn_3 = nil
      return earlyrtn_1, earlyrtn_2, earlyrtn_3
    end
  elseif (type(obj) == "function") then
    return obj, param, state
  elseif (type(obj) == "string") then
    if (#obj == 0) then
      local earlyrtn_1 = nil_gen
      local earlyrtn_2 = nil
      local earlyrtn_3 = nil
      return earlyrtn_1, earlyrtn_2, earlyrtn_3
    else
    end
    local earlyrtn_1 = string_gen
    local earlyrtn_2 = obj
    local earlyrtn_3 = 0
    return earlyrtn_1, earlyrtn_2, earlyrtn_3
  else
  end
  return error(string.format("object %s of type \"%s\" is not iterable", obj, type(obj)))
end
local function iter(obj, param, state)
  return wrap(rawiter(obj, param, state))
end
exports.iter = iter
local function iter_pairs(obj)
  return wrap(pairs(obj))
end
exports["iter-pairs"] = iter_pairs
local function iter_map_pairs(obj)
  return wrap(kv_iter_gen, obj, nil)
end
exports["iter-map-pairs"] = iter_map_pairs
local function method0(fun)
  local function _13_(self)
    return fun(self.gen, self.param, self.state)
  end
  return _13_
end
local function method1(fun)
  local function _14_(self, arg1)
    return fun(arg1, self.gen, self.param, self.state)
  end
  return _14_
end
local function method2(fun)
  local function _15_(self, arg1, arg2)
    return fun(arg1, arg2, self.gen, self.param, self.state)
  end
  return _15_
end
local function export0(fun)
  local function _16_(gen, param, state)
    return fun(rawiter(gen, param, state))
  end
  return _16_
end
local function export1(fun)
  local function _17_(arg1, gen, param, state)
    return fun(arg1, rawiter(gen, param, state))
  end
  return _17_
end
local function export2(fun)
  local function _18_(arg1, arg2, gen, param, state)
    return fun(arg1, arg2, rawiter(gen, param, state))
  end
  return _18_
end
local function for_each(fun, gen, param, state)
  while true do
    state = call_if_not_empty(fun, gen(param, state))
    if (state == nil) then
      break
    else
    end
  end
  return nil
end
methods["for-each"] = method1(for_each)
exports["for-each"] = export1(for_each)
local function range_gen(param, state)
  local stop, step = param[1], param[2]
  local state0 = (state + step)
  if (state0 > stop) then
    return nil
  else
  end
  return state0, state0
end
local function range_rev_gen(param, state)
  local stop, step = param[1], param[2]
  local state0 = (state + step)
  if (state0 < stop) then
    return nil
  else
  end
  return state0, state0
end
local function range(start, stop, step)
  if (step == nil) then
    if (stop == nil) then
      if (start == 0) then
        local earlyrtn_1 = nil_gen
        local earlyrtn_2 = nil
        local earlyrtn_3 = nil
        return earlyrtn_1, earlyrtn_2, earlyrtn_3
      else
      end
      stop = start
      start = (((stop > 0) and 1) or ( - 1))
    else
    end
    step = (((start <= stop) and 1) or ( - 1))
  else
  end
  assert((type(start) == "number"), "start must be a number")
  assert((type(stop) == "number"), "stop must be a number")
  assert((type(step) == "number"), "step must be a number")
  assert((step ~= 0), "step must not be zero")
  if (step > 0) then
    return wrap(range_gen, {stop, step}, (start - step))
  elseif (step < 0) then
    return wrap(range_rev_gen, {stop, step}, (start - step))
  else
    return nil
  end
end
exports.range = range
local function duplicate_table_gen(param_x, state_x)
  return (state_x + 1), unpack(param_x)
end
local function duplicate_fun_gen(param_x, state_x)
  return (state_x + 1), param_x(state_x)
end
local function duplicate_gen(param_x, state_x)
  return (state_x + 1), param_x
end
local function duplicate(...)
  if (select("#", ...) <= 1) then
    return wrap(duplicate_gen, select(1, ...), 0)
  else
    return wrap(duplicate_table_gen, {...}, 0)
  end
end
exports.duplicate = duplicate
local function tabulate(fun)
  assert((type(fun) == "function"))
  return wrap(duplicate_fun_gen, fun, 0)
end
exports.tabulate = tabulate
local function zeros()
  return wrap(duplicate_gen, 0, 0)
end
exports.zeros = zeros
local function ones()
  return wrap(duplicate_gen, 1, 0)
end
exports.ones = ones
local function rands_gen(param_x, _state_x)
  return 0, math.random(param_x[1], param_x[2])
end
local function rands_nil_gen(_param_x, _state_x)
  return 0, math.random()
end
local function rands(n, m)
  if ((n == nil) and (m == nil)) then
    local earlyrtns_1 = {wrap(rands_nil_gen, 0, 0)}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  assert((type(n) == "number"), "invalid first arg to rands")
  if (m == nil) then
    m = n
    n = 0
  else
    assert((type(m) == "number"), "invalid second arg to rands")
  end
  assert((n < m), "empty interval")
  return wrap(rands_gen, {n, (m - 1)}, 0)
end
exports.rands = rands
local function nth(n, gen_x, param_x, state_x)
  assert((n > 0), "invalid first argument to nth")
  if (gen_x == ipairs_gen) then
    local antifnl_rtn_1 = param_x[(state_x + n)]
    return antifnl_rtn_1
  elseif (gen_x == string_gen) then
    if ((state_x + n) <= #param_x) then
      local earlyrtn_1 = {string.sub(param_x, (state_x + n + (state_x + n)))}
      return (table.unpack or _G.unpack)(earlyrtn_1)
    else
      return nil
    end
  else
  end
  for i = 1, (n - 1) do
    state_x = gen_x(param_x, state_x)
    if (state_x == nil) then
      return nil
    else
    end
  end
  return return_if_not_empty(gen_x(param_x, state_x))
end
methods.nth = method1(nth)
exports.nth = export1(nth)
local function car_call(state, ...)
  if (state == nil) then
    error("head: iterator is empty")
  else
  end
  return ...
end
local function car(gen, param, state)
  return car_call(gen(param, state))
end
methods.car = car
exports.car = export0(car)
local function cdr(gen, param, state)
  state = gen(param, state)
  if (state == nil) then
    local earlyrtns_1 = {wrap(nil_gen, nil, nil)}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  return wrap(gen, param, state)
end
methods.cdr = method0(cdr)
exports.cdr = export0(cdr)
local function take_n_gen_x(i, state_x, ...)
  if (state_x == nil) then
    return nil
  else
  end
  return {i, state_x}, ...
end
local function take_n_gen(param, state)
  local n, gen_x, param_x = param[1], param[2], param[3]
  local i, state_x = state[1], state[2]
  if (i >= n) then
    return nil
  else
  end
  return take_n_gen_x((i + 1), gen_x(param_x, state_x))
end
local function take_n(n, gen, param, state)
  assert((n >= 0), "invalid first argument to take_n")
  return wrap(take_n_gen, {n, gen, param}, {0, state})
end
methods["take-n"] = method1(take_n)
exports["take-n"] = export1(take_n)
local function take_while_gen_x(fun, state_x, ...)
  if ((state_x == nil) or not fun(...)) then
    return nil
  else
  end
  return state_x, ...
end
local function take_while_gen(param, state_x)
  local fun, gen_x, param_x = param[1], param[2], param[3]
  return take_while_gen_x(fun, gen_x(param_x, state_x))
end
local function take_while(fun, gen, param, state)
  assert((type(fun) == "function"), "invalid first argument to take_while")
  return wrap(take_while_gen, {fun, gen, param}, state)
end
methods["take-while"] = method1(take_while)
exports["take-while"] = export1(take_while)
local function take(n_or_fun, gen, param, state)
  if (type(n_or_fun) == "number") then
    return take_n(n_or_fun, gen, param, state)
  else
    return take_while(n_or_fun, gen, param, state)
  end
end
methods.take = method1(take)
exports.take = export1(take)
local function drop_n(n, gen, param, state)
  assert((n >= 0), "invalid first argument to drop_n")
  local i = nil
  for i0 = 1, n do
    state = gen(param, state)
    if (state == nil) then
      local earlyrtns_1 = {wrap(nil_gen, nil, nil)}
      return (table.unpack or _G.unpack)(earlyrtns_1)
    else
    end
  end
  return wrap(gen, param, state)
end
methods.drop_n = method1(drop_n)
exports.drop_n = export1(drop_n)
local function drop_while_x(fun, state_x, ...)
  if ((state_x == nil) or not fun(...)) then
    local earlyrtn_1 = state_x
    local earlyrtn_2 = false
    return earlyrtn_1, earlyrtn_2
  else
  end
  return state_x, true, ...
end
local function drop_while(fun, gen_x, param_x, state_x)
  assert((type(fun) == "function"), "invalid first argument to drop_while")
  local cont, state_x_prev = nil
  while true do
    state_x_prev = deepcopy(state_x)
    state_x, cont = drop_while_x(fun, gen_x(param_x, state_x))
    if not cont then
      break
    else
    end
  end
  if (state_x == nil) then
    local earlyrtns_1 = {wrap(nil_gen, nil, nil)}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  return wrap(gen_x, param_x, state_x_prev)
end
methods["drop-while"] = method1(drop_while)
exports["drop-while"] = export1(drop_while)
local function drop(n_or_fun, gen_x, param_x, state_x)
  if (type(n_or_fun) == "number") then
    return drop_n(n_or_fun, gen_x, param_x, state_x)
  else
    return drop_while(n_or_fun, gen_x, param_x, state_x)
  end
end
methods.drop = method1(drop)
exports.drop = export1(drop)
local function split(n_or_fun, gen_x, param_x, state_x)
  return take(n_or_fun, gen_x, param_x, state_x), drop(n_or_fun, gen_x, param_x, state_x)
end
methods.split = method1(split)
exports.split = export1(split)
local function index(x, gen, param, state)
  local i = 1
  for _k, r, gen0, param0 in state do
    if (r == x) then
      return i
    else
    end
    i = (i + 1)
  end
  return nil
end
methods.index = method1(index)
exports.index = export1(index)
local function indexes_gen(param, state)
  local x, gen_x, param_x = param[1], param[2], param[3]
  local i, state_x = state[1], state[2]
  local r = nil
  while true do
    state_x, r = gen_x(param_x, state_x)
    if (state_x == nil) then
      return nil
    else
    end
    i = (i + 1)
    if (r == x) then
      local earlyrtn_1 = {i, state_x}
      local earlyrtn_2 = i
      return earlyrtn_1, earlyrtn_2
    else
    end
  end
  return nil
end
local function indexes(x, gen, param, state)
  return wrap(indexes_gen, {x, gen, param}, {0, state})
end
methods.indexes = method1(indexes)
exports.indexes = export1(indexes)
local function filter1_gen(fun, gen_x, param_x, state_x, a)
  while true do
    if ((state_x == nil) or fun(a)) then
      break
    else
    end
    state_x, a = gen_x(param_x, state_x)
  end
  return state_x, a
end
local filterm_gen = nil
local function filterm_gen_shrink(fun, gen_x, param_x, state_x)
  return filterm_gen(fun, gen_x, param_x, gen_x(param_x, state_x))
end
local function _47_(fun, gen_x, param_x, state_x, ...)
  if (state_x == nil) then
    return nil
  else
  end
  if fun(...) then
    local earlyrtn_1 = state_x
    local earlyrtn_2 = ...
    return earlyrtn_1, earlyrtn_2
  else
  end
  return filterm_gen_shrink(fun, gen_x, param_x, state_x)
end
filterm_gen = _47_
local function filter_detect(fun, gen_x, param_x, state_x, ...)
  if (select("#", ...) < 2) then
    return filter1_gen(fun, gen_x, param_x, state_x, ...)
  else
    return filterm_gen(fun, gen_x, param_x, state_x, ...)
  end
end
local function filter_gen(param, state_x)
  local fun, gen_x, param_x = param[1], param[2], param[3]
  return filter_detect(fun, gen_x, param_x, gen_x(param_x, state_x))
end
local function filter(fun, gen, param, state)
  return wrap(filter_gen, {fun, gen, param}, state)
end
methods.filter = method1(filter)
exports.filter = export1(filter)
local function grep(fun_or_regexp, gen, param, state)
  local fun = fun_or_regexp
  if (type(fun_or_regexp) == "string") then
    local function _51_(x)
      return (string.find(x, fun_or_regexp) ~= nil)
    end
    fun = _51_
  else
  end
  return filter(fun, gen, param, state)
end
methods.grep = method1(grep)
exports.grep = export1(grep)
local function partition(fun, gen, param, state)
  local function neg_fun(...)
    return not fun(...)
  end
  return filter(fun, gen, param, state), filter(neg_fun, gen, param, state)
end
methods.partition = method1(partition)
exports.partition = export1(partition)
local reduce_clones = {}
local funcinfo = (require("jit.util")).funcinfo
local function reduce_call(fun, start, state, ...)
  if (state == nil) then
    return nil, start
  else
  end
  return state, fun(start, ...)
end
local function reduce_impl(fun, start, gen_x, param_x, state_x)
  while true do
    state_x, start = reduce_call(fun, start, gen_x(param_x, state_x))
    if (state_x == nil) then
      break
    else
    end
  end
  return start
end
local function reduce(fun, start, gen_x, param_x, state_x)
  local pt = (funcinfo((debug.getinfo(2, "f")).func)).proto
  if (reduce_clones[pt] == nil) then
    reduce_clones[pt] = clone_function(reduce_impl)
  else
  end
  return reduce_clones[pt](fun, start, gen_x, param_x, state_x)
end
methods.reduce = method2(reduce)
exports.reduce = export2(reduce)
local function nlength(gen, param, state)
  if ((gen == ipairs_gen) or (gen == string_gen)) then
    local earlyrtn_1 = #param
    return earlyrtn_1
  else
  end
  local len = 0
  while true do
    state = gen(param, state)
    len = (len + 1)
    if (state == nil) then
      break
    else
    end
  end
  return (len - 1)
end
methods.nlength = method0(nlength)
exports.nlength = export0(nlength)
local function is_null(gen, param, state)
  return (gen(param, deepcopy(state)) == nil)
end
methods.is_null = method0(is_null)
exports.is_null = export0(is_null)
local function is_prefix_of(iter_x, iter_y)
  local gen_x, param_x, state_x = iter(iter_x)
  local gen_y, param_y, state_y = iter(iter_y)
  local r_x, r_y = nil
  for i = 1, 10 do
    state_x, r_x = gen_x(param_x, state_x)
    state_y, r_y = gen_y(param_y, state_y)
    if (state_x == nil) then
      return true
    else
    end
    if ((state_y == nil) or (r_x ~= r_y)) then
      return false
    else
    end
  end
  return nil
end
methods.is_prefix_of = is_prefix_of
exports.is_prefix_of = is_prefix_of
local function all(fun, gen_x, param_x, state_x)
  local r = nil
  while true do
    state_x, r = call_if_not_empty(fun, gen_x(param_x, state_x))
    if ((state_x == nil) or not r) then
      break
    else
    end
  end
  return (state_x == nil)
end
methods.all = method1(all)
exports.all = export1(all)
local function any(fun, gen_x, param_x, state_x)
  local r = nil
  while true do
    state_x, r = call_if_not_empty(fun, gen_x(param_x, state_x))
    if ((state_x == nil) or r) then
      break
    else
    end
  end
  return not not r
end
methods.any = method1(any)
exports.any = export1(any)
local function sum(gen, param, state)
  local s = 0
  local r = 0
  while true do
    s = (s + r)
    state, r = gen(param, state)
    if (state == nil) then
      break
    else
    end
  end
  return s
end
methods.sum = method0(sum)
exports.sum = export0(sum)
local function product(gen, param, state)
  local p = 1
  local r = 1
  while true do
    p = (p * r)
    state, r = gen(param, state)
    if (state == nil) then
      break
    else
    end
  end
  return p
end
methods.product = method0(product)
exports.product = export0(product)
local function min_cmp(m, n)
  if (n < m) then
    return n
  else
    return m
  end
end
local function max_cmp(m, n)
  if (n > m) then
    return n
  else
    return m
  end
end
local function min(gen, param, state)
  local state0, m = gen(param, state)
  if (state0 == nil) then
    error("min: iterator is empty")
  else
  end
  local cmp = nil
  if (type(m) == "number") then
    cmp = math.min
  else
    cmp = min_cmp
  end
  for _, r, gen0, param0 in state0 do
    m = cmp(m, r)
  end
  return m
end
methods.min = method0(min)
exports.min = export0(min)
local function min_by(cmp, gen_x, param_x, state_x)
  local state_x0, m = gen_x(param_x, state_x)
  if (state_x0 == nil) then
    error("min: iterator is empty")
  else
  end
  for _, r, gen_x0, param_x0 in state_x0 do
    m = cmp(m, r)
  end
  return m
end
methods.min_by = method1(min_by)
exports.min_by = export1(min_by)
local function max(gen_x, param_x, state_x)
  local state_x0, m = gen_x(param_x, state_x)
  if (state_x0 == nil) then
    error("max: iterator is empty")
  else
  end
  local cmp = nil
  if (type(m) == "number") then
    cmp = math.max
  else
    cmp = max_cmp
  end
  for _, r, gen_x0, param_x0 in state_x0 do
    m = cmp(m, r)
  end
  return m
end
methods.max = method0(max)
exports.max = export0(max)
local function max_by(cmp, gen_x, param_x, state_x)
  local state_x0, m = gen_x(param_x, state_x)
  if (state_x0 == nil) then
    error("max: iterator is empty")
  else
  end
  for _, r, gen_x0, param_x0 in state_x0 do
    m = cmp(m, r)
  end
  return m
end
methods.max_by = method1(max_by)
exports.max_by = export1(max_by)
local function totable(gen_x, param_x, state_x)
  local tab, key, val = {}
  while true do
    state_x, val = gen_x(param_x, state_x)
    if (state_x == nil) then
      break
    else
    end
    table.insert(tab, val)
  end
  return tab
end
methods.totable = method0(totable)
exports.totable = export0(totable)
local function tomap(gen_x, param_x, state_x)
  local tab, key, val = {}
  while true do
    state_x, key, val = gen_x(param_x, state_x)
    if (state_x == nil) then
      break
    else
    end
    tab[key] = val
  end
  return tab
end
methods.tomap = method0(tomap)
exports.tomap = export0(tomap)
local function map_gen(param, state)
  local gen_x, param_x, fun = param[1], param[2], param[3]
  return call_if_not_empty(fun, gen_x(param_x, state))
end
local function map(fun, gen, param, state)
  return wrap(map_gen, {gen, param, fun}, state)
end
methods.map = method1(map)
exports.map = export1(map)
local function flatten_gen_call(state, i, state_x, ...)
  if (state_x == nil) then
    return nil
  else
  end
  return {(i + 1), state_x}, i, ...
end
local function flatten_gen(param, state)
  local gen_x, param_x = param[1], param[2]
  local i, state_x = state[1], state[2]
  return flatten_gen_call(state, i, gen_x(param_x, state_x))
end
local function flatten(gen, param, state)
  return wrap(flatten_gen, {gen, param}, {1, state})
end
methods.flatten = method0(flatten)
exports.flatten = export0(flatten)
local function with_key_gen_call(new_state, ...)
  if (new_state == nil) then
    return nil
  else
  end
  return new_state, new_state, ...
end
local function with_key_gen(param, state)
  local gen_x, param_x = param[1], param[2]
  return with_key_gen_call(gen_x(param_x, state))
end
local function with_key(gen, param, state)
  return wrap(with_key_gen, {gen, param}, state)
end
methods.with_key = method0(with_key)
exports.with_key = export0(with_key)
local function index_by_gen_call(_fn, new_state, ...)
  if (new_state == nil) then
    return nil
  else
  end
  local key = _fn(...)
  return new_state, key, ...
end
local function index_by_gen(param, state)
  local _fn, gen_x, param_x = param[1], param[2], param[3]
  return index_by_gen_call(_fn, gen_x(param_x, state))
end
local function index_by(_fn, gen, param, state)
  return wrap(index_by_gen, {_fn, gen, param}, state)
end
methods.index_by = method1(index_by)
exports.index_by = export1(index_by)
local function intersperse_call(i, state_x, ...)
  if (state_x == nil) then
    return nil
  else
  end
  return {(i + 1), state_x}, ...
end
local function intersperse_gen(param, state)
  local x, gen_x, param_x = param[1], param[2], param[3]
  local i, state_x = state[1], state[2]
  if ((i % 2) == 1) then
    return {(i + 1), state_x}, x
  else
    return intersperse_call(i, gen_x(param_x, state_x))
  end
end
local function intersperse(x, gen, param, state)
  return wrap(intersperse_gen, {x, gen, param}, {0, state})
end
methods.intersperse = method1(intersperse)
exports.intersperse = export1(intersperse)
local function zip_gen_r(param, state, state_new, ...)
  if (#state_new == (#param / 2)) then
    local earlyrtn_1 = state_new
    local earlyrtn_2 = ...
    return earlyrtn_1, earlyrtn_2
  else
  end
  local i = (#state_new + 1)
  local gen_x, param_x = param[((2 * i) - 1)], param[(2 * i)]
  local state_x, r = gen_x(param_x, state[i])
  if (state_x == nil) then
    return nil
  else
  end
  table.insert(state_new, state_x)
  return zip_gen_r(param, state, state_new, r, ...)
end
local function zip_gen(param, state)
  return zip_gen_r(param, state, {})
end
local function numargs(...)
  local n = select("#", ...)
  if (n >= 3) then
    local it = select((n - 2), ...)
    if ((((type(it) == "table") and (getmetatable(it) == iterator_mt)) and (it.param == select((n - 1), ...))) and (it.state == select(n, ...))) then
      local earlyrtn_1 = (n - 2)
      return earlyrtn_1
    else
    end
  else
  end
  return n
end
local function zip(...)
  local n = numargs(...)
  if (n == 0) then
    local earlyrtns_1 = {wrap(nil_gen, nil, nil)}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  local param = {[(2 * n)] = 0}
  local state = {[n] = 0}
  local i, gen_x, param_x, state_x = nil
  for i0 = 1, n do
    local it = select(((n - i0) + 1), ...)
    gen_x, param_x, state_x = rawiter(it)
    do end (param)[((2 * i0) - 1)] = gen_x
    param[(2 * i0)] = param_x
    state[i0] = state_x
  end
  return wrap(zip_gen, param, state)
end
methods.zip = zip
exports.zip = zip
local function cycle_gen_call(param, state_x, ...)
  if (state_x == nil) then
    local gen_x, param_x, state_x0 = param[1], param[2], param[3]
    local earlyrtns_1 = {gen_x(param_x, deepcopy(state_x0))}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  return state_x, ...
end
local function cycle_gen(param, state_x)
  local gen_x, param_x, state_x0 = param[1], param[2], param[3]
  return cycle_gen_call(param, gen_x(param_x, state_x))
end
local function cycle(gen, param, state)
  return wrap(cycle_gen, {gen, param, state}, deepcopy(state))
end
methods.cycle = method0(cycle)
exports.cycle = export0(cycle)
local chain_gen_r1 = nil
local function chain_gen_r2(param, state, state_x, ...)
  if (state_x == nil) then
    local i = state[1]
    i = (i + 1)
    if (param[((3 * i) - 1)] == nil) then
      return nil
    else
    end
    local state_x0 = param[(3 * i)]
    local earlyrtns_1 = {chain_gen_r1(param, {i, state_x0})}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  return {state[1], state_x}, ...
end
local function _87_(param, state)
  local i, state_x = state[1], state[2]
  local gen_x, param_x = param[((3 * i) - 2)], param[((3 * i) - 1)]
  return chain_gen_r2(param, state, gen_x(param_x, state[2]))
end
chain_gen_r1 = _87_
local function chain(...)
  local n = numargs(...)
  if (n == 0) then
    local earlyrtns_1 = {wrap(nil_gen, nil, nil)}
    return (table.unpack or _G.unpack)(earlyrtns_1)
  else
  end
  local param = {[(3 * n)] = 0}
  local i, gen_x, param_x, state_x = nil
  for i0 = 1, n do
    local elem = select(i0, ...)
    gen_x, param_x, state_x = iter(elem)
    do end (param)[((3 * i0) - 2)] = gen_x
    param[((3 * i0) - 1)] = param_x
    param[(3 * i0)] = state_x
  end
  return wrap(chain_gen_r1, param, {1, param[3]})
end
methods.chain = chain
exports.chain = chain
return exports
