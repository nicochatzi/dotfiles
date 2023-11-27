local M = {}

function M.launch_notifier()
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

return M
