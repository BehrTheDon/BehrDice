-- Register a client event named "RollDice:Client:Show"
RegisterNetEvent("RollDice:Client:Show")

-- Add an event handler function for the above event
AddEventHandler("RollDice:Client:Show", function(sourceId, rolls)
    -- Get the current player's server ID
    local myId = GetPlayerServerId(PlayerId())

    -- Get the player index of the player who rolled the dice using their server ID
    local srcPlayer = GetPlayerFromServerId(sourceId)

    -- Get the ped (character entity) for the source player
    local srcPed = GetPlayerPed(srcPlayer)

    -- If debug mode is enabled, print out debug info
    if RollDice.Debug then
        print("[RollDice DEBUG] Received roll event from:", sourceId)
        print("[RollDice DEBUG] Rolls:", json.encode(rolls))
        print("[RollDice DEBUG] My ID:", myId, "SourcePed Exists:", srcPed and true or false)
    end

    -- If the source ped doesn't exist or isn't valid, stop here
    if not srcPed or not DoesEntityExist(srcPed) then
        if RollDice.Debug then print("[RollDice ERROR] Source ped not found or does not exist.") end
        return
    end

    -- If the player rolling the dice is the local player
    if myId == sourceId then
        -- Play the dice roll animation
        PlayRollAnim(srcPed)
        -- If debugging, notify that we are waiting for the animation to finish
        if RollDice.Debug then print("[RollDice DEBUG] Waiting 2 seconds for animation to finish...") end
        -- Wait for x seconds (adjust this in config to match animation duration)
        Wait(RollDice.AnimWaitTime)
    end

    -- Calculate the distance between the local player and the dice roller
    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(srcPed))

    -- If debug mode is enabled, print out the distance and allowed max distance
    if RollDice.Debug then
        print(("[RollDice DEBUG] Distance to roller: %.2f, Max allowed: %.2f"):format(dist, RollDice.MaxDistance))
    end

    -- Only show the dice sprites if the roller is within viewable range
    if dist <= RollDice.MaxDistance then
        ShowDiceSprites(rolls, srcPed, RollDice.ShowTime)
    end
end)

-- Function to play the dice roll animation on the ped
function PlayRollAnim(ped)
    -- Set the animation dictionary to use (or default)
    local dict = RollDice.RollAnim or "anim@mp_player_intcelebrationmale@wank"

    -- Set the animation name to play (or default)
    local anim = RollDice.RollAnimName or "wank"

    -- Request the animation dictionary to load
    RequestAnimDict(dict)

    -- Wait until the animation dictionary is fully loaded
    while not HasAnimDictLoaded(dict) do
        if RollDice.Debug then print("[RollDice DEBUG] Loading anim dict:", dict) end
        Wait(0)
    end

    -- Play the animation on the ped with set speed, duration, flags
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, 2000, 49, 0, false, false, false)
end

-- Function to show dice sprites above the ped’s head for a duration
function ShowDiceSprites(rolls, targetPed, duration)
    -- Get the current game time to use as the start time
    local start = GetGameTimer()
    -- Set the showing flag to true to keep the loop running
    local showing = true
    -- Name of the texture dictionary containing dice images
    local texDict = "roll_dice"

    -- Check if the texture dictionary is loaded
    if not HasStreamedTextureDictLoaded(texDict) then
        -- Request it if it's not loaded
        RequestStreamedTextureDict(texDict, true)
        -- Set a timeout to prevent infinite loops
        local timeout = GetGameTimer() + 5000
        -- Wait for the dictionary to finish loading or timeout
        while not HasStreamedTextureDictLoaded(texDict) do
            if GetGameTimer() > timeout then
                if RollDice.Debug then print("[RollDice ERROR] Failed to load texture dictionary:", texDict) end
                return
            end
            Wait(10)
        end
        -- If debugging, notify that the texture dictionary has loaded
        if RollDice.Debug then print("[RollDice DEBUG] Loaded texture dictionary:", texDict) end
    end

    -- Start a separate thread to draw the dice sprites
    Citizen.CreateThread(function()
        while showing do
            -- Stop showing if the duration has passed
            if GetGameTimer() - start > duration then
                showing = false
                break
            end

            -- If the target ped no longer exists, stop drawing
            if not DoesEntityExist(targetPed) then
                if RollDice.Debug then print("[RollDice ERROR] Target ped no longer exists during draw loop.") end
                break
            end

            -- Get the coordinates of the ped
            local pedCoords = GetEntityCoords(targetPed)
            -- Offset the position upwards above the head
            local pos = pedCoords + vector3(0.0, 0.0, 1.2)
            -- Convert the 3D position to 2D screen coordinates
            local onScreen, x, y = World3dToScreen2d(pos.x, pos.y, pos.z)

            -- If debugging, print ped position and screen coordinates
            if RollDice.Debug then
                print("[RollDice DEBUG] Ped Coords:", pedCoords)
                print("[RollDice DEBUG] Screen Position:", x, y, "Visible:", onScreen)
            end

            -- If the dice roller is currently on-screen (visible to the local player)
            if onScreen then

                -- Count how many dice were rolled (1 or 2)
                local totalDice = #rolls

                -- Define the horizontal space between each dice image on screen
                local spacing = 0.05

                -- Calculate the starting X position to horizontally center the entire group of dice
                -- If 1 die, baseX = x; if 2 dice, baseX = x - spacing / 2
                local baseX = x - ((totalDice - 1) * spacing / 2)

                -- Loop through each dice roll result
                for i, roll in ipairs(rolls) do

                    -- Get the name of the sprite to draw based on the rolled number (e.g., "dice1", "dice2", ..., "dice6")
                    local spriteName = "dice" .. roll

                    -- If debug is enabled, print out the sprite being drawn and its exact screen position
                    if RollDice.Debug then
                        print(("[RollDice DEBUG] Drawing sprite '%s' at screen pos X:%.3f Y:%.3f"):format(spriteName, baseX + (i - 1) * spacing, y))
                    end

                    -- Draw the dice image at the calculated position with fixed width/height (0.05 units)
                    -- baseX centers the group; (i - 1) * spacing offsets each die from the start
                    DrawSprite(texDict, spriteName, baseX + (i - 1) * spacing, y, 0.05, 0.05, 0.0, 255, 255, 255, 255)
                end
            end
            -- Wait one frame before continuing the loop
            Wait(0)
        end
    end)
end

-- Suggest the /roll command in the chat box if enabled in config
Citizen.CreateThread(function()
    -- If the config allows use of the command
    if RollDice.UseCommand then
        -- Register a suggestion in the chat for the /roll command
        TriggerEvent('chat:addSuggestion', '/' .. RollDice.ChatCommand, 'Roll one or two dice using a visible dice roll animation above your head.', {
            { name = "amount", help = "Number of dice to roll (1 or 2)" }
        })

        -- If debugging, print that the chat command suggestion was added
        if RollDice.Debug then
            print("[RollDice DEBUG] Chat suggestion registered for '/" .. RollDice.ChatCommand .. "'")
        end
    end
end)
