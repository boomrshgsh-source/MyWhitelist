--==== SIMPLE ONLINE WHITELIST ====

_G.Key = tostring(_G.Key or "")

local Http = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

local RAW = "https://raw.githubusercontent.com/USERNAME/REPO/main/whitelist.json"
local API = "https://api.github.com/repos/USERNAME/REPO/contents/whitelist.json"
local TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXX" -- ใส่ token คุณ

if _G.Key == "" then Player:Kick("No Key") end

local list = Http:JSONDecode(game:HttpGet(RAW))

if not list[_G.Key] then Player:Kick("Invalid Key") end

-- bind ครั้งแรก
if list[_G.Key] == "" then
    list[_G.Key] = HWID

    local repo = Http:JSONDecode(game:HttpGet(API))
    local sha = repo.sha

    local body = Http:JSONEncode({
        message = "Bind ".._G.Key,
        content = Http:Base64Encode(Http:JSONEncode(list)),
        sha = sha
    })

    game:HttpRequest({
        Url = API,
        Method = "PUT",
        Headers = {
            ["Authorization"] = "token "..TOKEN,
            ["User-Agent"] = "Roblox"
        },
        Body = body
    })
end

if list[_G.Key] ~= HWID then
    setclipboard(HWID)
    Player:Kick("HWID mismatch\nHWID copied")
end

print("ACCESS GRANTED")
