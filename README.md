# FiveM UI Hud (esx_customui)

Fivem UI Hud is a public released ESX based UI hud. You may edit & change the UI to your liking.

# Requirements:

● [es_extended](https://github.com/esx-framework/esx_core/tree/main/%5Bcore%5D/es_extended)

● [esx_status](https://github.com/esx-framework/esx_status)

● [esx_basicneeds](https://github.com/mitlight/esx_basicneeds)

# Download & Installation

## Dowload

1. Download the .zip.
2. Extract the .zip or open the .zip.
3. Place the esx_customui in your ESX directory.
4. Add **ensure esx_customui** to your server.cfg.

## Installation

● Add TriggerEvent in (resources[esx]\esx_status\client\main.lua **esx_status:load**)

    TriggerEvent('esx_customui:updateStatus', GetStatusData(true))

To look like this

    RegisterNetEvent('esx_status:load')
    AddEventHandler('esx_status:load', function(status)

    for i=1, #Status, 1 do
    	for j=1, #status, 1 do
    		if Status[i].name == status[j].name then
    			Status[i].set(status[j].val)
    		end
    	end
    end

    Citizen.CreateThread(function()
      while true do

      	for i=1, #Status, 1 do
      		Status[i].onTick()
      	end

    		SendNUIMessage({
    			update = true,
    			status = GetStatusData()
    		})

    	TriggerEvent('esx_customui:updateStatus', GetStatusData(true))
        Citizen.Wait(Config.TickTime)
      end
    end)
    end)

● Disabling basic needs bar (resources[ESX]\esx_basicneeds\client\main.lua **esx_status:loaded**)

    AddEventHandler('esx_status:loaded', function(status)

    TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#FFFF00', -- amarelo
    --TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', -- GOLD
    	function(status)
    		return false -- Change to true to show hunger bar | false to hide hunger bar
    	end, function(status)
    		status.remove(100)
    	end
    )

    TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0099FF', -- azul
    --TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', -- CYAN
    	function(status)
    		return false -- Change to true to show thirst bar | false to hide thirst bar
    	end, function(status)
    		status.remove(75)
    	end
    )

● Disabling optional needs bar (resources[ESX]\esx_optionalneeds\client\main.lua **esx_status:loaded**)

    AddEventHandler('esx_status:loaded', function(status)

    TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5',
        function(status)
        if status.val > 0 then
            return false -- Set to true to show if you drink | false to always hide
        else
            return false -- Set to true to always   show | false to hide if 0
            end
        end,
        function(status)
            status.remove(1500)
        end
    )
