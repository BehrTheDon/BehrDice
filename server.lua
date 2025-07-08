-- Define the current version of the script
RollDice.Version = "1.0.1"

-- Table to track cooldowns for each player using the dice item
local lastDiceUse = {}

-- Only register the /roll command if it's enabled in config
if RollDice.UseCommand then

    -- Register a chat command (e.g., /roll) using the name set in config
    RegisterCommand(RollDice.ChatCommand, function(source, args)

        -- Convert the first argument (e.g., "2") to a number
        local num = tonumber(args[1])

        -- Check if it's a valid number within the allowed range
        if not num or num < 1 or num > RollDice.MaxDice then
            -- Tell the player how to use the command properly
            TriggerClientEvent('chatMessage', source, RollDice.ChatPrefix or "SYSTEM", {255, 0, 0}, "Usage: /roll 1 or /roll 2")
            return
        end

        -- Create a table to store rolled dice values
        local rolls = {}

        -- Roll the dice `num` times, each between 1-6
        for i = 1, num do
            table.insert(rolls, math.random(1, 6))
        end

        -- If debug is enabled, print result in console
        if RollDice.Debug then
            print(("^2[RollDice]^7 Player [%s] rolled: %s"):format(source, table.concat(rolls, ", ")))
        end

        -- Send roll result to all clients
        TriggerClientEvent("RollDice:Client:Show", -1, source, rolls)

    -- Prevent use of /roll from the server console
    end, false)

else
    -- If the /roll command is disabled, log that info
    if RollDice.Debug then
        print("^3[RollDice]^7 /" .. RollDice.ChatCommand .. " command is disabled in config.")
    end
end

-- If using an inventory system other than "none"
if RollDice.InventorySystem ~= "none" then

    -- QS-INVENTORY HANDLER
    if RollDice.InventorySystem == "qs" and GetResourceState('qs-inventory') == "started" then

        -- Register the dice item as usable
        exports['qs-inventory']:CreateUsableItem(RollDice.ItemName, function(source, item)
            local now = os.time()

            -- Cooldown check
            if lastDiceUse[source] and now - lastDiceUse[source] < RollDice.ItemCooldown then
                local remaining = RollDice.ItemCooldown - (now - lastDiceUse[source])

                -- Notify player via chosen notification method
                if RollDice.NotificationType == "ox" then
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = 'error',
                        title = RollDice.ChatPrefix or "DICE",
                        description = ("You must wait %d more seconds before rolling again."):format(remaining)
                    })
                elseif RollDice.NotificationType == "qb" then
                    TriggerClientEvent('QBCore:Notify', source, ("You must wait %d more seconds before rolling again."):format(remaining), "error")
                elseif RollDice.NotificationType == "chat" then
                    TriggerClientEvent('chat:addMessage', source, {
                        color = {255, 0, 0},
                        args = {RollDice.ChatPrefix or "DICE", ("You must wait %d more seconds before rolling again."):format(remaining)}
                    })
                end
                return
            end

            lastDiceUse[source] = now

            -- Generate dice results
            local rolls = {}
            for i = 1, RollDice.MaxDice do table.insert(rolls, math.random(1, 6)) end

            if RollDice.Debug then
                print(("^2[RollDice]^7 [QS] Player [%s] used item '%s' and rolled: %s")
                    :format(source, RollDice.ItemName, table.concat(rolls, ", ")))
            end

            -- Show results to all players
            TriggerClientEvent("RollDice:Client:Show", -1, source, rolls)
        end)

    -- OX-INVENTORY HANDLER
    elseif RollDice.InventorySystem == "ox" and GetResourceState('ox_inventory') == "started" then

        -- Register usable dice item
        exports['ox_inventory']:RegisterUsableItem(RollDice.ItemName, function(source)
            local now = os.time()

            if lastDiceUse[source] and now - lastDiceUse[source] < RollDice.ItemCooldown then
                local remaining = RollDice.ItemCooldown - (now - lastDiceUse[source])

                if RollDice.NotificationType == "ox" then
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = 'error',
                        title = RollDice.ChatPrefix or "DICE",
                        description = ("You must wait %d more seconds before rolling again."):format(remaining)
                    })
                elseif RollDice.NotificationType == "qb" then
                    TriggerClientEvent('QBCore:Notify', source, ("You must wait %d more seconds before rolling again."):format(remaining), "error")
                elseif RollDice.NotificationType == "chat" then
                    TriggerClientEvent('chat:addMessage', source, {
                        color = {255, 0, 0},
                        args = {RollDice.ChatPrefix or "DICE", ("You must wait %d more seconds before rolling again."):format(remaining)}
                    })
                end
                return
            end

            lastDiceUse[source] = now

            local rolls = {}
            for i = 1, RollDice.MaxDice do table.insert(rolls, math.random(1, 6)) end

            if RollDice.Debug then
                print(("^2[RollDice]^7 [OX] Player [%s] used item '%s' and rolled: %s"):format(source, RollDice.ItemName, table.concat(rolls, ", ")))
            end

            TriggerClientEvent("RollDice:Client:Show", -1, source, rolls)
        end)

    -- QB-INVENTORY HANDLER
    elseif RollDice.InventorySystem == "qb" and GetResourceState('qb-inventory') == "started" then

        -- Get QBCore object
        local QBCore = exports['qb-core']:GetCoreObject()

        -- Register usable dice item
        QBCore.Functions.CreateUseableItem(RollDice.ItemName, function(source, item)
            local now = os.time()

            if lastDiceUse[source] and now - lastDiceUse[source] < RollDice.ItemCooldown then
                local remaining = RollDice.ItemCooldown - (now - lastDiceUse[source])

                if RollDice.NotificationType == "ox" then
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = 'error',
                        title = RollDice.ChatPrefix or "DICE",
                        description = ("You must wait %d more seconds before rolling again."):format(remaining)
                    })
                elseif RollDice.NotificationType == "qb" then
                    TriggerClientEvent('QBCore:Notify', source, ("You must wait %d more seconds before rolling again."):format(remaining), "error")
                elseif RollDice.NotificationType == "chat" then
                    TriggerClientEvent('chat:addMessage', source, {
                        color = {255, 0, 0},
                        args = {RollDice.ChatPrefix or "DICE", ("You must wait %d more seconds before rolling again."):format(remaining)}
                    })
                end
                return
            end

            lastDiceUse[source] = now

            local rolls = {}
            for i = 1, RollDice.MaxDice do table.insert(rolls, math.random(1, 6)) end

            if RollDice.Debug then
                print(("^2[RollDice]^7 [QB] Player [%s] used item '%s' and rolled: %s"):format(source, RollDice.ItemName, table.concat(rolls, ", ")))
            end

            TriggerClientEvent("RollDice:Client:Show", -1, source, rolls)
        end)

    else
        -- No supported inventory system was found/running
        print("^1[RollDice]^7 ERROR: No supported inventory system found. Set RollDice.InventorySystem to 'qs', 'ox', 'qb', or 'none'.")
    end

-- If inventory system is "none", skip item-based registration
else
    if RollDice.Debug then
        print("^3[RollDice]^7 Inventory system set to 'none'. Only /roll command will be usable.")
    end
end


if RollDice.CheckForUpdates then
    -- VERSION CHECK (GitHub)
    CreateThread(function()
        local currentVersion = RollDice.Version
        -- Link to version file on GitHub (change to your own repo)
        local repoURL = "https://raw.githubusercontent.com/BehrTheDon/BehrDice/main/version.txt"

        -- Request the file from GitHub
        PerformHttpRequest(repoURL, function(code, latestVersion, headers)
            -- If successful
            if code == 200 and latestVersion then
                latestVersion = latestVersion:gsub("%s+", "") -- Trim whitespace

                -- Compare versions
                if latestVersion ~= currentVersion then
                    -- New version found
                    print("^3[BehrDice]^7 Update available! Current version: ^1" .. currentVersion .. "^7, Latest: ^2" .. latestVersion)
                    print("^3[BehrDice]^7 Download the latest version at: ^5https://github.com/BehrTheDon/BehrDice")
                else
                    -- Already latest
                    print("^2[BehrDice]^7 You are running the latest version: " .. currentVersion .. "^2 Thanks for using Behr Dice!")
                end
            else
                -- Request failed
                print("^1[BehrDice]^7 Version check failed. Could not reach GitHub.")
            end
        end)
    end)
else
    if RollDice.Debug then
        print("^3[BehrDice]^7 Version checker is disabled via config.")
    end
end