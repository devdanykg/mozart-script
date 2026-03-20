local lastApp = nil
local webview = nil

local emojis = {
    "✌️", "❤️", "?", "‍♀", "‍♂", "✔️", "✨", "☺️", "☹️", "☠️", "⛷","⚕", "⚖️", "✈️", "⛹️", "‍♀️", "‍♂️", "☝️", "⭕️", "✋", "✊", "✍️", "⛑", "⚽️", "⚾️", "⛳️", "⛸", "♟", "♠️", "♣️", "♥️", "♦️", "⛏️", "⚒️", "⚙️", "⚗️", "⚖️", "⛓️", "⚔️", "☎️", "⚰️", "⚱️", "⌨️", "✉️", "✏️", "✒️", "✂️", "⏳", "⏰", "⌚️", "⏱️", "⏲️", "☕️", "☘️", "⛵️", "⛴", "⚓️", "⛽️", "☠️", "⛰", "⛪️", "⛩", "⛲️", "⛺️", "♨️", "☁️", "⛅️", "⛈", "☀️", "⭐️", "☄️", "☂️", "☔️", "⛱", "⚡️", "❄️", "⚛️", "☸️", "☃️", "⛄️", "❣️", "☮️", "✝️", "☪️", "☸️", "✡️", "☯️", "☦️", "⛎", "♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️", "⚕", "♾️", "⚛️", "✴️", "㊙️", "㊗️", "❗️", "❕", "❓", "❔", "⁉️", "⚜️", "〽️", "☢️", "☣️", "⚠️", "♻️", "❇️", "✳️", "❎", "✅", "Ⓜ️", "➿", "♿️", "#", "⃣", "*", "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "▶️", "⏸️", "⏯️", "⏹️", "⏺️", "⏭️", "⏮️", "⏩", "⏪", "◀️", "⏫", "⏬", "⏏️", "➡️", "⬅️", "⬆️", "⬇️", "↗️", "↘️", "↙️", "↖️", "↕️", "↔️", "↪️", "↩️", "⤴️", "⤵️", "ℹ️", "☑️", "〰️", "➰", "➕", "➖", "✖️", "➗", "©", "®", "™", "⚫️", "⚪️", "⬛️", "⬜️", "◼️", "◻️", "◾️", "◽️", "❌", "⏩", "⏬", "⏫", "⏳", "⛔️"
}

local function generateHTML(groups)
    local html = [[
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
    ]]

    html = html .. '<div class="grid">'
    
    for _, e in ipairs(emojis) do
        html = html .. '<div class="emoji" onclick="send(\'' .. e .. '\')">' .. e .. '</div>'
    end

    html = html .. '</div>'

    html = html .. [[
        <script>
            function send(e) {
                window.location.href = "hammerspoon://emoji?e=" + encodeURIComponent(e);
            }
        </script>
    </body></html>
    ]]

    return html
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
    end
end)

webview = hs.webview.new({x=500,y=300,w=340,h=300})
    :windowStyle({"nonactivating", "borderless"})
    :shadow(true)
    :level(hs.drawing.windowLevels.popUpMenu)
    :html(generateHTML(groups))
    :transparent(true)

hs.hotkey.bind({"cmd"}, "Y", function()
    lastApp = hs.application.frontmostApplication()
    local mousePos = hs.mouse.absolutePosition()
    webview:topLeft(mousePos)
    webview:show()
end)

print("MoZZart script loaded.")
