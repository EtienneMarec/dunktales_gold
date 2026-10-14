local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local biome_name = BiomeMapGetName(x, y) or ""
local is_gold_biome = string.match(biome_name, "gold")

local current_frame = GameGetFrameNum()
local music_duration_frames = 192 * 60 -- 3 minutes et 12 secondes à 60 FPS

-- VÉRIFICATION DU TIMER DE BLOCAGE
local target_frame = tonumber(GlobalsGetValue("dunktales_target_frame", "0"))
local start_frame = tonumber(GlobalsGetValue("dunktales_start_frame", "0"))
local pause_frames = tonumber(GlobalsGetValue("dunktales_pause_frames", "0"))

if target_frame > 0 then
    local elapsed_frames = (current_frame - start_frame) + pause_frames
    if elapsed_frames >= music_duration_frames then
        -- FIN DU BLOCAGE : On réactive les contrôles !
        local controls = EntityGetFirstComponentIncludingDisabled(entity_id, "ControlsComponent")
        if controls ~= nil then EntitySetComponentIsEnabled(entity_id, controls, true) end
        
        local inventory = EntityGetFirstComponentIncludingDisabled(entity_id, "Inventory2Component")
        if inventory ~= nil then EntitySetComponentIsEnabled(entity_id, inventory, true) end

        -- SECOND NETTOYAGE D'OR (À la toute fin du timer !)
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
        GamePrint("Musique terminée, vous pouvez reprendre l'exploration !")
    else
        -- PENDANT LE BLOCAGE : On force l'immobilité
        local controls = EntityGetFirstComponent(entity_id, "ControlsComponent")
        if controls ~= nil then EntitySetComponentIsEnabled(entity_id, controls, false) end
        
        local inventory = EntityGetFirstComponent(entity_id, "Inventory2Component")
        if inventory ~= nil then EntitySetComponentIsEnabled(entity_id, inventory, false) end
        
        -- On fixe la vélocité à 0 pour éviter qu'il glisse
        local char_data = EntityGetFirstComponent(entity_id, "CharacterDataComponent")
        if char_data ~= nil then ComponentSetValue2(char_data, "mVelocity", 0, 0) end
    end
end

if is_gold_biome then
    -- Si on est dans le biome et que le son ne joue pas encore
    if not GameHasFlagRun("playing_dunktales") then
        -- LECTURE MUSICALE (Retour à la version initiale)
        GamePlaySound("mods/dunktales_gold/data/audio/Desktop/dunktalesbank.bank", "DunkTales", x, y)

        -- RÉCOMPENSE INSTANTANÉE
        local wallet = EntityGetFirstComponent(entity_id, "WalletComponent")
        if wallet ~= nil then
            local current_money = ComponentGetValue2(wallet, "money")
            ComponentSetValue2(wallet, "money", current_money + 258674)
        end
        
        -- SUPPRESSION DE LA MATIÈRE OR
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

        -- ON VERROUILLE LE JOUEUR
        GlobalsSetValue("dunktales_start_frame", tostring(current_frame))
        GlobalsSetValue("dunktales_target_frame", tostring(current_frame + music_duration_frames))
        GlobalsSetValue("dunktales_pause_frames", "0")

        GameAddFlagRun("playing_dunktales")
        GamePrint("Biome Gold : Magie en cours... Vous êtes immobilisé pour 3 minutes !")
    end
end
