flag = false
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
    msg = dlg:add_label("Hellow from VLC", 1, 1, 1, 1)
    dlg:add_label(" ", 1, 2, 1, 1)
    dlg:add_label(" ", 1, 3, 1, 1)
    dd = dlg:add_dropdown(1,2)
    dd:add_value(1, "Option A")
    dd:add_value(2, "Option B")
    dd:add_value(3, "Option C")

    subtitle_path = nil
    get_data()

    btn = dlg:add_button("Took", get_time, 1, 5, 1, 1)
    lbl = dlg:add_label("00:00:00", 1, 6, 1, 1)
    btn2 = dlg:add_button("Check", get_data, 1, 7, 1, 1)

    dlg:add_label(" ", 1, 8, 1, 1)
    dlg:add_label(" ", 1, 9, 1, 1)
    dlg:add_label(" ", 1, 10, 1, 1)
    line = dlg:add_text_input("current line", 1, 11, 1, 1)
    dlg:add_label(" ", 1, 12, 1, 1)
    dlg:add_label(" ", 1, 13, 1, 1)
    dlg:add_label(" ", 1, 14, 1, 1)
    dlg:show()
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
            vlc.msg.info("subpath: ".. subpath)
            local f = io.open(subpath, "r")
            if not f then
                vlc.msg.err("file cannot be opened")
            else
                subtitle_path = subpath
                vlc.msg.info("file is open")
            end
        end
    else
        vlc.msg.info("item is nil")
    end
end

function convert(seconds_to_convert)
    local hours = math.floor(seconds_to_convert / 3600)
    local minutes = math.floor((seconds_to_convert % 3600) / 60)
    local seconds = math.floor((seconds_to_convert % 60))

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function get_time()
    local input_time = vlc.object.input()
    if not input_time then return end
    local t = vlc.var.get(input_time, "time") or 0
    local newt = t / 1000000
    result = convert(newt)
    lbl:set_text(result)

    local f = io.open(subtitle_path, "r")
    local r_hor = string.sub(result, 1, 2)
    local r_min = string.sub(result, 4, 5)
    local r_sec = string.sub(result, 7, 8)

    local nline = 1
    for line in f:lines() do
        local ini_hor = string.sub(line, 1, 2)
        local ini_min = string.sub(line, 4, 5)
        local ini_sec = string.sub(line, 7, 12)
        
        local end_hor = string.sub(line, 18, 19)
        local end_min = string.sub(line, 20, 21)
        local end_sec = string.sub(line, 23, 28)

        --if flag == true then
        --    vlc.msg.info(line)
        --    flag = false
        --end
        if targetline == nline then
            vlc.msg.info(line)
            flag = false
        end
        if r_hor >= ini_hor and r_hor <= end_hor then
            if r_min >= ini_min and r_min <= end_min then
                if r_sec >= ini_sec and r_sec <= end_sec then
                    vlc.msg.info("found!")
                    flag = true
                    targetline = nline + 1
                end
            end
        end
        nline = nline + 1
    end
end

function deactivate()
end

function close()
    vlc.deactivate()
end
