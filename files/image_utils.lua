
function DunkTales_RenderImages(gui, current_frame, start_frame, pause_frames)
    -- LISTE DES TEMPS (En Secondes) : Configurez précisément l'apparition de chaque image !
    local image_times_sec = {
        0.00, 13, 16.5, 19, 22, 23.5, 25, 28, 30.5, 33.2, -- img 1 à 10
        36, 39, 43, 44.8, 48, 50.3, 53, 56, 60, 62.5, -- img 11 à 20
        64.5, 68, 70.5, 74, 76.3, 79.3, 82, 87, 91, 97, -- img 21 à 30
        102, 104.5, 108, 110, 114, 116, 118.5, 122, 125, 127, -- img 31 à 40
        131, 133.4, 137, 138.5, 142.3, 144.4, 148, 150, 153, 156, -- img 41 à 50
        165, 169, 175, 182 -- img 51 à 54
    }
    
    local elapsed_frames = (current_frame - start_frame) + pause_frames
    local elapsed_sec = elapsed_frames / 60.0 -- Convertir les frames en vraies secondes
    local total_images = #image_times_sec
    local image_index = 1
    
    -- Chercher quelle image devrait être affichée selon le temps qui s'est écoulé
    for i = 1, total_images do
        if elapsed_sec >= image_times_sec[i] then
            image_index = i
        end
    end
    
    -- S'assure de ne pas dépasser la 54ème image
    if image_index > total_images then image_index = total_images end
    if image_index < 1 then image_index = 1 end
    
    -- Formatte l'index sur 2 chiffres (01, 02, ..., 54)
    local formatted_index = string.format("%02d", image_index)
    local img_path = "mods/dunktales_gold/data/imgs/img-" .. formatted_index .. ".png"
    
    -- Obtenir les dimensions de l'écran et de l'image
    local screen_w, screen_h = GuiGetScreenDimensions(gui)
    local img_w, img_h = GuiGetImageDimensions(gui, img_path)
    
    local scale = 1.0
    local center_x = 0
    local center_y = 0
    
    if img_w > 0 and img_h > 0 then
        -- Calcule le ration pour tout faire rentrer parfaitement (Fit)
        local scale_x = screen_w / img_w
        local scale_y = screen_h / img_h
        scale = math.min(scale_x, scale_y)
        
        -- Centre l'image au milieu de l'écran s'il y a des bords noirs
        center_x = (screen_w - (img_w * scale)) / 2
        center_y = (screen_h - (img_h * scale)) / 2
    end
    
    -- Force l'affichage du widget tout devant, PAR-DESSUS les baguettes et l'UI (Z négatif)
    GuiZSetForNextWidget(gui, -10000)
    
    -- ID=1, Position, Image, Alpha=1.0, Scale Proportionnel
    GuiImage(gui, 1, center_x, center_y, img_path, 1.0, scale)
end
