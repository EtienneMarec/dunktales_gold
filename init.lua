-- On enregistre le fichier GUIDs
function OnModPreInit()
    ModRegisterAudioEventMappings("mods/dunktales_gold/GUIDs.txt")
end

-- Pour être sûr, on imprime aussi dans la console quand vous apparaissez
function OnPlayerSpawned(player_entity)
    if not GameHasFlagRun("musiquedunk_lancee") then
        -- On attache UNIQUEMENT le composant script qui va scruter le biome
        EntityAddComponent2(player_entity, "LuaComponent", {
            script_source_file = "mods/dunktales_gold/files/music_checker.lua",
            execute_every_n_frame = 1 -- INDISPENSABLE POUR AFFICHER DU TEXTE/IMAGES (60FPS)
        })

        GameAddFlagRun("musiquedunk_lancee")
    end
end

-- GESTION DE L'AFFICHAGE ET DE LA SYNCHRO (JEU + PAUSE)
local dunktales_gui = nil
local music_duration_frames = 192 * 60 -- 3 minutes et 12 secondes à 60 FPS

function OnWorldPreUpdate()
    -- On nettoie systématiquement le GUI de pause à chaque frame de jeu
    -- Cela évite que la dernière image reste bloquée à l'écran après la fin ou après avoir quitté la pause
    if dunktales_gui ~= nil then
        GuiStartFrame(dunktales_gui)
    end

    -- AFFICHAGE PENDANT LE JEU
    if GameHasFlagRun("playing_dunktales") then
        local target_frame = tonumber(GlobalsGetValue("dunktales_target_frame", "0"))
        if target_frame > 0 then
            local current_frame = GameGetFrameNum()
                local start_frame = tonumber(GlobalsGetValue("dunktales_start_frame", "0"))
                local pause_frames = tonumber(GlobalsGetValue("dunktales_pause_frames", "0"))
                local elapsed_frames = (current_frame - start_frame) + pause_frames

                if elapsed_frames < music_duration_frames then
                    dunktales_gui = dunktales_gui or GuiCreate()
                    dofile_once("mods/dunktales_gold/files/image_utils.lua")
                    DunkTales_RenderImages(dunktales_gui, current_frame, start_frame, pause_frames)
                end
        end
    end
end

function OnPausePreUpdate()
    dunktales_gui = dunktales_gui or GuiCreate()
    GuiStartFrame(dunktales_gui)
    
    if GameHasFlagRun("playing_dunktales") then
        local target_frame = tonumber(GlobalsGetValue("dunktales_target_frame", "0"))
        local current_frame = GameGetFrameNum()
        if target_frame > 0 then
            local start_frame = tonumber(GlobalsGetValue("dunktales_start_frame", "0"))
            local pause_frames = tonumber(GlobalsGetValue("dunktales_pause_frames", "0"))
            pause_frames = pause_frames + 1
            GlobalsSetValue("dunktales_pause_frames", tostring(pause_frames))
            
            local elapsed_frames = (current_frame - start_frame) + pause_frames
            
            if elapsed_frames < music_duration_frames then
                dofile_once("mods/dunktales_gold/files/image_utils.lua")
                DunkTales_RenderImages(dunktales_gui, current_frame, start_frame, pause_frames)
            end
        end
    end
end
