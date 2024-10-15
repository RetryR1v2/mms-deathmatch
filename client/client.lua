local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()

local DMBlips = {}
local DMPeds = {}
local RegistredUsers = 0
local EndDeathmatch = false
local ScoreboardOpened = false


Citizen.CreateThread(function()
    local DeathmatchGroup = BccUtils.Prompts:SetupPromptGroup()
    local OpenDeathmatchPrompt = DeathmatchGroup:RegisterPrompt(_U('DeathMatch'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G

        for h,v in pairs(Config.DeathMatch) do
            if v.SpawnBlip then
                local DMBlip = BccUtils.Blips:SetBlip(v.Name, v.BlipSprite, 2.0, v.Coords.x,v.Coords.y,v.Coords.z)
                DMBlips[#DMBlips + 1] = DMBlip
            end
            if v.SpawnPed then
                local DMPed = BccUtils.Ped:Create(v.NPCModel, v.Coords.x,v.Coords.y,v.Coords.z -1, 0, 'world', false)
                DMPeds[#DMPeds + 1] = DMPed
                DMPed:Freeze()
                DMPed:SetHeading(v.Heading)
                DMPed:Invincible()
                SetBlockingOfNonTemporaryEvents(DMPed:GetPed(), true)
            end
        end


    while true do
        Wait(1)
        for h,v in pairs(Config.DeathMatch) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - v.Coords)
            if dist < 3 then
                if Config.RemoveAlertItem then
                    BccUtils.Misc.DrawText3D(v.Coords.x, v.Coords.y, v.Coords.z + 0.15, _U('Carefull') .. Config.ReviveItemLabel)
                elseif Config.ForbitWithAlertItems then
                    BccUtils.Misc.DrawText3D(v.Coords.x, v.Coords.y, v.Coords.z + 0.15,Config.ReviveItemLabel .. _U('CantRegisterWith'))
                end
                BccUtils.Misc.DrawText3D(v.Coords.x, v.Coords.y, v.Coords.z, _U('RegistredUsers') .. RegistredUsers)
                DeathmatchGroup:ShowGroup(_U('OpenBoard'))

                if OpenDeathmatchPrompt:HasCompleted() then
                    DeathmatchBoard:Open({
                    startupPage = DeathmatchBoardPage1,
                    })
                end
            end
        end
    end
end)

----------------- Menu Part ----------------


Citizen.CreateThread(function ()
    DeathmatchBoard = FeatherMenu:RegisterMenu('DeathmatchBoard', {
        top = '20%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '250px'
            }
        },
        draggable = true,
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
    DeathmatchBoardPage1 = DeathmatchBoard:RegisterPage('seite1')
    DeathmatchBoardPage1:RegisterElement('header', {
        value = _U('DeathmatchBoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage1:RegisterElement('button', {
        label =  _U('Register'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        DeathmatchBoard:Close({ 
        })
        Citizen.Wait(250)
        TriggerServerEvent('mms-deathmatch:server:RegisterForEvent')
    end)
    DeathmatchBoardPage1:RegisterElement('button', {
        label =  _U('Leaderboard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
       TriggerServerEvent('mms-deathmatch:server:GetScoreBoard')
    end)
    DeathmatchBoardPage1:RegisterElement('button', {
        label =  _U('CloseDeathmatchBoard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        DeathmatchBoard:Close({ 
        })
    end)
    DeathmatchBoardPage1:RegisterElement('subheader', {
        value = _U('DeathmatchBoardSubHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)

RegisterNetEvent('mms-deathmatch:client:ReciveScoreboard')
AddEventHandler('mms-deathmatch:client:ReciveScoreboard',function(eintraege)
    if not ScoreboardOpened then
    DeathmatchBoardPage2 = DeathmatchBoard:RegisterPage('seite2')
    DeathmatchBoardPage2:RegisterElement('header', {
        value = _U('ScoreBoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage2:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    for _, best in ipairs(eintraege) do
        local buttonLabel = best.firstname ..' '.. best.lastname .. _U('GotKills') .. best.kills .. _U('GotDeaths') .. best.deaths
        DeathmatchBoardPage2:RegisterElement('button', {
            label = buttonLabel,
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            }
        }, function()
            
        end)
    end
    DeathmatchBoardPage2:RegisterElement('button', {
        label =  _U('CloseDeathmatchBoard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        DeathmatchBoard:Close({ 
        })
    end)
    DeathmatchBoardPage2:RegisterElement('subheader', {
        value = _U('DeathmatchBoardSubHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage2:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    ScoreboardOpened = true
    DeathmatchBoardPage2:RouteTo()
    elseif ScoreboardOpened then
    DeathmatchBoardPage2:UnRegister()
    DeathmatchBoardPage2 = DeathmatchBoard:RegisterPage('seite2')
    DeathmatchBoardPage2:RegisterElement('header', {
        value = _U('ScoreBoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage2:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    for _, best in ipairs(eintraege) do
        local buttonLabel = best.firstname ..' '.. best.lastname .. _U('GotKills') .. best.kills .. _U('GotDeaths') .. best.deaths
        DeathmatchBoardPage2:RegisterElement('button', {
            label = buttonLabel,
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            }
        }, function()
            
        end)
    end
    DeathmatchBoardPage2:RegisterElement('button', {
        label =  _U('CloseDeathmatchBoard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        DeathmatchBoard:Close({ 
        })
    end)
    DeathmatchBoardPage2:RegisterElement('subheader', {
        value = _U('DeathmatchBoardSubHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage2:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    DeathmatchBoardPage2:RouteTo()
    end
end)
----------------- Funktionen ---------------

RegisterNetEvent('mms-deathmatch:client:AddPlayer')
AddEventHandler('mms-deathmatch:client:AddPlayer',function (RegistredAmount)
    RegistredUsers = RegistredAmount
end)


RegisterNetEvent('mms-deathmatch:client:EndDeathmatch')
AddEventHandler('mms-deathmatch:client:EndDeathmatch',function()
    Citizen.Wait(250)
    VORPcore.instancePlayers(0)
    EndDeathmatch = true
    Citizen.Wait(1000)
    RegistredUsers = 0
    EndDeathmatch = false
end)


RegisterNetEvent('mms-deathmatch:client:CheckDeath')
AddEventHandler('mms-deathmatch:client:CheckDeath',function(PlayerPed)
    Citizen.Wait(500)
    VORPcore.instancePlayers(Config.RoutingNumber)
    while not EndDeathmatch do
        local MyPlayerPedId = PlayerPedId()
        Citizen.Wait(500)
        local IsDead = IsEntityDead(MyPlayerPedId)
        local Dead = IsPedDeadOrDying(MyPlayerPedId, false)
        if Dead and IsDead then
            local getKillerPed = GetPedSourceOfDeath(PlayerPedId())
            local killerServerId = 0
                if IsPedAPlayer(getKillerPed) then
                    local killer = NetworkGetPlayerIndexFromPed(getKillerPed)
                    if killer then
                        killerServerId = GetPlayerServerId(killer)
                    end
                end

            print('Ich Bin Tot')
                --local deathCause = GetPedCauseOfDeath(PlayerPedId())  -- Check Wich gun Not needed 
            Citizen.Wait(8000)
            print('Jetzt Wiederbeleben und Tot / Kill Werten')
            TriggerServerEvent('mms-deathmatch:server:IDied',PlayerPed,killerServerId)
            TriggerServerEvent('mms-deathmatch:server:Respawn',PlayerPed)
        end
    end
end)

----------------- Utilities -----------------


------ Progressbar

function Progressbar(Time)
    progressbar.start(_U('SearchingBinProgressbar'), Time, function ()
    end, 'linear')
    Wait(Time)
    ClearPedTasks(PlayerPedId())
end

------ Animation

function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

------------------------- Clean Up on Resource Restart -----------------------------

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
        for _, dmpeds in ipairs(DMPeds) do
            dmpeds:Remove()
	    end
        for _, dmblips in ipairs(DMBlips) do
            dmblips:Remove()
	    end
        VORPcore.instancePlayers(0)
    end
end)