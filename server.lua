local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local MySQL = module('vrp_mysql', 'MySQL')

vRPsaveHoursS = {}
Tunnel.bindInterface('vrp_savehours',vRPsaveHoursS)
Proxy.addInterface('vrp_savehours',vRPsaveHoursS)
vRPsaveHoursC = Tunnel.getInterface('vrp_savehours','vrp_savehours')

vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP','vrp_savehours')

MySQL.createCommand('vRP/get_vrp_users_info','SELECT * FROM vrp_users WHERE id = @user_id')
MySQL.createCommand('vRP/update_hours_played','UPDATE vrp_users SET hoursPlayed = hoursPlayed + @hours WHERE id = @user_id')
MySQL.createCommand('vRP/saveh_column', 'ALTER TABLE vrp_users ADD IF NOT EXISTS hoursPlayed FLOAT NOT NULL DEFAULT 0')
MySQL.query('vRP/saveh_column')

hoursPlayed = {}

function vRP.getUserHoursPlayed(user_id)
	if hoursPlayed[user_id] ~= nil then
		return math.floor(hoursPlayed[user_id])
	else
		return 0
	end
end

function vRPsaveHoursS.updateHoursPlayed(hours)
  user_id = vRP.getUserId({source})
  MySQL.execute('vRP/update_hours_played', {hours = hours, user_id = user_id})
  hoursPlayed[user_id] = hoursPlayed[user_id] + hours
end

AddEventHandler('vRP:playerSpawn',function(user_id, source, first_spawn)
  if first_spawn then
    MySQL.query('vRP/get_vrp_users_info', {user_id = user_id}, function(rows, affected) hoursPlayed[user_id] = tonumber(rows[1].hoursPlayed) end)
  end
end)