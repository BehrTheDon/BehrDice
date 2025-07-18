-- Create a table called RollDice to hold all our configuration options
RollDice = {}



-- COMMAND OPTIONS
-- The command players will type in chat to roll dice (e.g., /roll)
RollDice.ChatCommand = "roll"

-- Toggle to enable or disable the /roll command (toggle chat command no matter the command name)
RollDice.UseCommand = true

-- The maximum number of dice a player can roll at once
RollDice.MaxDice = 2 -- (Command ONLY)



-- DICE AS ITEM OPTIONS
-- Choose the inventory system: Creates the Useable Item in with your inventory script
RollDice.InventorySystem = "qs" -- Options: "qs" for qs-inventory, "ox" for ox-inventory, or "qb" for qb-inventory, Use "none" to disable item-based dice

-- Name of the item that triggers the dice roll
RollDice.ItemName = "dice" -- You can rename this item

-- The number of dice that will roll when using the item from inventory
RollDice.ItemDiceCount = 2 -- (Dice Item ONLY)

-- Cooldown time in seconds between using the dice item
RollDice.ItemCooldown = 7 -- players must wait 7 seconds before rolling again (Dice Item ONLY/Command does NOT have cooldown)

-- Notification type for Cooldown time for dice item
RollDice.NotificationType = "ox" --  "ox" for ox_lib Notify, "qb" for QBCore Notify, or "chat" for chat message (Dice Item ONLY/Command does NOT have cooldown notification)



-- UNIVERSAL OPTIONS
-- How long (in milliseconds) the dice results will be shown on screen (5000ms = 5 seconds)
RollDice.ShowTime = 5000

-- The maximum distance (in game units/meters) players can be from the roller to see the dice results
RollDice.MaxDistance = 15.0

-- The prefix label used in chat messages (e.g., "[DICE] Usage: /roll 1 or /roll 2")
RollDice.ChatPrefix = "DICE"

-- How long to wait (in milliseconds) after the dice roll animation before showing the result
RollDice.AnimWaitTime = 2000

-- The animation dictionary used when a player rolls dice (you can change this to any valid anim)
RollDice.RollAnim = "anim@mp_player_intcelebrationmale@wank"

-- The specific animation name from the above dictionary to play (can be changed)
RollDice.RollAnimName = "wank"

-- For Developers
RollDice.Debug = false -- Toggle debug mode (true = show debug logs in console, false = silent mode)
RollDice.CheckForUpdates = true -- Set to false to disable version checker