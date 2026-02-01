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
    dlg = vlc.dialog("hellow")
    dlg:add_label("hellow from VLC", 1, 1, 1, 1)
end

function deactivate()
end

function close()
    vlc.deactivate()
end
