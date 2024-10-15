Config = {}

Config.defaultlang = "de_lang"


Config.OldVorp = false  -- if you Running an Outaded VORP Core Version
-- Webhook Settings

Config.WebHook = false

Config.WHTitle = 'Deathmatch:'
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Deathmatch:' -- name
Config.WHLogo = '' -- must be 30x30px
Config.WHFooterLogo = '' -- must be 30x30px
Config.WHAvatar = '' -- must be 30x30px

-- Script Settings

Config.StartTimer = 30 -- Time in Sec
Config.DeathmatchArea = vector3(-4209.43, -3457.78, 37.33)
Config.GameTimer = 300
Config.EndSpawnCoords = vector3(-4180.0, -3409.48, 37.14)
Config.MinUsersToStart = 2
Config.RoutingNumber = 22222  -- DO NOT TOUCH

--------------------------------------------------------------------------------
--------- Turn Both to False if you got no Medic Script with Alert Items -------
--------------------------------------------------------------------------------

Config.RemoveAlertItem = false --- If you use Alert Item Like SS-Medical  -- If this is true the alert items will be deleted
Config.ReviveItem = 'birdalert' --- Alert Item
Config.ReviveItemLabel = 'Notruftauben' -- Label of Alert Item

Config.ForbitWithAlertItems = true -- if this is true you cant register with Alert Items in Inventory

--------------------------------------------------------------------------------

Config.DeathMatch = {
    {
        SpawnPed = true,
        Coords = vector3(-4183.98, -3411.03, 37.14),
        Heading = 266.56,
        NPCModel = 'A_M_O_SDUpperClass_01',
        SpawnBlip = true,
        BlipSprite = 'blip_shop_gunsmith',
        Name = 'Deathmatch Event',
    },
}


Config.DeathmatchSpawns = {
    { Coords = vector3(-4224.5, -3465.54, 37.26), Heading = 167.75 },
    { Coords = vector3(-4211.64, -3496.99, 37.14), Heading = 347.95 },
    { Coords = vector3(-4228.76, -3512.35, 37.12), Heading = 358.53 },
    { Coords = vector3(-4266.38, -3473.5, 37.17), Heading = 263.03 },
    { Coords = vector3(-4241.08, -3456.15, 37.14), Heading = 19.18 },
    { Coords = vector3(-4224.9, -3441.9, 37.14), Heading = 282.68 },
    { Coords = vector3(-4203.98, -3418.36, 37.14), Heading = 157.36 },
    { Coords = vector3(-4195.32, -3421.77, 37.15), Heading = 178.89 },
    { Coords = vector3(-4180.79, -3435.1, 37.13), Heading = 76.61 },
    { Coords = vector3(-4195.16, -3450.44, 37.17), Heading = 65.9 },
    { Coords = vector3(-4184.9, -3461.87, 37.33), Heading = 88.27 },
    { Coords = vector3(-4199.64, -3463.64, 37.33), Heading = 28.47 },
    { Coords = vector3(-4203.96, -3444.55, 40.13), Heading = 355.59 },
    { Coords = vector3(-4200.51, -3409.68, 41.53), Heading = 222.74 },
    { Coords = vector3(-4221.86, -3422.79, 41.53), Heading = 159.65 },
    { Coords = vector3(-4233.92, -3426.46, 45.53), Heading = 230.03 },
    { Coords = vector3(-4230.75, -3430.55, 41.53), Heading = 268.34 },
    { Coords = vector3(-4234.38, -3440.79, 43.63), Heading = 243.57 },
    { Coords = vector3(-4247.64, -3452.82, 41.32), Heading = 225.3 },
    { Coords = vector3(-4267.4, -3473.05, 41.4), Heading = 260.55 },
    { Coords = vector3(-4243.89, -3468.13, 41.53), Heading = 311.52 },
    { Coords = vector3(-4220.9, -3466.18, 41.0), Heading = 161.81 },
    { Coords = vector3(-4197.16, -3480.55, 42.51), Heading = 167.75 },
    { Coords = vector3(-4204.1, -3467.94, 45.01), Heading = 54.22 },
    { Coords = vector3(-4184.96, -3457.19, 41.53), Heading = 251.48 },
}