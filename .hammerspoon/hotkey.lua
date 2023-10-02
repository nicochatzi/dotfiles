local M = {}

-- @param hotkey_binding (.mods = { "alt", "shift" }, .key = "`")
-- @param app_name
-- @param app_selector
function M.setup_hotkey(hotkey_binding, app_name, app_selector)
    hs.application.enableSpotlightForNameSearches(true)

    -- Hammerspoon Spaces Management Library
    -- https://github.com/asmagill/hs._asm.spaces
    local spaces = require('hs.spaces')

    local CONFIG = {
        WIDTH_SCALE = 1,
        HEIGHT_SCALE = 1,
        HIDE_ON_FOCUS_LOST = false,
    }

    -- @param app The application
    -- @param space The currently active space
    -- @param screen The currently active screen
    -- @param widthScale The desired width scaling factor for the application
    -- @param heightScale The desired height scaling factor for the application
    function moveApp(app, space, screen, widthScale, heightScale)
        widthScale = widthScale or CONFIG['WIDTH_SCALE']
        heightScale = heightScale or CONFIG['HEIGHT_SCALE']

        -- Discover the provided application's main window
        -- Note the while-loop as calls to `mainWindow` could return `nil`
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
        local application = hs.application.get(app_selector)

        if application ~= nil and application:isFrontmost() then
            application:hide()
        else
            local focusedSpace = spaces.focusedSpace()
            local mainScreen = hs.screen.find(spaces.spaceDisplay(focusedSpace))

            if application == nil and hs.application.launchOrFocus(app_name) then
                local appWatcher = nil
                appWatcher = hs.application.watcher.new(function(name, event, app)
                    if event == hs.application.watcher.launched and name == app_name then
                        app:hide()
                        moveApp(app, focusedSpace, mainScreen)
                        appWatcher:stop()
                    end
                end)
                appWatcher:start()
            end

            if application ~= nil then
                moveApp(application, focusedSpace, mainScreen)
            end
        end
    end

    hs.hotkey.bind(hotkey_binding.mods, hotkey_binding.key, toggleApp)

    if CONFIG['HIDE_ON_FOCUS_LOST'] then
        hs.window.filter.default:subscribe(hs.window.filter.windowUnfocused, function(window, app)
            local application = hs.application.get(app_selector)
            if application ~= nil then
                application:hide()
            end
        end)
    end
end

function generate_hide_focus_applescript(bundle_id)
    return [[
        tell application "System Events"
            set isRunning to (count of (every process whose bundle identifier is "]] .. bundle_id .. [["))
        end tell

        if isRunning = 0 then
            -- Application is not running, so launch Application and focus it
            tell application id "]] .. bundle_id .. [["
                activate
            end tell
        else
            -- Application is running
            tell application "System Events"
                set frontmostProcess to bundle identifier of the first process whose frontmost is true
            end tell
            if frontmostProcess is "]] .. bundle_id .. [[" then
                -- Application is in focus, so hide it
                tell application "System Events" to set visible of (first process whose bundle identifier is "]] ..
        bundle_id .. [[") to false
            else
                -- Application is not in focus or is hidden, so focus it
                tell application id "]] .. bundle_id .. [["
                    activate
                end tell
            end if
        end if
    ]]
end

function M.setup_hotkey_macos(hotkey_binding, bundle_id)
    hs.hotkey.bind(hotkey_binding.mods, hotkey_binding.key, function()
        ok, result = hs.osascript.applescript(generate_hide_focus_applescript(bundle_id))
    end)
end

return M
