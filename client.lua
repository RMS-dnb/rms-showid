local showPlayerBlips = false
local ignorePlayerNameDistance = false
local playerNamesDist = 15
local displayIDHeight = 1.5 --Height of ID above players head(starts at center body mass)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())  
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	
	local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
	
    local str = CreateVarString(10, "LITERAL_STRING", tostring(text), Citizen.ResultAsLong())
    if onScreen then
    	SetTextScale(0.0*scale, 0.55*scale)
  		SetTextFontForCurrentCommand(1)
		SetTextColor(255, 255, 255, 255)
    	SetTextCentre(1)
		GetScreenCoordFromWorldCoord(x, y, z, 0)
    	DisplayText(str,_x,_y)
    	local factor = (string.len(text)) / 225
    	--DrawSprite("feeds", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03*scale, 0.1*scale, 35, 35, 35, 100, 0)
    	--DrawSprite("feeds", "toast_bg", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0,0x430593AA) then
			--print("KLIKA")
            for id = 0, 32 do
                if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= PlayerPedId()) then
                ped = GetPlayerPed( id )
                blip = GetBlipFromEntity( ped ) 
 
                x1, y1, z1 = table.unpack( GetEntityCoords( PlayerPedId(), true ) )
                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

                if ((distance < playerNamesDist)) then
                    if not (ignorePlayerNameDistance) then
						--print("LECI2")
							DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))
                    end
                end  
            end
        end
        elseif not IsControlPressed(1,0x430593AA) then
            DrawText3D(0, 0, 0, "")
        end
    end
end)
