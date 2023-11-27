local M = {}

function M.launch(args)
    local pasteboard = require("hs.pasteboard")
    local json = require("hs.json")
    local clipboardHistoryPath = os.getenv("HOME") .. "/.clipmem.json"
    local clipboardHistoryCache = {}
    local maxHistorySize = args.history

    local function load()
        local file, err = io.open(clipboardHistoryPath, "r")
        if file then
            local content = file:read("*all")
            file:close()
            return json.decode(content) or {}
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
        file:write(json.encode(clipboardHistoryCache, true))
        file:close()
    end

    local function view()
        local history = load()
        local file, err = io.open(clipboardHistoryPath, "r")
        if not file then
            print("Error opening file: " .. err)
            return
        end
        for i, item in ipairs(history) do
            print(i .. ": " .. item)
        end
    end

    local clipboardWatcher = hs.timer.new(1, function()
        local history = load()
        local currentContents = pasteboard.getContents()
        if currentContents and currentContents ~= history[#history] then
            table.insert(history, currentContents)
            if #history > maxHistorySize then
                table.remove(history, 1)
            end
            clipboardHistoryCache = history
            save()
        end
    end)

    clipboardWatcher:start()

    hs.hotkey.bind(args.mod, args.key, view)
end

return M
