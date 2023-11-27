local M = {}

local originalFrames = {}

local function store_original_frame(win)
    if win then
        local id = win:id()
        if not originalFrames[id] then
            originalFrames[id] = win:frame()
        end
    end
end

function M.to_original_frame()
    local win = hs.window.focusedWindow()
    if not win then return end
    local id = win:id()
    local originalFrame = originalFrames[id]
    if originalFrame then
        win:setFrame(originalFrame)
        originalFrames[id] = nil
    end
end

function M.to_left_half()
    local win = hs.window.focusedWindow()
    if not win then return end
    store_original_frame(win)
    win:moveToUnit(hs.layout.left50)
end

function M.to_right_half()
    local win = hs.window.focusedWindow()
    if not win then return end
    store_original_frame(win)
    win:moveToUnit(hs.layout.right50)
end

function M.to_fullscreen()
    local win = hs.window.focusedWindow()
    if not win then return end
    store_original_frame(win)
    win:maximize(0)
end

function M.setup(args)
    hs.hotkey.bind(args.mods, args.key, args.action)
end

return M
