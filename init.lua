local lastApp = nil
local webview = nil
local escHotkey = nil

local emojis = {
    "✌️", "❤️"
}

local function generateHTML()
    local parts = {}

    table.insert(parts, [[
    <html>
    <head>
    <meta charset="utf-8">
    <style>
    body {
        background: rgba(50,50,50,0.65);
        backdrop-filter: blur(20px);
        color: white;
        font-family: -apple-system;
        margin: 0;
        padding: 10px;
	border-radius: 14px;
    }
    .group { margin-bottom: 10px; }
    .title { font-size: 12px; opacity: 0.6; margin-bottom: 5px; }
    .grid {
        display: grid;
        grid-template-columns: repeat(6, 1fr);
        gap: 6px;
    }
    .emoji {
        font-size: 22px;
        text-align: center;
        padding: 6px;
        border-radius: 8px;
        cursor: pointer;
    }
    .emoji:hover {
        background: rgba(255,255,255,0.15);
    }
    </style>
    </head>
    <body>
    <div class="grid">
    ]])

    for _, e in ipairs(emojis) do
        table.insert(parts,
            '<div class="emoji" onclick="send(\'' .. e .. '\')">' .. e .. '</div>'
        )
    end

    table.insert(parts, [[
    </div>
    <script>
        function send(e) {
            window.location.href = "hammerspoon://emoji?e=" + encodeURIComponent(e);
        }
    </script>
    </body></html>
    ]])

    return table.concat(parts)
end

local function insertEmoji(emoji)
    if not lastApp then return end
    lastApp:activate()
    hs.timer.doAfter(0.1, function()
        hs.eventtap.keyStrokes(emoji)
    end)
end

hs.urlevent.bind("emoji", function(eventName, params)
    local emoji = params["e"]
    if emoji then
        webview:hide()
        insertEmoji(emoji)
	if escHotkey then escHotkey:disable() end
    end
end)

if not webview then
     webview = hs.webview.new({x=500,y=300,w=340,h=300})
    	:windowStyle({"nonactivating", "borderless"})
    	:level(hs.drawing.windowLevels.popUpMenu)
    	:html(generateHTML())
    	:transparent(true)
end

hs.hotkey.bind({"cmd"}, "Y", function()
    lastApp = hs.application.frontmostApplication()
    local mousePos = hs.mouse.absolutePosition()
    webview:topLeft(mousePos)
    webview:show()
    if escHotkey then escHotkey:enable() end
end)

print("MoZZart & devdany script loaded.")
hs.alert("MoZZart & devdany script loaded.")

local function getConfigPath()
    local home = os.getenv("HOME")
    return home .. "/.hammerspoon"
end

function checkForUpdates()
    local localVersion = getLocalVersion()
    local http = require "hs.http"
    local ok, response = http.get("https://raw.githubusercontent.com/devdanykg/mozart-script/main/version.txt")
    if ok then
        local remoteVersion = response
        if remoteVersion ~= localVersion then
            hs.dialog.alert(nil, nil, performUpdate,"MoZZart & devdany Script Update", "Update is available\nCurrent version:  " .. localVersion .. "\nNew version: " .. remoteVersion, "Update", "Later", "NSCriticalAlertStyle")
        else
            hs.alert("No update required")
        end
    else
        hs.alert("Unable to check update")
    end
end

function getLocalVersion()
    local configPath = getConfigPath()
    local file = io.open(configPath .. "/version.txt", "r")
    if file then
        local content = file:read("*all")
        file:close()
        return content
    else
	return "0.0.0"
    end
    return ""
end

function downloadFile(url, path)
    local tempPath = path .. ".tmp"
    local file, err = io.open(tempPath, "wb")
    if not file then
        return false, "Unable to create temp file"
    end
    local status, body = hs.http.get(url)
    if status ~= 200 and not body or body == "" then
        file:close()
        os.remove(tempPath)
        return false, "Response empty"
    end
    file:write(body)
    file:close()
    local fileTemp = io.open(tempPath)
    local fileSize = fileTemp:seek("end")
    fileTemp:close() 
    if fileSize == 0 then
        os.remove(tempPath)
        return false, "File is empty"
    end
    local success = os.rename(tempPath, path)
    if not success then
        return false, "Error file rename"
    end
    return true
end

function performUpdate(result)
    if result == "Update" then 
    	local configPath = getConfigPath()
    	local success, err = pcall(function()
        	local initSuccess, initErr = downloadFile("https://raw.githubusercontent.com/devdanykg/mozart-script/main/init.lua", configPath .. "/init.lua")
        	if not initSuccess then
            		return false, initErr
        	end
        	local versionSuccess, versionErr = downloadFile("https://raw.githubusercontent.com/devdanykg/mozart-script/main/version.txt", configPath .. "/version.txt")
        	if not versionSuccess then
        	    return false, versionErr
        	end
    	end)
    	if not success then
		hs.alert("Update error!")
        	return print("Error when uploading files: " .. tostring(err)) 
    	end
    	hs.reload()
    	hs.alert("Update successfully ")
    end
end

hs.timer.doAfter(1, function() checkForUpdates() end)

escHotkey = hs.hotkey.new({}, "escape", function()
    webview:hide()
    if escHotkey then escHotkey:disable() end
end)
