--[[
    HellModeToggle
    Author:
        cgull (Discord: cgull#4469)

    Provides functionality for other mods to toggle hell mode
]]

ModUtil.RegisterMod("HellModeToggle")

local config = {
    Enabled = true,
}
HellModeToggle.config = config

function HellMode.ToggleHellMode()
    if HellModeToggle.config.Enabled then
        local currentHellModeState = GameState.Flags.HardMode

        -- adjusting game properties to match
        if currentHellModeState then
            GameState.Flags.HardMode = false

            -- turn off Personal Liability pact option
            GameState.MetaUpgrades[NoInvulnerabilityShrineUpgrade] = 0

            -- adjust bounties
            for weaponName, weaponRecords in pairs(GameState.RecordClearedShrineThreshold) do
                for roomName, roomWeaponRecord in pairs(weaponRecords) do
                    GameState.RecordClearedShrineThreshold[weaponName][roomName]  = roomWeaponRecord - 5
                end
            end
        else
            -- turn on forced Hell Mode pact options
            for name, amount in pairs( HeroData.DefaultHero.HardModeForcedMetaUpgrades ) do
                if GameState.MetaUpgrades[name] < amount then
                    GameState.MetaUpgrades[name] = amount
                end
            end

            -- adjust bounties
            for weaponName, weaponRecords in pairs(GameState.RecordClearedShrineThreshold) do
                for roomName, roomWeaponRecord in pairs(weaponRecords) do
                    GameState.RecordClearedShrineThreshold[weaponName][roomName]  = roomWeaponRecord + 5
                end
            end

            GameState.Flags.HardMode = true
        end
    end
end