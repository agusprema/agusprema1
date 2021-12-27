SeedId = 341 -- You can change whatever value you want
default_command_start = "SGP" -- this for start command, You can change whatever value you want
default_command_stop = "SGPs" -- this for stop command, You can change whatever value you want
default_command_set = "SGPa"  -- this for set value command, You can change whatever value you want

-- ==================================================================== --
-- ========================== Avaible Command  ======================== --
-- ==================================================================== --
-- default_command_start "harvest" for run sc
-- default_command_stop "harvest" for stop sc
-- default_command_start "goto NameWorld" for change wolrd / warp bot
-- default_command_set "seed SeedID" for change the seed value
-- example !SGP harvest for run sc
-- example !SGPs harvest for stop sc
-- example !SGPa seed SeedId for change the seed value
-- example !SGP goto YourWorld for change wolrd / warp bot
-- ==================================================================== --

owner="YouAreLucky06"

removeHooks()
function joinWorld(world)
    sendPacket("action|join_request\nname|" .. world, 3)
end

function sendtext(text)
    sendPacket('action|input\n|text|'..text,2)
end

function getArgs(str)
    local args={}
    for i in str:gmatch('[^%s]+') do
        args[#args+1]=i
    end
    return args
end

function command ()
    sendtext('Auto Command enabled')
    auto_harvest = false

    addHook('OnVarlist', 'command', function(vlist)
        if vlist[0]=="OnConsoleMessage" then
            if vlist[1]:match('[^`]+[MSG]'):sub(-3) == "MSG" then
                pname__=vlist[1]:match('```c`.[^`]+'):sub(7)
                pcmd__=vlist[1]:match('> ```[^`]+'):sub(7)
            else
                pname__=vlist[1]:match('<`.[^`]+'):sub(4)
                pcmd__=vlist[1]:match('`$[^`]+'):sub(3)
            end


            if pcmd__ and pcmd__:sub(1,1)=='!' then
                if owner then
                    if pname__~=owner then
                        return
                    end
                end

                pcmd__=getArgs(pcmd__:sub(2))

                if pcmd__[1]==default_command_start then
                    if pcmd__[2]=='harvest' then
                        sendtext('`2Auto Harvest enabled')
                        sleep(300)
                        auto_harvest = true
                    elseif pcmd__[2]=='goto' then
                        sendPacket("action|join_request\nname|"..pcmd__[3],3)
                        sendPacket("action|input\n|text|Menuju ke"..pcmd__[3], 2)
                        sleep(2000)
                    end
                elseif pmcd__[1]==default_command_set then
                    if pcmd__[2]=='seed' then
                        SeedId = pcmd__[3]
                        sleep(300)
                        sendtext('`2Seed id has ben updated')
                    end
                elseif pcmd__[1]==default_command_stop then
                    if pcmd__[2]=='harvest' then
                        auto_harvest = false
                        sleep(300)
                        sendtext('`2Auto Harvest disabled')
                    end
                end
            end
        end
    end)
end
command ()

function harvest(x,y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = 18
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    pkt.int_x = x
    pkt.int_y = y
    sendPacketRaw(pkt)
end

function AutoHarvest()
    for _, tile in pairs(getTiles()) do
        if tile.fg == SeedId then
            findPath(tile.pos.x, tile.pos.y)
            sleep(500)
            harvest(tile.pos.x,tile.pos.y)
            sleep(100)
            harvest(tile.pos.x-1,tile.pos.y)

            if not auto_harvest then
                goto END
            end
        end
    end
    
    auto_harvest = false
    sleep(300)
    sendtext('`2Auto Harvest disabled')

    ::END::
end

while true do
    if auto_harvest then 
        AutoHarvest()
    end
end

-- ==================================================================== --
-- =================== https://discord.gg/2cyTNaGMfX ================== --
-- ======================== By: sungprema#7201 ======================== --
-- ==================================================================== --