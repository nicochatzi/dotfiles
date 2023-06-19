-- Hammerspoon Spaces Management Library
-- https://github.com/asmagill/hs._asm.spaces
local spaces = require('hs.spaces')

local APP_NAME = 'Kitty'
local APP_SELECTOR = 'net.kovidgoyal.kitty'
local CONFIG = {
    WIDTH_SCALE = 1,
    HEIGHT_SCALE = 1,
    HIDE_ON_FOCUS_LOST = false,
}

function moveApp(app, space, screen, widthScale, heightScale)
    widthScale = widthScale or CONFIG['WIDTH_SCALE']
    heightScale = heightScale or CONFIG['HEIGHT_SCALE']

    local window = nil
    while window == nil do
        window = app:mainWindow()
    end

    local windowFrame = window:frame()
    local screenFrame = screen:fullFrame()

    if not window:isFullscreen() then
        windowFrame.w = screenFrame.w * widthScale
        windowFrame.h = screenFrame.h * heightScale
        window:setFrame(windowFrame)
        window:centerOnScreen(screen)
    end

    spaces.moveWindowToSpace(window, space)
    window:focus()
end

function toggleApp()
    local app = hs.application.get(APP_SELECTOR)

    if app ~= nil and app:isFrontmost() then
        print('should hide')
        app:hide()
    else
        local focusedSpace = spaces.focusedSpace()
        local mainScreen = hs.screen.find(spaces.spaceDisplay(focusedSpace))

        if app == nil and hs.application.launchOrFocus(APP_NAME) then
            local appWatcher = nil
            appWatcher = hs.application.watcher.new(function(name, event, app)
                if event == hs.application.watcher.launched and name == APP_NAME then
                    app:hide()
                    moveApp(app, focusedSpace, mainScreen)
                    appWatcher:stop()
                end
            end)
            appWatcher:start()
        end

        if app ~= nil then
            moveApp(app, focusedSpace, mainScreen)
        end
    end
end

hs.hotkey.bind({ "alt", "shift" }, "`", toggleApp)

if CONFIG['HIDE_ON_FOCUS_LOST'] then
    hs.application.enableSpotlightForNameSearches(true)
    hs.window.filter.default:subscribe(hs.window.filter.windowUnfocused, function(window, app)
        local app = hs.application.get(APP_SELECTOR)
        if app ~= nil then
            app:hide()
        end
    end)
end
