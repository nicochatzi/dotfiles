local M = {}

function M.setup_hotkey(args)
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

function M.start_spotify_notifications()
    hs.spotify = require("hs.spotify")
    hs.timer = require("hs.timer")
    hs.notify = require("hs.notify")

    local checkIntervalSecs = 5
    local spotifyLogo = hs.image.imageFromPath("~/.hammerspoon/assets/spotify.png")
    local lastTrackName = nil

    function notifyOnNewSong()
        if not hs.spotify.isRunning() then
            return
        end

        local currentTrackName = hs.spotify.getCurrentTrack()
        if currentTrackName and currentTrackName ~= lastTrackName then
            lastTrackName = currentTrackName
            hs.notify.new({
                title = currentTrackName,
                subTitle = hs.spotify.getCurrentArtist(),
                informativeText = hs.spotify.getCurrentAlbum(),
                setIdImage = spotifyLogo,
                contentImage = spotifyLogo,
            }):send()
        end
    end

    trackChecker = hs.timer.new(checkIntervalSecs, notifyOnNewSong)
    trackChecker:start()
end

M.Window = {}

local originalFrames = {}

local function store_original_frame(win)
    if win then
        local id = win:id()
        if not originalFrames[id] then
            originalFrames[id] = win:frame()
        end
    end
end

function M.Window.to_original_frame()
    local win = hs.window.focusedWindow()
    if not win then return end
    local id = win:id()
    local originalFrame = originalFrames[id]
    if originalFrame then
        win:setFrame(originalFrame)
        originalFrames[id] = nil -- Optionally, clear the stored frame
    end
end

function M.Window.to_left_half()
    local win = hs.window.focusedWindow()
    if not win then return end
    store_original_frame(win)
    win:moveToUnit(hs.layout.left50)
end

function M.Window.to_right_half()
    local win = hs.window.focusedWindow()
    if not win then return end
    store_original_frame(win)
    win:moveToUnit(hs.layout.right50)
end

function M.Window.to_fullscreen()
    local win = hs.window.focusedWindow()
    if not win then return end
    store_original_frame(win)
    win:maximize(0)
end

function M.Window.move(args)
    hs.hotkey.bind(args.mods, args.key, args.action)
end

return M
