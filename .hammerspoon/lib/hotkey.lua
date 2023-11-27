local M = {}

function M.setup(args)
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

        if not window:isFullscreen() and args.fullscreen then
            local windowFrame = window:frame()
            local screenFrame = screen:fullFrame()
            windowFrame.w = screenFrame.w * widthScale
            windowFrame.h = screenFrame.h * heightScale
            window:setFrame(windowFrame)
            window:centerOnScreen(screen)
        end

        spaces.moveWindowToSpace(window, space)
        window:focus()
    end

    function toggleApp()
        local application = hs.application.get(args.bundle_id)

        if application ~= nil and application:isFrontmost() then
            application:hide()
        else
            local focusedSpace = spaces.focusedSpace()
            local mainScreen = hs.screen.find(spaces.spaceDisplay(focusedSpace))

            if application == nil and hs.application.launchOrFocus(args.app_name) then
                local appWatcher = nil
                appWatcher = hs.application.watcher.new(function(name, event, app)
                    if event == hs.application.watcher.launched and name == args.app_name then
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

    hs.hotkey.bind(args.mods, args.key, toggleApp)

    if CONFIG['HIDE_ON_FOCUS_LOST'] then
        hs.window.filter.default:subscribe(hs.window.filter.windowUnfocused, function(window, app)
            local application = hs.application.get(args.bundle_id)
            if application ~= nil then
                application:hide()
            end
        end)
    end
end


return M
