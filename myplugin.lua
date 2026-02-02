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
    local dlg = vlc.dialog("Assitant")
    dlg:add_label("Hellow from VLC", 1, 1, 1, 1)
    --local input_wgt = dlg:add_text_input("This is a Text Box", ...)
    dlg:show()
end

function deactivate()
end

function close()
    vlc.deactivate()
end
