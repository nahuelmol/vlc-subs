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
    dlg:add_label(" ", 1, 4, 1, 1)
    btn = dlg:add_button("Took", get_time, 1, 5, 1, 1)
    lbl = dlg:add_label("0 s", 1, 6, 1, 1)
    btn2 = dlg:add_button("Check", get_data, 1, 7, 1, 1)
    dlg:show()
end

function get_data()
    local input = vlc.object.input()
    if not input then return end
    local path = vlc.var.get(input, "sub-file")
    msg:set_text(path or "nothing")
end

function get_time()
    local input_time = vlc.object.input()
    if not input_time then return end
    local t = vlc.var.get(input_time, "time") or 0
    lbl:set_text(string.format("%.2f seconds", t))
end

function deactivate()
end

function close()
    vlc.deactivate()
end
