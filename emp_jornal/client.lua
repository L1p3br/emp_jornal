local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_jornal")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local bonus = 50

local coordenadas = {
	{ ['id'] = 1, ['x'] = -1041.52, ['y'] = -241.42, ['z'] = 37.84 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregas = {
	[1] =  { ['x'] = -1889.75, ['y'] = 177.60, ['z'] =  81.43 },
	[2] =  { ['x'] = -1920.98, ['y'] = 220.31, ['z'] =  83.98 },
	[3] =  { ['x'] = -1953.67, ['y'] = 307.36, ['z'] =  88.22 },
	[4] =  { ['x'] = -1958.66, ['y'] = 345.61, ['z'] =  90.04 },
	[5] =  { ['x'] = -1961.29, ['y'] = 400.03, ['z'] =  95.63 },
	[6] =  { ['x'] = -1974.45, ['y'] = 456.78, ['z'] = 101.20 },
	[7] =  { ['x'] = -1962.33, ['y'] = 551.05, ['z'] = 112.47 },
	[8] =  { ['x'] = -1939.93, ['y'] = 597.99, ['z'] = 119.94 },
	[9] =  { ['x'] = -1902.24, ['y'] = 682.43, ['z'] = 126.42 },
	[10] = { ['x'] = -1962.14, ['y'] = 616.85, ['z'] = 120.47 },
	[11] = { ['x'] = -1972.17, ['y'] = 583.38, ['z'] = 116.90 },
	[12] = { ['x'] = -1993.72, ['y'] = 481.47, ['z'] = 103.77 },
	[13] = { ['x'] = -1990.54, ['y'] = 458.28, ['z'] = 101.70 },
	[14] = { ['x'] = -2001.18, ['y'] = 366.37, ['z'] =  93.99 },
	[15] = { ['x'] = -1964.18, ['y'] = 293.78, ['z'] =  87.42 },
	[16] = { ['x'] = -1953.34, ['y'] = 251.98, ['z'] =  84.53 },
	[17] = { ['x'] = -1956.55, ['y'] = 214.41, ['z'] =  85.73 },
	[18] = { ['x'] = -1911.49, ['y'] = 181.34, ['z'] =  82.74 },
	[19] = { ['x'] = -1883.32, ['y'] = 148.64, ['z'] =  80.13 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not emservico then
			for _,v in pairs(coordenadas) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
				local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
				if distance <= 3 then
					DrawMarker(21,v.x,v.y,v.z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
					if distance <= 1.2 then
						drawTxt("PRESSIONE  ~r~E~w~  PARA INICIAR A ROTA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							emservico = true
							if v.id == 2 then
								destino = 28
							else
								destino = 1
							end
							CriandoBlip(entregas,destino)
							TriggerEvent("Notify","sucesso","Você entrou em serviço.")
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if emservico then
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),entregas[destino].x,entregas[destino].y,entregas[destino].z,true)
				if distance <= 50 then
					DrawMarker(1,entregas[destino].x,entregas[destino].y,entregas[destino].z-3,0,0,0,0,0,0,5.0,5.0,4.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,entregas[destino].x,entregas[destino].y,entregas[destino].z+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,255,0,0,50,1,0,0,1)
					if distance <= 4 then
						if GetPedInVehicleSeat(vehicle,-1) == ped then
							if IsControlJustPressed(0,38) then
								if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("bmx")) then
									RemoveBlip(blip)
									if destino == 19 then
										vRP._CarregarObjeto("anim@heists@narcotics@trash","throw_ranged_a","prop_cs_rolled_paper",50,28422)
										TriggerEvent("vrp_sound:source",'jornal',0.5)
										SetTimeout(800,function()											
											vRP._DeletarObjeto()
											vRP._stopAnim(false)
											TriggerServerEvent("trydeleteobj",ObjToNet("prop_cs_rolled_paper"))
										end)
										emP.checkPayment(50)
										destino = 1
										emservico = false
										RemoveBlip(blip)	
										TriggerEvent("Notify","aviso","Você terminou o serviço.")										
									elseif destino == 54 then
										destino = 28
									else
										vRP._CarregarObjeto("anim@heists@narcotics@trash","throw_ranged_a","prop_cs_rolled_paper",50,28422)
										TriggerEvent("vrp_sound:source",'jornal',0.5)
										SetTimeout(800,function()
											vRP._DeletarObjeto()
											vRP._stopAnim(false)
											TriggerServerEvent("trydeleteobj",ObjToNet("prop_cs_rolled_paper"))
										end)
										emP.checkPayment(50)
										destino = destino + 1
										CriandoBlip(entregas,destino)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if emservico then
			if IsControlJustPressed(0,168) then
				emservico = false
				RemoveBlip(blip)
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
function CriandoBlip(entregas,destino)
	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de jornal")
	EndTextCommandSetBlipName(blip)
end