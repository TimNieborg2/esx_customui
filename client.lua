ESX = nil

local Job = nil
local PlayerData = nil
Hidden = true

local isTalking = false
local loaded = false

if Config.UseOldESX then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) 
                ESX = obj 
            end)
            Citizen.Wait(0)
        end
    end)
else
    ESX = exports["es_extended"]:getSharedObject()
end

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(500)
	end

	Citizen.Wait(500)
	PlayerData = ESX.GetPlayerData()

	Job = PlayerData.job

	TriggerEvent('es:setMoneyDisplay', 0.0)
	-- ESX.UI.HUD.SetDisplay(0.0)

	local accounts = PlayerData.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "€ "..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "€ "..account.money})
		elseif account.name == "money" then
			SendNUIMessage({action = "setValue", key = "money", value = "€ "..account.money})	
		end
	end

	SendNUIMessage({action = "setValue", key = "job", value = Job.label.." - "..Job.grade_label, icon = Job.name})

	-- Money
	SendNUIMessage({action = "setValue", key = "money", value = "€"..PlayerData.money})
	Citizen.SetTimeout(10000, function()
		loaded = true
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	local accounts = PlayerData.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "€ "..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "€ "..account.money})
		elseif account.name == "money" then
			SendNUIMessage({action = "setValue", key = "money", value = "€ "..account.money})	
		end
	end

	-- Job
	local job = PlayerData.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
	-- Money
	SendNUIMessage({action = "setValue", key = "money", value = "€ "..PlayerData.money})
end)

Citizen.CreateThread(function()
	while (not IsScreenFadedIn() or IsPlayerSwitchInProgress() or GetIsLoadingScreenActive()) and not loaded do
		Citizen.Wait(500)
	end
	SendNUIMessage({action = "startUI"})
	while true do
		Citizen.Wait(250)
		if isTalking == false then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) == false then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "€"..account.money})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "€"..account.money})
	elseif account.name == "money" then
		SendNUIMessage({action = "setValue", key = "money", value = "€"..account.money})	
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	Job = job
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
  SendNUIMessage({action = "setValue2", key = "job2", value = job2.label.." - "..job2.grade_label, icon2 = job2.name})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
	SendNUIMessage({action = "setValue", key = "money", value = "€"..e})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

AddEventHandler('esx_customui:setProximity', function(proximity)
    SendNUIMessage({action = "setProximity", value = proximity})
end)

RegisterNetEvent('esx_customui:updateWeight')
AddEventHandler('esx_customui:updateWeight', function(weight)
	local weightprc = (weight/8000)*100
	SendNUIMessage({action = "updateWeight", weight = weightprc})
end)
