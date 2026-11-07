local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local biome_name = BiomeMapGetName(x, y) or ""
local is_gold_biome = string.match(biome_name, "gold")

local current_frame = GameGetFrameNum()
local music_duration_frames = 192 * 60 -- 3 minutes 12 seconds at 60 FPS

-- CHECK THE LOCK TIMER
local target_frame = tonumber(GlobalsGetValue("dunktales_target_frame", "0"))
local start_frame = tonumber(GlobalsGetValue("dunktales_start_frame", "0"))
local pause_frames = tonumber(GlobalsGetValue("dunktales_pause_frames", "0"))

if target_frame > 0 then
    local elapsed_frames = (current_frame - start_frame) + pause_frames
    if elapsed_frames >= music_duration_frames then
        -- END OF LOCK: re-enable the controls!
        local controls = EntityGetFirstComponentIncludingDisabled(entity_id, "ControlsComponent")
        if controls ~= nil then EntitySetComponentIsEnabled(entity_id, controls, true) end
        
        local inventory = EntityGetFirstComponentIncludingDisabled(entity_id, "Inventory2Component")
        if inventory ~= nil then EntitySetComponentIsEnabled(entity_id, inventory, true) end

        -- SECOND GOLD CLEANUP (at the very end of the timer!)
        local eater_id = EntityCreateNew()
        EntitySetTransform(eater_id, x, y)
        EntityAddComponent2(eater_id, "MagicConvertMaterialComponent", {
            kill_when_finished = true,
            from_material = CellFactory_GetType("gold"),
            to_material = CellFactory_GetType("air"),
            steps_per_frame = 300,
            loop = false,
            radius = 800,
            is_circle = true
        })
        EntityAddComponent2(eater_id, "MagicConvertMaterialComponent", {
            kill_when_finished = true,
            from_material = CellFactory_GetType("gold_static"),
            to_material = CellFactory_GetType("air"),
            steps_per_frame = 300,
            loop = false,
            radius = 800,
            is_circle = true
        })

        GlobalsSetValue("dunktales_target_frame", "0")
        GamePrint("Music over, you can go back to exploring!")
    else
        -- DURING LOCK: keep the player frozen
        local controls = EntityGetFirstComponent(entity_id, "ControlsComponent")
        if controls ~= nil then EntitySetComponentIsEnabled(entity_id, controls, false) end
        
        local inventory = EntityGetFirstComponent(entity_id, "Inventory2Component")
        if inventory ~= nil then EntitySetComponentIsEnabled(entity_id, inventory, false) end
        
        -- Set velocity to 0 so the player doesn't slide
        local char_data = EntityGetFirstComponent(entity_id, "CharacterDataComponent")
        if char_data ~= nil then ComponentSetValue2(char_data, "mVelocity", 0, 0) end
    end
end

if is_gold_biome then
    -- If we're in the biome and the sound isn't playing yet
    if not GameHasFlagRun("playing_dunktales") then
        -- PLAY THE MUSIC (back to the original version)
        GamePlaySound("mods/dunktales_gold/data/audio/Desktop/dunktalesbank.bank", "DunkTales", x, y)

        -- INSTANT REWARD
        local wallet = EntityGetFirstComponent(entity_id, "WalletComponent")
        if wallet ~= nil then
            local current_money = ComponentGetValue2(wallet, "money")
            ComponentSetValue2(wallet, "money", current_money + 258674)
        end
        
        -- REMOVE THE GOLD MATERIAL
        local eater_id = EntityCreateNew()
        EntitySetTransform(eater_id, x, y)
        
        EntityAddComponent2(eater_id, "MagicConvertMaterialComponent", {
            kill_when_finished = true,
            from_material = CellFactory_GetType("gold"),
            to_material = CellFactory_GetType("air"),
            steps_per_frame = 300,
            loop = false,
            radius = 1000,
            is_circle = true
        })
        EntityAddComponent2(eater_id, "MagicConvertMaterialComponent", {
            kill_when_finished = true,
            from_material = CellFactory_GetType("gold_static"),
            to_material = CellFactory_GetType("air"),
            steps_per_frame = 300,
            loop = false,
            radius = 1000,
            is_circle = true
        })

        -- LOCK THE PLAYER
        GlobalsSetValue("dunktales_start_frame", tostring(current_frame))
        GlobalsSetValue("dunktales_target_frame", tostring(current_frame + music_duration_frames))
        GlobalsSetValue("dunktales_pause_frames", "0")

        GameAddFlagRun("playing_dunktales")
        GamePrint("Gold biome: magic in progress... You are frozen for 3 minutes!")
    end
end
