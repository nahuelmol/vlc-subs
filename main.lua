local json = require("dkjson")
flag = false

init = ''
endi = ''

function descriptor()
    return {
        title = "hello",
        version = "1.0",
        author = "Nahuel",
        shortdesc = "First plugin",
        description = "nothing to say",
        capabilities = {}
    }
end

function activate()
    dlg = vlc.dialog("Assitant")
    msg = dlg:add_label("Choose dictionary", 1, 1, 1, 1)
    dlg:add_label(" ", 1, 2, 1, 1)
    dlg:add_label(" ", 1, 3, 1, 1)

    dd = dlg:add_dropdown(1,2)
    kanjiapi = dd:add_value("Kanjiapi", "Option A")
    jisho = dd:add_value("Jisho", "Option B")
    jpdb = dd:add_value("Jpdb", "Option C")

    subtitle_path = nil
    get_data()

    btn = dlg:add_button("Took", get_time, 1, 5, 1, 1)
    lbl = dlg:add_label("00:00:00", 1, 6, 1, 1)
    btn2 = dlg:add_button("Check", get_data, 1, 7, 1, 1)
    replay_btn = dlg:add_button("Replay", replay, 1, 8, 1, 1)
    play_btn = dlg:add_button("Play", play, 1, 9, 1, 1)

    dlg:add_label(" ", 1, 10, 1, 1)
    line = dlg:add_text_input("current line", 1, 11, 1, 1)
    dlg:add_label(" ", 1, 12, 1, 1)
    dlg:add_label(" ", 1, 13, 1, 1)
    dlg:add_label(" ", 1, 14, 1, 1)
    text_input = dlg:add_text_input("empty", 1, 15, 1, 1)
    dlg:add_button("Go", kanji_taker, 1, 16, 1, 1)
    dlg:add_label("Meanings:", 1, 17, 1, 1)
    meanings = dlg:add_label(" ", 1, 18, 1, 1)
    dlg:add_label("Readings:", 1, 19, 1, 1)
    readings = dlg:add_label(" ", 1, 20, 1, 1)
    dlg:show()
end

function replay()
    local ini_hor = string.sub(init, 1, 2)
    local ini_min = string.sub(init, 4, 5)
    local ini_sec = string.gsub(string.sub(init, 7, 12), ",", ".")
    
    local end_hor = string.sub(endi, 1, 2)
    local end_min = string.sub(endi, 4, 5)
    local end_sec = string.gsub(string.sub(endi, 7, 12), ",", ".")

    ini_seconds = (3600 * ini_hor) + (60 * ini_min) + ini_sec
    end_seconds = (3600 * end_hor) + (60 * end_min) + end_sec

    new_ini_seconds = tostring(ini_seconds)
    --secs  = string.gsub(new_ini_seconds, ".", ",")
    vlc.msg.info("-> "..new_ini_seconds)

    local input = vlc.object.input()
    vlc.var.set(input, "time", 406.155)
    if not input then
        vlc.msg.err("ERR")
        return
    end
    vlc.playlist.play()
    --[[
    ]]
end

function play()
    if vlc.playlist.status() == "stopped" then
        vlc.playlist.play()
    end
end

function http_get(url)
    local stream = vlc.stream(url)
    if not stream then
        return nil, "stream failed"
    end
    local data = ""
    while true do
        local chunk = stream:read(1024)
        if not chunk or #chunk == 0 then break end
        data = data..chunk
    end
    return data
end

function kanji_taker()
    opc = dd:get_text()
    vlc.msg.info(opc)
    local kanji = text_input:get_text()

    local url = ''
    if opc == "Kanjiapi" then
        url = "https://kanjiapi.dev/v1/kanji/"..kanji
    elseif opc == "Jisho" then
        url = "https://jisho/"..kanji
    elseif opc == "Jpdb" then
        url = "htpps://jpdb.io/"..kanji
    else
        url = nil
        readings:set_text("not api selected")
        meanings:set_text("not api selected")
    end
        
    
    local body, err = http_get(url)
    if body then
        vlc.msg.info(body)
        local obj, pos, err = json.decode(body, 1, nil)
        if err then
            vlc.msg.err("JSON err:" .. err)
        else
            local meanings = table.concat(obj["meanings"], ",")
            local hiragana = table.concat(obj["kun_readings"], ",")
            --vlc.msg.info(obs["meanings"])
            readings:set_text(hiragana)
            meanings:set_text(meanings)
        end
    else
        vlc.msg.err("err:"..err)
    end
end

function get_data()
    local item = vlc.input.item()
    if item ~= nil then
        local uri   = item:uri()
        if uri ~= nil then
            local decoded = vlc.strings.decode_uri(uri)
            local dirpath, filename = decoded:match("^file:///(.+/)(.+%..+)$")
            local j = (#filename - 4)
            local just_name = string.sub(filename, 1, j)
            local subpath = dirpath..just_name..".srt"
            local f = io.open(subpath, "r")
            if not f then
                vlc.msg.err("file cannot be opened")
            else
                subtitle_path = subpath
                vlc.msg.info("file open")
            end
        end
    else
        vlc.msg.info("item is nil")
    end
end

function convert(seconds_to_convert)
    local hours     = math.floor(seconds_to_convert / 3600)
    local minutes   = math.floor((seconds_to_convert % 3600) / 60)
    local seconds   = seconds_to_convert - (minutes * 60) - (hours * 3600)
    --local seconds = math.floor((seconds_to_convert % 60))
    local seconds   = string.sub(seconds, 1, 6)

    return string.format("%02d:%02d:%02f", hours, minutes, seconds)
end

function displayer(text)
    line:set_text(text)
    vlc.osd.message("found", 1, center)
end

function get_time()
    local input_time = vlc.object.input()
    if not input_time then return end
    local t = vlc.var.get(input_time, "time") or 0
    local newt = t / 1000000
    result = convert(newt)
    lbl:set_text(result)

    local f = io.open(subtitle_path, "r")
    local r_hor = tonumber(string.sub(result, 1, 2))
    local r_min = tonumber(string.sub(result, 4, 5))
    local secs  = string.gsub(string.sub(result, 7, 12), ",", ".")
    local r_sec = tonumber(secs)
    vlc.msg.info("seconds:"..secs)

    local dialog = ""
    for line in f:lines() do
        if flag == true then
            if line == "" then
                flag = false
                --vlc.msg.info(dialog)
                displayer(dialog)
                dialog = ""
            else
                dialog = dialog.."~"..line
            end
        end
        if line:find("-->", 1, true) then
            local ini_hor = string.sub(line, 1, 2)
            local ini_min = string.sub(line, 4, 5)
            local ini_sec = string.gsub(string.sub(line, 7, 12), ",", ".")
            
            local end_hor = string.sub(line, 18, 19)
            local end_min = string.sub(line, 21, 22)
            local end_sec = string.gsub(string.sub(line, 24, 29), ",", ".")

            if r_hor >= tonumber(ini_hor) and r_hor <= tonumber(end_hor) then
                if r_min >= tonumber(ini_min) and r_min <= tonumber(end_min) then
                    if r_sec >= tonumber(ini_sec) and r_sec <= tonumber(end_sec) then
                        init = string.sub(line, 1, 12)
                        endi = string.sub(line, 18, 29)
                        if vlc.playlist.status() == "playing" then
                            vlc.playlist.pause()
                        end
                        vlc.msg.info("found!")
                        flag = true
                    end
                end
            end
        end
    end
end

function deactivate()
end

function close()
    vlc.deactivate()
end
