vRP = Proxy.getInterface('vRP')
vRPsaveHoursC = {}
Tunnel.bindInterface('vrp_savehours',vRPsaveHoursC)
Proxy.addInterface('vrp_savehours',vRPsaveHoursC)
vRPsaveHoursS = Tunnel.getInterface('vrp_savehours','vrp_savehours')

Citizen.CreateThread(function()
    while true do
        Wait(15 * 60 * 1000)
        vRPsaveHoursS.updateHoursPlayed({0.25})
    end
end)