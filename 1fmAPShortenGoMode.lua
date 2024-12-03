-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "1fmAPShortenGoMode"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10
canExecute = false

local world = {0x2340E5C, 0x233FE84}
local room = {0x2340E5C + 0x68, 0x233FE84 + 0x8}
local cutscene_flags_address = {0x2DEB264, 0x2DEA864}
local end_of_the_world_warps = {0x2DEBC68, 0x2DEB268}

local worldWarp = {0x2340EF0, 0x233FEB8}
local roomWarp = {0x2340EF0 + 4, 0x233FEB8 + 4}
local warpTrigger = {0x22ECA8C, 0x22EC0AC}
local warpType1 = {0x23405C0, 0x233FBC0}
local warpType2 = {0x22ECA90, 0x22EC0B0}
local party1 = {0x2DEA1EF, 0x2DE97EF}

function _OnInit()
    IsEpicGLVersion  = 0x3A2B86
    IsSteamGLVersion = 0x3A29A6
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadByte(IsEpicGLVersion) == 0xF0 then
            ConsolePrint("Epic Version Detected")
            game_version = 1
        end
        if ReadByte(IsSteamGLVersion) == 0xF0 then
            ConsolePrint("Steam Version Detected")
            game_version = 2
        end
        canExecute = true
    end
end

function _OnFrame()
    if canExecute then
        if ReadByte(end_of_the_world_warps[game_version]) ~= 0x7 then
            WriteByte(end_of_the_world_warps[game_version], 0x7)
        end
        if ReadByte(world[game_version]) == 0x10 and ReadByte(room[game_version]) == 0x21 and ReadByte(cutscene_flags_address[game_version] + 0xB) == 0x6E then
            WriteByte(cutscene_flags_address[game_version] + 0xB, 0x9B)
            WriteByte(party1[game_version], 1)
            WriteByte(party1[game_version]+1, 2)
            RoomWarp(0x10, 0x3E)
        end
    end
end

function RoomWarp(w, r)
    WriteByte(warpType1[game_version], 5)
    WriteByte(warpType2[game_version], 10)
    WriteByte(worldWarp[game_version], w)
    WriteByte(roomWarp[game_version], r)
    WriteByte(warpTrigger[game_version], 2)
end