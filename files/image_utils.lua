
function DunkTales_RenderImages(gui, current_frame, start_frame, pause_frames)
    -- TIMESTAMPS (in seconds): set exactly when each image appears!
    local image_times_sec = {
        0.00, 13, 16.5, 19, 22, 23.5, 25, 28, 30.5, 33.2, -- img 1 to 10
        36, 39, 43, 44.8, 48, 50.3, 53, 56, 60, 62.5, -- img 11 to 20
        64.5, 68, 70.5, 74, 76.3, 79.3, 82, 87, 91, 97, -- img 21 to 30
        102, 104.5, 108, 110, 114, 116, 118.5, 122, 125, 127, -- img 31 to 40
        131, 133.4, 137, 138.5, 142.3, 144.4, 148, 150, 153, 156, -- img 41 to 50
        165, 169, 175, 182 -- img 51 to 54
    }
    
    local elapsed_frames = (current_frame - start_frame) + pause_frames
    local elapsed_sec = elapsed_frames / 60.0 -- Convert frames to real seconds
    local total_images = #image_times_sec
    local image_index = 1
    
    -- Find which image should be shown based on the elapsed time
    for i = 1, total_images do
        if elapsed_sec >= image_times_sec[i] then
            image_index = i
        end
    end
    
    -- Make sure we never go past the 54th image
    if image_index > total_images then image_index = total_images end
    if image_index < 1 then image_index = 1 end
    
    -- Format the index with 2 digits (01, 02, ..., 54)
    local formatted_index = string.format("%02d", image_index)
    local img_path = "mods/dunktales_gold/data/imgs/img-" .. formatted_index .. ".png"
    
    -- Get the screen and image dimensions
    local screen_w, screen_h = GuiGetScreenDimensions(gui)
    local img_w, img_h = GuiGetImageDimensions(gui, img_path)
    
    local scale = 1.0
    local center_x = 0
    local center_y = 0
    
    if img_w > 0 and img_h > 0 then
        -- Compute the ratio so the whole image fits perfectly (Fit)
        local scale_x = screen_w / img_w
        local scale_y = screen_h / img_h
        scale = math.min(scale_x, scale_y)
        
        -- Center the image on screen if there are black bars
        center_x = (screen_w - (img_w * scale)) / 2
        center_y = (screen_h - (img_h * scale)) / 2
    end
    
    -- Force the widget to draw in front, OVER the wands and the UI (negative Z)
    GuiZSetForNextWidget(gui, -10000)
    
    -- ID=1, Position, Image, Alpha=1.0, Proportional scale
    GuiImage(gui, 1, center_x, center_y, img_path, 1.0, scale)
end
