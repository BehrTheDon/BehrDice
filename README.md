# BehrDice
# 🎲 FiveM Dice Roll Script — Immersive Visual Dice for RP Servers

A standalone-compatible, plug-and-play dice rolling system for FiveM with realistic animations, floating 2D dice face sprites, and optional inventory integration. Perfect for Shooting dice with your homies — all while keeping it highly configurable and framework-flexible.

![Preview](https://i.imgur.com/YOUR-GIF-HERE.gif) <!-- Replace with your GIF/video thumbnail -->

---

## 📌 Features

- 🎲 Supports 1 or 2 dice rolls with `/roll`
- 🎲 Supports 1 or 2 dice rolls with Dice Item (Choose In Config)
- 🧍‍♂️ Animation plays for the player rolling the dice
- 🌐 Others nearby see floating dice face images above the player's head
- 🎨 Includes customizable dice face textures (1–6)
- ⚙️ Easy-to-edit `config.lua` for framework, inventory, distance, animations, etc.
- 🔁 Compatible with **ESX**, **QBCore**, **Standalone**
- 🧩 Supports **OX Inventory**, **QS-Inventory**, **QB-Inventory** or no inventory at all
- 🔧 Debug mode for development/testing
- 📦 Lightweight and optimized

---

## 🎥 Showcase

> Coming soon!

---

## 🧰 Requirements

| Dependency               | Required  | Description                                                           |
|--------------------------|-----------|-----------------------------------------------------------------------|
| Any Framework            | ✅       | Works with ESX, QBCore, or none (standalone)                          |
| ob_lib (optional)        | 🔁       | Optional ox_lib Notifications if using Dice Item for cooldowns        |
| Inventory (optional)     | ⚠️       | Ox, Quasar, and QB Inventorys Supported for Dice Item                 |

---

## 🧪 Compatibility Matrix

| Feature                  | ESX      | QBCore   | Standalone |
|--------------------------|----------|----------|------------|
| Usable Item Support      | ✅       | ✅       | ❌       |
| `/roll` Chat Command     | ✅       | ✅       | ✅       |
Inventory Compatibility
| QS-Inventory Support     | ✅       | ✅       | ❌       |
| OX-Inventory Support     | ❓       | ❓       | ❌       |
| QB-Inventory Support     | ❌       | ❓       | ❌       |
| Custom Inventory Support | ✅       | ✅       | ❌       |
Notifications Compatibility
| ob_lib (optional)        | ✅       | ✅       | ❌       |
| QBCoreNotify (optional)  | ❌       | ❓       | ❌       |
| Default Chat Message     | ✅       | ✅       | ✅       |
| Custom Notify Support    | ✅       | ✅       | ❌       |

- I do not have a QBCore server so if anyone is willing to test and let me know the results and I will update QBCore information.  
- I will update the compatibility matix once I have tested this script with any that have a ❓.  
- Everything is completely open-source and commented, Edit and add your own inventory and notification scripts!

---

## 📁 Installation

1. **Download or Clone This Repository**

    ```
    git clone https://github.com/BehrTheDon/BehrDice.git
    ```

2. **Drag `BehrDice` Into Your `resources` Folder**

3. **Add to `server.cfg`**
    ```ini
    ensure BehrDice
    ```

4. **Change Dice Textures**

    - Default dice pictures are provided, but here is how to add your own images.  
    - Place your custom `dice1.png` through `dice6.png` in `stream/roll_dice.ytd`.  
    - You can use OpenIV or Texture Toolkit to pack these PNGs into `roll_dice.ytd`.  
    - Check the `BehrDice/stream` folder for the default PNGs and YTD  

5. **Configure Framework & Inventory**

    Open `config.lua` and select your setup:
    
    ```lua
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
    ```

6. **Optional: Add Dice Item to Inventory System**

    Example for QS-Inventory:
    ```lua
    ['dice'] = {
        ['name'] = "dice",
        ['label'] = "Dice",
        ['weight'] = 100,
        ['type'] = "item",
        ['image'] = "dice.png",
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = "Shake and roll the dice!"
    },
    ```
    Example for QB-Inventory:
    ```lua
    ["dice"] = {
        name = "dice",
        label = "Dice",
        weight = 100,
        type = "item",
        image = "dice.png",
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Shake and roll the dice!"
    },
    ```
    Example for OX-Inventory:
    ```lua
    ['dice'] = {
        label = 'Dice',
        weight = 100,
        stack = true,
        close = true,
        description = 'Shake and roll the dice!',
        client = {
            image = 'dice.png'
        }
    },
    ```
    Dice inventory image is provided for you inside the `BehrDice/install first/images` folder.

---

## ⚒️ How It Works

1. Player types `/roll (1/2)` to roll 1 or 2 dice. (Can Be Disabled if using Inventory item.)  

Set this in `config.lua` to disable the dice command:
```lua
RollDice.UseCommand = false
```
2. Player uses the dice item to roll 1 or 2 dice. Choose 1 or 2 in the config. (Can Be Disabled if using Command.)  

Set this in `config.lua` to disable the dice inventory items:
```lua
RollDice.InventorySystem = "none"
```
3. A roll animation plays on their ped.
4. Nearby players see 2D dice sprites float above the player’s head.
5. The number rolled appears as a sprite using `DrawSprite()` with `roll_dice.ytd`.

---

## 🚧 Developer Notes

- Fully modular architecture
- Easy to extend to more dice or effects
- Uses `DrawSprite` for 3D-world 2D UI that’s synced and visible to others
- Uses a version check pinging GitHub to notify server owners of updates

---

## 🔍 Debugging

Set this in `config.lua`:
```lua
RollDice.Debug = true
```