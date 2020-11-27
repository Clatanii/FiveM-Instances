-- LOCAL VARS
local sync_table = {}

-- EVENTS
RegisterNetEvent('WOSA:INSTANCES:UPDATE')
AddEventHandler('WOSA:INSTANCES:UPDATE', function(player, data)
	sync_table[player] = data
	TriggerClientEvent('WOSA:INSTANCES:UPDATE', -1, player, data, source)
end)

RegisterNetEvent('WOSA:INSTANCES:GET_ALL')
AddEventHandler('WOSA:INSTANCES:GET_ALL', function()
	TriggerClientEvent('WOSA:INSTANCES:GET_ALL', source, sync_table)
end)