
-- Export tags as individual GIFs
function exportTagsAsGifs(exportPath)
    local sprite = app.activeSprite
    if not sprite then return print("No active sprite") end

    local title = sprite.filename:match("(.*[/\\])(.*)%.aseprite")
    if not title then title = sprite.filename:match("(.*)%.aseprite") end
    if not title then return print("Save your file first!") end

    for _, tag in ipairs(sprite.tags) do
        local fn = exportPath .. "/" .. title .. "/" .. tag.name .. ".gif"
        
        -- Create a temporary copy to crop/save specific frames
        local spec = sprite.spec
        local tagSprite = Sprite(spec)
        tagSprite:setPalette(sprite.palettes[1])
        
        -- Copy frames belonging to the tag
        for i = tag.fromFrame.frameNumber, tag.toFrame.frameNumber do
            local newFrame = tagSprite:newFrame()
            -- Transfer image data from each layer
            for _, layer in ipairs(sprite.layers) do
                local cel = layer:cel(i)
                if cel then
                    local newLayer = tagSprite.layers[layer.name] or tagSprite:newLayer()
                    newLayer.name = layer.name
                    tagSprite:newCel(newLayer, newFrame, cel.image, cel.position)
                end
            end
        end
        -- Remove the default first blank frame
        tagSprite:deleteFrame(1)
        
        tagSprite:saveCopyAs(fn)
        tagSprite:close()
    end
end

-- Init Plugin
function init(plugin)
    plugin:newCommand {
            id = "pixeqla_export_tags_as_gifs",
            title = "Export Tags As GIFs",
            group = "file_export",
            onclick = function()
                local sprite = app.activeSprite
                if not sprite then return print("No active sprite") end

                local defaultPath = sprite.filename:match("(.*[/\\])")
                if not defaultPath then return print("Save your file first!") end

                local dlg = Dialog("Export Tags As GIFs")

                dlg:string {
                    id = "path",
                    label = "Export Path:",
                    text = defaultPath
                }

                dlg:button { id = "ok", text = "OK" }
                dlg:button { id = "cancel", text = "Cancel" }

                dlg:show()

                if dlg.data.ok then
                    exportTagsAsGifs(dlg.data.path)
                end
            end,
        }
end

function exit(plugin)

end
