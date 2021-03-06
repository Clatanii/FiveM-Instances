-- VARIABLES & TABLES
local INSTANCE = {}
local synced_table = {}

-- EVENTS
RegisterNetEvent('WOSA:INSTANCES:UPDATE')
AddEventHandler('WOSA:INSTANCES:UPDATE', function(player, data, sender)
	if sender ~= GetPlayerServerId(PlayerId()) then
		synced_table[player] = data
	end
end)

RegisterNetEvent('WOSA:INSTANCES:GET_ALL')
AddEventHandler('WOSA:INSTANCES:GET_ALL', function(data)
	synced_table = data
end)

-- FUNCTIONS FOR PED
function INSTANCE.GET(player)
	return synced_table[player] or 0
end

function INSTANCE.SET(player, ID)
	synced_table[player] = ID
	TriggerServerEvent('WOSA:INSTANCES:UPDATE', player, synced_table[player])
end

function INSTANCE.CLEAR(player)
	synced_table[player] = 0
	TriggerServerEvent('WOSA:INSTANCES:UPDATE', player, 0)

	for _, player in ipairs(GetActivePlayers()) do
		if player ~= PlayerId() then
			NetworkConcealPlayer(player, false)
		end
	end
end

-- MAIN LOOP
CreateThread(function()
	TriggerServerEvent('WOSA:INSTANCES:GET_ALL')
	Wait(500)
	INSTANCE.SET(PlayerId(), 0)

	while true do Wait(500)
		for _, player in ipairs(GetActivePlayers()) do
			if player ~= PlayerId() then
				if INSTANCE.GET(player) ~= INSTANCE.GET(PlayerId()) then
					NetworkConcealPlayer(player, true)
				else
					if NetworkIsPlayerConcealed(player) then
						NetworkConcealPlayer(player, false)
					end
				end
			end
		end
	end
end)
