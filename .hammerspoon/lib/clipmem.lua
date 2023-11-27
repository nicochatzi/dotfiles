local M = {}

function M.setup(args)
    local pasteboard = require("hs.pasteboard")
    local clipboardHistoryPath = os.getenv("HOME") .. "/.clipmem.txt"
    local clipboardHistoryCache = {}
    local maxHistorySize = args.history
    local delimiter = "\n\n---\n\n"

    local function load()
        local file, err = io.open(clipboardHistoryPath, "r")
        if file then
            local content = file:read("*all")
            file:close()
            return hs.fnutils.split(content, delimiter) or {}
        else
            print("Error opening file: " .. err)
            return {}
        end
    end

    local function save()
        local file, err = io.open(clipboardHistoryPath, "w")
        if not file then
            print("Error opening file: " .. err)
            return
        end
        local rawContent = table.concat(clipboardHistoryCache, delimiter)
        file:write(rawContent)
        file:close()
    end

    local clipboardWatcher = hs.timer.new(1, function()
        local history = load()
        local currentContents = pasteboard.getContents()
        if currentContents and currentContents ~= history[#history] then
            table.insert(history, currentContents)
            if #history > maxHistorySize then
                table.remove(history, maxHistorySize - #history)
            end
            clipboardHistoryCache = history
            save()
        end
    end)

    clipboardWatcher:start()
end

return M
