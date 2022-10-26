local QBCore = exports['qb-core']:GetCoreObject()
local MaxPools = { -- Contains all the the amount of contracts avaible every restart, once a contract has started or declined it gets back into the pool
    ["D"] = 25,
    ["C"] = 20,
    ["B"] = 15,
    ["A"] = 10,
    ["A+"] = 5,
    ["S"] = 3,
    ["S+"] = 1,
}

local cars = {
    ["D"] = 
    {'virgo3',
    'pigalle',
    'tornado5',
    'peyote3',
    'manana2',
    'dilettante',
    'hustler',
    'dynasty',
    'hermes',
    'sandking',
    'sandking2',
    'gburrito2',
    'rancherxl',
    'kalahari',
    'speedo',
    'minivan',
    'romero',
    'asea',
    'youga3'},
    ["C"] = 
    {'ztype',
    'btype3',
    'hotknife',
    'faction3',
    'issi3',
    'fagaloa',
    'glendale',
    'riata',
    'rebel2',
    'kamacho',
    'freecrawler',
    'dubsta3',
    'hoabrawler',
    'brawler',
    'comet4',
    'mesa3',
    'streiter',
    'seminole',
    'radi',
    'patriot',
    'landstalker',
    'granger',
    'fq2',
    'baller2',
    'rhapsody',
    'issi2',
    'washington',
    'warrener',
    'stanier',
    'primo2',
    'ingot',
    'blista2',
    'landstalker2',
    'yosemite3',
    'asterope'},
    ["B"] = 
    { 'rapidgt3',
    'viseris',
    'swinger',
    'stingergt',
    'mamba',
    'gt500',
    'coquette3',
    'feltzer3',
    'vigero',
    'sabregt2',
    'picador',
    'phoenix',
    'nightshade',
    'faction2',
    'clique',
    'cheburek',
    'slamvan2',
    'trophytruck2',
    'hellion6str',
    'everon',
    'retinue2',
    'gb200',
    'tropos',
    'flashgt',
    'issi7',
    'minivan2',
    'serrano',
    'dubsta2',
    'baller3',
    'novak',
    'rebla',
    'surge',
    'raiden',
    'felon',
    'oracle2',
    'jackal',
    'exemplar',
    'tailgater',
    'stratum',
    'premier',
    'intruder',
    'fugitive',
    'cog55',
    'sentinel3',
    'schafter4',
    'revolter',
    'sultan2',
    'kuruma',
    'futo',
    'fusilade',
    'buffalo2',
    'zion3',
    'savestra',
    'prairie',
    'sugoi',
    'blista',
    'vstr',
    'komoda',
    'club'},
    ["A"] = 
    {'italigto',
    'tornado6',
    'tampa',
    'sabregt',
    'ruiner',
    'ellie',
    'stafford',
    'gauntlet',
    'paragon',
    'zion2',
    'zion',
    'felon2',
    'cogcabrio',
    'z190',
    'schwarzer',
    'penumbra',
    'jugular',
    'kanjo',
    'alpha',
    'primoard',
    'toros'},
    ["A+"] = {'dominator3',
    'dominator',
    'voltic',
    'f620',
    'surano',
    'specter2',
    'rapidgt2',
    'seven70',
    'pariah',
    'massacro',
    'lynx',
    'jester',
    'furoregt',
    'feltzer2',
    'elegy2',
    'comet5',
    'comet2',
    'carbonizzare',
    'bestiagts',
    'drafter',
    'ninef2',
    'ninef',
    'coquette',
    'sentinelsg4',
    'banshee',
    'penumbra2',
    'turismor',
    'adder',
    'zentorno'},
    ["S"] = 
    {'deviant',
    'torero',
    'monroe',
    'cheetah2',
    'sultanrs'},
    ["S+"] = 
    {'gauntlet4',
    'furia',
    'elegy',
    'banshee2',
    'turismo2'},
}


-- CreateThread(function()
--     while not QBCore do Wait(250) end

--     for k, v in pairs(QBCore.Shared.Vehicles) do
--         if v['tier'] and cars[v['tier']] then
--             cars[v['tier']][#cars[v['tier']]+1] = k
--         end
--     end
-- end)

local currentRuns = {}
local ActivePlates = {} -- Handle all the active plates and syncs all the data shit
local currentContracts = {}
local LookingForContracts = {}




local function Notify(src, text, type, time)
    if Config.Boosting.Notifications == "phone" then
        TriggerClientEvent("qb-phone:client:CustomNotification", src,
            Lang:t('boosting.info.phonenotify'),
            text,
            "fas fa-user-secret",
            "#00008B",
            time
        )
    else
        TriggerClientEvent('QBCore:Notify', src, text, type, time)
    end
end





-- ** EVERYTHING TO DO WITH DROP OFFS AND VINSCRATCH ** --
local function ResetAnotherShit(Tier)
    SetTimeout(5 * 60000, function()
        Config.Boosting.ReturnLocation[Tier].isBusy = false
    end)
end

local function GetRandomDropOff()
    local Locations = {}
    for i = 1, #Config.Boosting.ReturnLocation do
        if not Config.Boosting.ReturnLocation[i].isBusy then
            Locations[#Locations+1] = i
        end
    end
    local location = Locations[math.random(1, #Locations)]
    return Config.Boosting.ReturnLocation[Locations[location]].coords, location
end

RegisterNetEvent('jl-laptop:server:FinalDestination', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CID = Player.PlayerData.citizenid
    if currentRuns[CID] and not currentRuns[CID].dropOff and currentRuns[CID].type == "boosting" then
        local place, id = GetRandomDropOff()

        TriggerClientEvent('jl-laptop:client:ReturnCar', src, place)
        ResetAnotherShit(id)
    elseif currentRuns[CID] and not currentRuns[CID].dropOff and currentRuns[CID].type == "vinscratch" then
        --NOT YET DONE
    end
end)












-- EVERYTHING TO DO WITH STARTING THE BOOST --

local function GeneratePlate() -- Just makes sure we generate plates noone owns.
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result or ActivePlates[plate] then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function SpawnCar(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local CID = Player.PlayerData.citizenid
    local carModel = currentRuns[CID].car:lower()
    local coords = currentRuns[CID].Location.carCoords

    local CreateAutomobile = joaat('CREATE_AUTOMOBILE')
    local car = Citizen.InvokeNative(CreateAutomobile, joaat(carModel), coords, true, false)

    local Checks = 0

    while not DoesEntityExist(car) do
        if Checks == 10 then break end -- Incase the above native dosnt work this will then reset the contracts
        Wait(25)
        Checks += 1
    end

    if DoesEntityExist(car) then
        SetVehicleDoorsLocked(car, 2)

        local plate = GeneratePlate()
        -- ActivePlates[plate] = math.random(3, 10)
        ActivePlates[plate] = math.random(Config.Boosting.Hacks[currentRuns[CID].contract].min, Config.Boosting.Hacks[currentRuns[CID].contract].max)

        -- print(currentRuns[CID].contract)

        SetVehicleNumberPlateText(car, plate)
        currentRuns[CID].NetID = NetworkGetNetworkIdFromEntity(car)


        TriggerClientEvent('jl-laptop:client:SyncPlates', -1, ActivePlates)
        TriggerClientEvent('jl-laptop:client:MissionStarted', src, currentRuns[CID].NetID, coords, plate)

        return true
    else
        return false
    end
end

local function GerRandomLocation(Tier)
    local Locations = {}
    for i = 1, #Config.Boosting.Locations[Tier] do
        if not Config.Boosting.Locations[Tier][i].isBusy then
            Locations[#Locations+1] = i
        end
    end
    if Locations == 0 then return false, false end
    local location = Locations[math.random(1, #Locations)]
    Config.Boosting.Locations[Tier][location].isBusy = true
    return Config.Boosting.Locations[Tier][location], location
end

local function ResetShit(Tier, location)
    SetTimeout(5 * 60000, function()
        Config.Boosting.Locations[Tier][location].isBusy = false
    end)
end


QBCore.Functions.CreateCallback('jl-laptop:server:CanStartBoosting', function(source, cb, cops, id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return cb("error") end

    local CID = Player.PlayerData.citizenid

    if currentRuns[CID] then return cb("running") end
    if not currentContracts[CID][id] then return cb("notfound") end
    if Config.RenewedPhone and not exports['qb-phone']:hasEnough(src, "gne", currentContracts[CID][id].cost) then
        return cb("notenough")
    elseif Player.PlayerData.money.crypto < currentContracts[CID][id].cost then
        return cb("notenough")
    end
    local amount = 0
    if cops == Config.Boosting.MinCops then
        amount = 1
    elseif cops > Config.Boosting.MinCops then
        amount = math.floor(cops / Config.Boosting.MinCops)
    end

    if amount < 1 or #currentRuns >= amount then return cb("cops") end

    local location, place = GerRandomLocation(currentContracts[CID][id].contract)
    if location then
        currentRuns[CID] = {
            Location = location,
            type = currentContracts[CID][id].type,
            car = currentContracts[CID][id].car,
            contract = currentContracts[CID][id].contract,
            cost = currentContracts[CID][id].cost,
            dropOff = nil,
            Plate = nil,
            NetID = nil,
            PedSpawned = false,
        }

        if SpawnCar(src) then

            if Config.RenewedPhone then
                exports['qb-phone']:RemoveCrypto(src, "gne", currentContracts[CID][id].cost)
            else
              	if not Player.Functions.RemoveMoney("crypto", currentContracts[CID][id].cost, Lang:t('boosting.info.bought_boost')) then
                    cb("busy")
                    return
                end
            end


            MaxPools[currentContracts[CID][id].contract] += 1
            ResetShit(currentContracts[CID][id].contract, place)
            table.remove(currentContracts[CID], id) -- has to be table.remove for some dumb ass reason
            TriggerClientEvent('jl-laptop:client:ContractHandler', src, currentContracts[CID])

            cb("success")
        else
            currentRuns[CID] = nil
        end
    else
        cb("busy")
    end

end)









-- EVERYTHING TO DO WITH PEDS SPAWNING --
local function DeletePeds(netIds)
    SetTimeout(2.5 * 60000, function()
        for i = 1, #netIds do
            if DoesEntityExist(NetworkGetEntityFromNetworkId(netIds[i])) then
                DeleteEntity(NetworkGetEntityFromNetworkId(netIds[i]))
            end
        end
    end)
end

RegisterNetEvent('jl-laptop:server:SpawnPed', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CID = Player.PlayerData.citizenid
    if currentRuns[CID].PedSpawned then return end
    currentRuns[CID].PedSpawned = true
    local netIds = {}
    for k, v in pairs(currentRuns[CID].Location.peds) do
        local netId
        local pedstuff = CreatePed(30, joaat(v.model), v.coords, true, false)
        while not DoesEntityExist(pedstuff) do Wait(25) end
        netId = NetworkGetNetworkIdFromEntity(pedstuff)
        netIds[k] = netId
    end

    Wait(300)

    TriggerClientEvent('jl-laptop:client:SpawnPeds', src, netIds, currentRuns[CID].Location)
    DeletePeds(netIds)
end)










-- EVERYTHING TO DO WITH BLIPS SYNCING AND CAR HACKING --
RegisterNetEvent('jl-laptop:server:SyncBlips', function(coords, plate)
    if ActivePlates[plate] > 0 then
        TriggerClientEvent('jl-laptop:client:SyncBlips', -1, coords, plate)
    end
end)

-- ** Hacking Cars ** --
local Cooldowns = {}

local function removeCooldown(plate, time)
    SetTimeout(time * 1000, function()
        Cooldowns[plate] = false
    end)
end

RegisterNetEvent('jl-laptop:server:SyncPlates', function(success, time)
    local src = source

    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end
    if not Player.Functions.GetItemByName(Config.Boosting.HackingDevice) then return end


    local ped = GetPlayerPed(src)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(ped, false))

    if Cooldowns and Cooldowns[plate] then return end

    Cooldowns[plate] = true

    if ActivePlates[plate] and ActivePlates[plate] >= 1 and success then
        if Config.Boosting.Debug then
            ActivePlates[plate] = 0
        else
            ActivePlates[plate] -= 1
        end
        TriggerClientEvent('jl-laptop:client:SyncPlates', -1, ActivePlates)
    end

    if not Config.Boosting.Debug then removeCooldown(plate, time) else Cooldowns[plate] = false end
end)

QBCore.Functions.CreateUseableItem(Config.Boosting.HackingDevice, function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(Config.Boosting.HackingDevice) then
        TriggerClientEvent('jl-laptop:client:HackCar', source)
    end
end)





----- ** EVERYTHING TO DO QUEUE ** -----

QBCore.Functions.CreateCallback('jl-laptop:server:joinQueue', function(source, cb, status)
    print(status)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return cb("error") end
    if not HasAppAccess(src, "boosting") then return cb("error") end
    local CID = Player.PlayerData.citizenid
    if status then
        if LookingForContracts[CID] and LookingForContracts[CID].active and LookingForContracts[CID].online and LookingForContracts[CID].src == src then return cb("inqueue") end
        if currentRuns[CID] then return cb("running") end
        if not LookingForContracts[CID] then LookingForContracts[CID] = {} end
        if not currentContracts[CID] then currentContracts[CID] = {} end
        if LookingForContracts[CID] and LookingForContracts[CID].skipped then
            LookingForContracts[CID] = {
                src = src,
                skipped = LookingForContracts[CID].skipped,
                online = true,
                active = true
            }
        else
            LookingForContracts[CID] = {
                src = src,
                online = true,
                skipped = 0,
                active = true
            }
        end
        cb("success")
    else
        if not LookingForContracts[CID] then return cb("error") end
        LookingForContracts[CID].active = false
        LookingForContracts[CID].online = true
        cb("success")
    end

    if LookingForContracts[CID].online then
        TriggerClientEvent('jl-laptop:client:QueueHandler', src, LookingForContracts[CID].active)
    end
end)


RegisterNetEvent('jl-laptop:server:QuitQueue', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local CID = Player.PlayerData.citizenid
    if not LookingForContracts[CID] or not LookingForContracts[CID].skipped then return end
    LookingForContracts[CID].active = false

    if LookingForContracts[CID].online then
        TriggerClientEvent('jl-laptop:client:QueueHandler', src, LookingForContracts[CID].active)
    end
end)















-- ** EVERYTHING TO DO WITH REWARDS ** --

RegisterNetEvent('jl-laptop:server:finishBoost', function(netId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CID = Player.PlayerData.citizenid

    if not currentRuns[CID] then return end
    if not (currentRuns[CID].NetID == netId) then return end

    local boostData = Player.PlayerData.metadata["carboostrep"] or 0
    boostData += math.random(Config.Boosting.MetaReward[currentRuns[CID].contract].min , Config.Boosting.MetaReward[currentRuns[CID].contract].max)
    Player.Functions.SetMetaData('carboostrep', boostData)

    if currentRuns[CID].cost == 0 then
        currentRuns[CID].cost = math.random(1,2) -- makes it so they can actually get GNE when the boost is Free
    end

    local reward = math.ceil(currentRuns[CID].cost * math.random(2,3))
    if Config.RenewedPhone then
        exports['qb-phone']:AddCrypto(src, "gne", reward)
    else
        Player.Functions.AddMoney("crypto", reward, Lang:t('boosting.info.rewardboost'))
    end
    Notify(src, Lang:t('boosting.success.received_reward', {reward = reward}), "success", 7500)


    if DoesEntityExist(NetworkGetEntityFromNetworkId(currentRuns[CID].NetID)) then
        DeleteEntity(NetworkGetEntityFromNetworkId(currentRuns[CID].NetID))
    end
    currentRuns[CID] = nil
    TriggerClientEvent('jl-laptop:client:finishContract', src, currentContracts[CID])
end)







-- ** EVERYTHING TO DO WITH CANCELLING ** --
RegisterNetEvent('jl-laptop:server:CancelBoost', function(netId, Plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CID = Player.PlayerData.citizenid
    if not currentRuns[CID] then return end
    if not (currentRuns[CID].NetID == netId) then return end

    if DoesEntityExist(NetworkGetEntityFromNetworkId(currentRuns[CID].NetID)) then return end

    ActivePlates[Plate] = 0
    currentRuns[CID] = nil
    TriggerClientEvent('jl-laptop:client:SyncPlates', -1, ActivePlates)
    TriggerClientEvent('jl-laptop:client:finishContract', src, currentContracts[CID])

    Notify(src, Lang:t('boosting.error.cancelboost'), "error", 7500)
end)









-- ** CONTRACTS ** --
RegisterNetEvent('jl-laptop:server:DeclineBoost', function(contract)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local CID = Player.PlayerData.citizenid
    if not currentContracts[CID] then return end
    if not currentContracts[CID][contract] then return end

    MaxPools[currentContracts[CID][contract].contract] += 1
    table.remove(currentContracts[CID], contract)
end)

QBCore.Functions.CreateCallback('jl-laptop:server:DeclineContract', function(source, cb, contract)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return cb("error") end

    if not contract then return cb("error") end
    local CID = Player.PlayerData.citizenid
    if not currentContracts[CID] then return cb("error") end
    if not currentContracts[CID][contract] then return cb("error") end

    MaxPools[currentContracts[CID][contract].contract] += 1
    table.remove(currentContracts[CID], contract)

    TriggerClientEvent('jl-laptop:client:ContractHandler', src, currentContracts[CID])
    cb("success")
end)






-- ** TRANSFER BOOSTS ** --

QBCore.Functions.CreateCallback('jl-laptop:server:TransferContracts', function(source, cb, playerID, contractID)
    local src = source

    if src == tonumber(playerID) then return cb("self") end

    if not HasAppAccess(src, "boosting") then return cb("error") end

    if not playerID or not contractID then return cb("notfound") end

    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb("error") end

    local CID = Player.PlayerData.citizenid
    local Contract = currentContracts[CID][contractID]
    if not Contract then return cb("error") end

    local Reciever = QBCore.Functions.GetPlayer(tonumber(playerID))
    if not Reciever then return cb("notfound") end
    local RecieveCID = Reciever.PlayerData.citizenid
    print(RecieveCID, Reciever.PlayerData.source)
    if not currentContracts[RecieveCID] then currentContracts[RecieveCID] = {} end
    if #currentContracts[RecieveCID]+1 > Config.Boosting.MaxBoosts then return cb("full") end

    -- refreshes the contracts for the source --
    table.remove(currentContracts[CID], contractID) -- has to be table.remove for some dumb ass reason
    TriggerClientEvent('jl-laptop:client:ContractHandler', src, currentContracts[CID])
    -- refreshes the contracts for the reciever --
    currentContracts[RecieveCID][#currentContracts[RecieveCID]+1] = Contract
    TriggerClientEvent('jl-laptop:client:ContractHandler', Reciever.PlayerData.source, currentContracts[RecieveCID])
    cb("success")
end)








QBCore.Functions.CreateCallback('jl-laptop:server:GetContracts', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CID = Player.PlayerData.citizenid
    if not currentContracts[CID] then currentContracts[CID] = {} end

    cb(currentContracts[CID], ActivePlates)
end)










-- ** EVERYTHING TO DO WITH GENERATING CONTRACTS ** --

local function generateTier(src)
    local chance = math.random(1,100)
    local Player = QBCore.Functions.GetPlayer(src)
    local boostData = Player.PlayerData.metadata["carboostrep"] or 0
    local tier

    -- We should also get their current metadata and based on their metadata increase this luck or even cap it so they cant get s+ if they just startedt/
    if chance >= 99 then -- 2%
        if boostData >= Config.Boosting.TiersPerRep["S"] then -- You can jump 1 tier above the current tier you are at so someone at D can't get a S+ Contract
            tier = "S+"
        else
            generateTier(src)
        end
    elseif chance >= 95 then -- 3%
        if boostData >= Config.Boosting.TiersPerRep["A+"] then -- You can jump 1 tier above the current tier you are at so someone at D can't get a S+ Contract
            tier = "S"
        else
            generateTier(src)
        end

    elseif chance >= 90 then -- 5%
        if boostData >= Config.Boosting.TiersPerRep["A"] then -- You can jump 1 tier above the current tier you are at so someone at D can't get a S+ Contract
            tier = "A+"
        else
            generateTier(src)
        end

    elseif chance >= 80 then -- 10%
        if boostData >= Config.Boosting.TiersPerRep["B"] then -- You can jump 1 tier above the current tier you are at so someone at D can't get a S+ Contract
            tier = "A"
        else
            generateTier(src)
        end

    elseif chance >= 60 then -- 20%
        if boostData >= Config.Boosting.TiersPerRep["C"] then -- You can jump 1 tier above the current tier you are at so someone at D can't get a S+ Contract
            tier = "B"
        else
            generateTier(src)
        end
    elseif chance >= 35 then -- 25%
        if boostData >= Config.Boosting.TiersPerRep["D"] then -- You can jump 1 tier above the current tier you are at so someone at D can't get a S+ Contract
            tier = "C"
        else
            generateTier(src)
        end
    else -- 35%
        tier = "D"
    end

    Wait(0)

    if not tier then return generateTier(src) end

    if MaxPools[tier] and MaxPools[tier] > 0 then
        MaxPools[tier] -= 1
        return tier
    else
        return nil
    end
end

local function generateCar(tier)
    if not cars[tier] or (cars[tier] and #cars[tier] < 1) then return nil end
    return cars[tier][math.random(1, #cars[tier])]
end

local function missionType(Player, tier)
    local boostData = Player.PlayerData.metadata["carboostrep"] or 0

    if not boostData then return end

    if tier == "D" or tier == "C" or tier == "B" or tier == "A" then return "boosting" end -- Only A+, S and S+ Can be vinscratched

    print(boostData, tier, Config.Boosting.TiersPerRep[tier])
    if boostData >= Config.Boosting.TiersPerRep[tier] then
        if math.random() <= 0.05 then
            return "vinscratch"
        end
    else
        return "boosting"
    end
end

function GetHoursFromNow(hours)
    if Config.Linux then
        return os.date("!%Y-%m-%dT%TZ", os.time() + hours * 60 * 60)
    else
        return os.date("!%Y-%m-%dT%SZ", os.time() + hours * 60 * 60)
    end
end

function GetCurrentTime()
    if Config.Linux then
        return os.date("!%Y-%m-%dT%TZ", os.time())
    else
        return os.date("!%Y-%m-%dT%SZ", os.time())
    end

end

QBCore.Functions.CreateCallback("jl-laptop:server:getCurrentTime", function (cb)
    cb({
        GetCurrentTime()
    })
end)

local function generateName()
    return Config.Boosting.RandomNames[math.random(1, #Config.Boosting.RandomNames)]
end

local function calcPrice(tier, type)
    if not tier or not type then return end
    local price = math.random(Config.Boosting.Price[tier].min, Config.Boosting.Price[tier].max)
    if type == "boosting" then price = price else price = price * math.random(2,5) end
    return Config.Boosting.Debug and price or 0
end

local function generateContract(src, contract, vehicle, mission)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local CID = Player.PlayerData.citizenid
    if not currentContracts[CID] then currentContracts[CID] = {} end

    contract = contract or generateTier(src)
    vehicle = vehicle or generateCar(contract)
    print(contract, vehicle)
    mission = mission or missionType(Player, contract)
    print(mission)
    print(calcPrice(contract, mission))
    print(GetHoursFromNow(6))

    if contract and vehicle and mission then
        currentContracts[CID][#currentContracts[CID]+1] = {
            id = #currentContracts[CID]+1,
            contract = contract,
            car = vehicle,
            carName = QBCore.Shared.Vehicles[vehicle]["name"],
            expire = GetHoursFromNow(6),
            owner = generateName(),
            type = mission,
            cost = calcPrice(contract, mission),
        }
        LookingForContracts[CID].skipped = 0
        TriggerClientEvent('jl-laptop:client:ContractHandler', src, currentContracts[CID], GetCurrentTime())
    else
        LookingForContracts[CID].skipped += 1
    end
end

-- QUEUE LOOP --
CreateThread(function()
    while true do
        if LookingForContracts then
            for k, v in pairs(LookingForContracts) do
                if currentContracts[k] then
                    if #currentContracts[k] < Config.Boosting.MaxBoosts and v.active and v.online then
                        local ContractChance = math.random()
                        print(v.skipped)
                        -- If skipped is bigger or equal to 25 we give player a contract for waiting
                        -- Otherwise we say if they been in queue longer than 2-7 skips and their chance is higher than 0.75 (meaning 25% chance) we will reward them with a contract
                        if v.skipped >= 25 or (v.skipped >= math.random(2, 7) and ContractChance >= 0.75) then
                            generateContract(v.src)
                        else
                            v.skipped += 1
                        end
                    elseif #currentContracts[k] >= Config.Boosting.MaxBoosts then
                        v.active = false
                        if v.online then
                            TriggerClientEvent('jl-laptop:client:QueueHandler', v.src, false)
                        end
                    end
                elseif not currentContracts[k] then
                    currentContracts[k] = {}
                end
            end
        end
        -- Wait(Config.Boosting.Debug and 200 or (math.random(1, 4) * 60000 )) -- Once every 1 to 4 minutes
        Wait(1000)
    end
end)


-- Player dropped functions --
local function GetCID(src)
    if LookingForContracts then
        for k, v in pairs(LookingForContracts) do
            if v.src == src then
                return k
            end
        end
    end
end

AddEventHandler('playerDropped', function()
	local src = source
    local CID = GetCID(src)
    if not CID then return end
    LookingForContracts[CID].active = false
    LookingForContracts[CID].online = false

    if currentRuns[CID] then
        currentRuns[CID] = nil
    end
end)

-- Commands --
QBCore.Commands.Add('giveboost', Lang:t('boosting.command.command_desc'), {{ name = Lang:t('boosting.command.command_name_ID'), help = Lang:t('boosting.command.command_help_ID')}, { name = Lang:t('boosting.command.command_name_tier'), help = Lang:t('boosting.command.command_help_tier')}, { name = Lang:t('boosting.command.command_name_vehicle'), help = Lang:t('boosting.command.command_help_vehicle')}, { name = 'Type', help = 'boosting/vinscratch'}, }, false, function(source, args)
    if args and type(tonumber(args[1])) == "number" then
        local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
        if Player then
            local CID = Player.PlayerData.citizenid
            if LookingForContracts[CID] then
                if args[4] and not (args[4] == 'boosting' or args[4] == 'vinscratch') then
                    TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.incorrect_type'), 'error', 7500)
                elseif args[3] and not type(args[3]) == "string" then
                    TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.incorrect_vehicle'), 'error', 7500)
                elseif args[2] and not (args[2] == "D" or args[2] == "C" or args[2] == "B" or args[2] == "A" or args[2] == "A+" or args[2] == "S" or args[2] == "S+") then
                    TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.incorrect_tier'), 'error', 7500)
                else
                    generateContract(tonumber(args[1]), args[2], args[3], args[4])
                    TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.created'), 'success', 7500)
                end
            else
                TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.not_inqueue'), 'error', 5000)
            end
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.player_offline'), 'error', 5000)
        end
    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.incorrect_format'), "error", 5000)
    end
end, "god")

QBCore.Commands.Add('settier', Lang:t('boosting.command.command_tier_desc'), {{ name = Lang:t('boosting.command.command_name_ID'), help = Lang:t('boosting.command.command_help_ID')}, { name = Lang:t('boosting.command.command_name_tier'), help = Lang:t('boosting.command.command_help_tier')} }, false, function(source, args)
    if args and type(tonumber(args[1])) == "number" then
         if args[2] and type(args[2]) == "string" then
            local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if Player then
                local rep = Player.PlayerData.metadata["carboostrep"] or 0
                rep = Config.Boosting.TiersPerRep[args[2]]
                Player.Functions.SetMetaData('carboostrep', rep)
            else
                TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.player_offline'), 'error', 5000)
            end
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.missingarg'), "error", 5000)
        end
    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t('boosting.command.incorrect_format'), "error", 5000)
    end
end, "god")
