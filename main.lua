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
    if item == nil then
        vlc.msg.info("item is nil")
    else
        local metas = item:metas()
        local uri   = item:uri()
        if metas ~= nil then
            vlc.msg.info("Videofile: " .. metas["filename"])
        end 
        if uri ~= nil then
            local decoded = vlc.strings.decode_uri(uri)
            local path, filename = decoded:match("^file:///(.+/)(.+%..+)$")
            vlc.msg.info("path: " .. path)
        end
    end
    local spu = vlc.input.get_spu_tracks()
    if spu ~= nil then
        vlc.msg.info("spu exists")
    else
        vlc.msg.info("spu is nil")
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
end

function deactivate()
end

function close()
    vlc.deactivate()
end
