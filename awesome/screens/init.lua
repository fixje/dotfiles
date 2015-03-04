local screen_main = 1
local screen_side = 1
local screen_pivot = nil

-- Notebook supports at most two monitors
if screen.count() == 2 then
    if screen[1].workarea.width >= screen[2].workarea.width then
        screen_side = 2
    else
        screen_main = 2
    end
end

local screen_mail = screen_main

-- only one pivot supported
for i = 1, screen.count() do
    if screen[i].geometry.width < screen[i].geometry.height then
        screen_pivot = i
        screen_mail = i
    end
end

return {main = screen_main, side = screen_side, pivot = screen_pivot,
        mail = screen_mail}
