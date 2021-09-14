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

function HellModeToggle.ToggleHellMode()
    if HellModeToggle.config.Enabled then
        local currentHellModeState = GameState.Flags.HardMode

        -- adjusting game properties to match
        if currentHellModeState then

            -- turn off Personal Liability pact option
            GameState.MetaUpgrades["NoInvulnerabilityShrineUpgrade"] = nil

            -- adjust bounties
            for weaponName, weaponRecords in pairs(GameState.RecordClearedShrineThreshold) do
                for roomName, roomWeaponRecord in pairs(weaponRecords) do
                    GameState.RecordClearedShrineThreshold[weaponName][roomName]  = roomWeaponRecord - 5
                end
            end
            GameState.Flags.HardMode = false
        else
            -- turn on forced Hell Mode pact options
            for upgradeName, amount in pairs( HeroData.DefaultHero.HardModeForcedMetaUpgrades ) do
                local upgradeData = MetaUpgradeData[upgradeName]
                if GameState.MetaUpgrades[upgradeName] ~= nil then
                    while GameState.MetaUpgrades[upgradeName] < amount do
                        IncrementTableValue(GameState.MetaUpgrades, upgradeName)
                        ApplyMetaUpgrade( upgradeData, true, GameState.MetaUpgrades[upgradeName] <= 0, true )
                    end
                end
            end
            GameState.MetaUpgrades["NoInvulnerabilityShrineUpgrade"] = 1


            -- adjust bounties
            for weaponName, weaponRecords in pairs(GameState.RecordClearedShrineThreshold) do
                for roomName, roomWeaponRecord in pairs(weaponRecords) do
                    GameState.RecordClearedShrineThreshold[weaponName][roomName]  = roomWeaponRecord + 5
                end
            end

            GameState.Flags.HardMode = true
        end
        GameState.SpentShrinePointsCache = GetTotalSpentShrinePoints()
        UpdateActiveShrinePoints()
    end
end