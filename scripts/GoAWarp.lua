LUAGUI_NAME = "Enable GoA Warp (Steam)"
LUAGUI_AUTH = "BeZide"
LUAGUI_DESC = "Enable GoA Warp (Index 55) only if GardenKnown-Flag == 0x07 (Steam GL)."

stmcheck = 0x585E59
local IsSteamGame = 0

local SAVEDATA_BASE = 0x9A98B0

local OFF_GARDEN_FLAG = 0x231B
local OFF_GOA_WARP    = 0x1EF6
:
-- If GardenFlag == 0x07 then write 0x7F to warp index address
local REQUIRED_GARDEN = 0x07
local WARP_VALUE      = 0x7F

local done = false
local lastPrint = 0

function _OnInit()
    if ENGINE_TYPE == "BACKEND" then
        IsSteamGame = 0
        done = false
        lastPrint = 0
    end
end

function _OnFrame()
    if ReadLong(stmcheck) == 0x7265737563697065 and IsSteamGame == 0 then
        IsSteamGame = 1
        ConsolePrint("[GoA Warp] Steam detected")
        ConsolePrint(string.format("[GoA Warp] SaveBase=0x%X", SAVEDATA_BASE))
        ConsolePrint(string.format("[GoA Warp] GardenFlag @ 0x%X", SAVEDATA_BASE + OFF_GARDEN_FLAG))
        ConsolePrint(string.format("[GoA Warp] WarpIndex  @ 0x%X", SAVEDATA_BASE + OFF_GOA_WARP))
    end
    if IsSteamGame ~= 1 then return end

    local garden = ReadByte(SAVEDATA_BASE + OFF_GARDEN_FLAG)
    local warp   = ReadByte(SAVEDATA_BASE + OFF_GOA_WARP)

    if done then return end

    if garden == REQUIRED_GARDEN then
        WriteByte(SAVEDATA_BASE + OFF_GOA_WARP, WARP_VALUE)
        ConsolePrint(string.format("[GoA Warp] Set warp index to %02X (was %02X)", WARP_VALUE, warp))
        done = true
    end
end