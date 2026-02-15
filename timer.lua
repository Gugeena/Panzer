local timer = {}
local T = {}

function T.load()
  timer = {}
  T = {}
end

function T.crt(delay, func)
  table.insert(timer, {delay = delay, func = func})
end

function T.update(dt)
  for i = #timer, 1, -1 do
    local t = timer[i]
    t.delay = t.delay - dt
    if t.delay <= 0 then
      t.func()
      table.remove(timer, i)
    end
  end
end

return T