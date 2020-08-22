local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_jornal",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(bonus)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        randmoney = (math.random(270,350)+bonus)
	    vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
	end
end