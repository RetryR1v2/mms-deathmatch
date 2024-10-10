local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-deathmatch/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

local RegistredUsers = {}
local TimerStarted = false
local DeathmatchStarted = false
local PlayerPeds = {}

RegisterServerEvent('mms-deathmatch:server:RegisterForEvent',function ()
    local src = source
    local HasItemAmount = exports.vorp_inventory:getItemCount(src, nil, Config.ReviveItem,nil)
    local ImRegistred = false
    if Config.ForbitWithAlertItems then
        if HasItemAmount > 0 then
            VORPcore.NotifyTip(src,_U('CantRegister') .. Config.ReviveItemLabel,5000)
        else
            if not TimerStarted and not DeathmatchStarted then
                TimerStarted = true
                RegistredUsers[#RegistredUsers + 1] = src
                for _, player in ipairs(GetPlayers()) do
                    local RegistredAmount = #RegistredUsers
                            TriggerClientEvent('mms-deathmatch:client:AddPlayer', player,RegistredAmount)
                end
                StartTimer()
            elseif TimerStarted and not DeathmatchStarted then
                for h,v in ipairs(RegistredUsers) do
                    if v == src then
                        ImRegistred = true
                    end
                end
                if not ImRegistred and not DeathmatchStarted then
                    RegistredUsers[#RegistredUsers + 1] = src
                    for _, player in ipairs(GetPlayers()) do
                        local RegistredAmount = #RegistredUsers
                        TriggerClientEvent('mms-deathmatch:client:AddPlayer', player,RegistredAmount)
                    end
                else
                    ImRegistred = false
                end
            end
        end 
    else
        if not TimerStarted and not DeathmatchStarted then
            TimerStarted = true
            RegistredUsers[#RegistredUsers + 1] = src
            for _, player in ipairs(GetPlayers()) do
                local RegistredAmount = #RegistredUsers
                        TriggerClientEvent('mms-deathmatch:client:AddPlayer', player,RegistredAmount)
            end
            StartTimer()
        elseif TimerStarted and not DeathmatchStarted then
            for h,v in ipairs(RegistredUsers) do
                if v == src then
                    ImRegistred = true
                end
            end
            if not ImRegistred and not DeathmatchStarted then
                RegistredUsers[#RegistredUsers + 1] = src
                for _, player in ipairs(GetPlayers()) do
                    local RegistredAmount = #RegistredUsers
                    TriggerClientEvent('mms-deathmatch:client:AddPlayer', player,RegistredAmount)
                end
            else
                ImRegistred = false
            end
        end
    end
end)

function StartTimer()
    local counter = Config.StartTimer
    while TimerStarted do
        Citizen.Wait(1000)
        counter = counter - 1
        for h,v in ipairs(RegistredUsers) do
            VORPcore.NotifyRightTip(v,_U('TimerTillStart') .. counter,1000)
        end
        if counter == 0 then
            TimerStarted = false
            counter = 0
            if Config.RemoveAlertItem then
                RemoveReviveItems()
            end
            if #RegistredUsers > Config.MinUsersToStart then
                StartDeathmatch()
            else
                for h,v in ipairs(RegistredUsers) do
                    VORPcore.NotifyTip(v, _U('NotEnoghPlayers'),  5000)
                end
                EndDeathmatch()
            end
        end
    end
end

function RemoveReviveItems()
    for h,v in ipairs(RegistredUsers) do
        local HasItemAmount = exports.vorp_inventory:getItemCount(v, nil, Config.ReviveItem,nil)
            if HasItemAmount > 0 then
                exports.vorp_inventory:subItem(v, Config.ReviveItem, HasItemAmount)
            end
    end
end

function StartDeathmatch()
    DeathmatchStarted = true
    for h,v in ipairs(RegistredUsers) do
        local MaxRandom = #Config.DeathmatchSpawns
        local Random = math.random(1,MaxRandom)
        local PickedSpawn = Config.DeathmatchSpawns[Random]
        local PlayerPed = GetPlayerPed(v)
        SetEntityCoords(PlayerPed,PickedSpawn.Coords.x,PickedSpawn.Coords.y,PickedSpawn.Coords.z,true,true,false,true)
        SetEntityHeading(PlayerPed,PickedSpawn.Heading)
        PlayerPeds[#PlayerPeds + 1] = PlayerPed
        TriggerClientEvent('mms-deathmatch:client:CheckDeath',v,PlayerPed)
    end
    DeathmatchTimer()
end

RegisterServerEvent('mms-deathmatch:server:IDied',function(PlayerPed,KillerSource) -- This Ped is Send from Client
    local src = source
    local myChar = VORPcore.getUser(src).getUsedCharacter
    local KillerChar = VORPcore.getUser(KillerSource).getUsedCharacter
    local myFirstname = myChar.firstname
    local myLastname = myChar.lastname
    local myCharIdentifier = myChar.charIdentifier
    local KillerFirstname = KillerChar.firstname
    local KillerLastname = KillerChar.lastname
    local KillerCharIdentifier = KillerChar.charIdentifier
    for _, players in ipairs(RegistredUsers) do
        VORPcore.NotifyTip(players,myFirstname .. ' ' .. myLastname .. _U('KilledBy') .. KillerFirstname .. ' ' .. KillerLastname,4000)
    end
    local result = MySQL.query.await("SELECT * FROM mms_deathmatch WHERE charidentifier=@charidentifier", { ["charidentifier"] = myCharIdentifier})
    if #result > 0 then
        local newamount = result[1].deaths + 1
        MySQL.update('UPDATE `mms_deathmatch` SET deaths = ? WHERE charidentifier = ?',{newamount, myCharIdentifier})
    else
        MySQL.insert('INSERT INTO `mms_deathmatch` (charidentifier, firstname,lastname,kills,deaths) VALUES (?,?,?,?,?)',
        {myCharIdentifier,myFirstname,myLastname,0,1}, function()end)
    end
    local result2 = MySQL.query.await("SELECT * FROM mms_deathmatch WHERE charidentifier=@charidentifier", { ["charidentifier"] = KillerCharIdentifier})
    if #result2 > 0 then
        local newamount2 = result2[1].kills + 1
        MySQL.update('UPDATE `mms_deathmatch` SET kills = ? WHERE charidentifier = ?',{newamount2, KillerCharIdentifier})
    else
        MySQL.insert('INSERT INTO `mms_deathmatch` (charidentifier, firstname,lastname,kills,deaths) VALUES (?,?,?,?,?)',
        {KillerCharIdentifier,KillerFirstname,KillerLastname,1,0}, function()end)
    end
end)

RegisterServerEvent('mms-deathmatch:server:Respawn',function (PlayerPed)
    local src = source
    VORPcore.Player.Revive(src)
    if DeathmatchStarted then 
        local MaxRandom = #Config.DeathmatchSpawns
        local Random = math.random(1,MaxRandom)
        local PickedSpawn = Config.DeathmatchSpawns[Random]
        SetEntityCoords(PlayerPed,PickedSpawn.Coords.x,PickedSpawn.Coords.y,PickedSpawn.Coords.z,true,true,false,true)
        SetEntityHeading(PlayerPed,PickedSpawn.Heading)
    elseif not DeathmatchStarted then
        SetEntityCoords(PlayerPed,Config.EndSpawnCoords.x,Config.EndSpawnCoords.y,Config.EndSpawnCoords.z - 0.8,true,true,false,true)
    end
end)

function DeathmatchTimer()
    local DeathmatchCounter = Config.GameTimer
    while DeathmatchStarted do
        Citizen.Wait(1000)
        DeathmatchCounter = DeathmatchCounter - 1
        for h,v in ipairs(RegistredUsers) do
            VORPcore.NotifyRightTip(v,_U('Timer') .. DeathmatchCounter,1000)
        end
        if DeathmatchCounter == 0 then
            for h,v in ipairs(RegistredUsers)do
                TriggerClientEvent('mms-deathmatch:client:EndDeathmatch',v)
            end
            EndDeathmatch()
        end
    end
end

RegisterServerEvent('mms-deathmatch:server:GetScoreBoard',function()
    local src = source
    exports.oxmysql:execute('SELECT * FROM mms_deathmatch', {}, function(highscores)
    if highscores and #highscores > 0 then
        local eintraege = {}
            for _, best in ipairs(highscores) do
                table.insert(eintraege, best)   
            end
                TriggerClientEvent('mms-deathmatch:client:ReciveScoreboard', src, eintraege)
            else
                VORPcore.NotifyTip(src, _U('NoHighscoreYet'),  5000)
            end
    end)
end)

function EndDeathmatch()
    DeathmatchStarted = false
    DeathmatchCounter = 0
    for h,v in ipairs(PlayerPeds) do
        SetEntityCoords(v,Config.EndSpawnCoords.x,Config.EndSpawnCoords.y,Config.EndSpawnCoords.z - 0.8,true,true,false,true)
    end
    for _, player in ipairs(GetPlayers()) do
        local RegistredAmount = 0
        TriggerClientEvent('mms-deathmatch:client:AddPlayer', player,RegistredAmount)
    end
    ClearTables()
end

----- Clear Tables
function ClearTables()
    for i, v in ipairs(PlayerPeds) do  -- Tabelle leeren
        PlayerPeds[i] = nil
    end
    for i, v in ipairs(RegistredUsers) do  -- Tabelle leeren
        RegistredUsers[i] = nil
    end
end

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()