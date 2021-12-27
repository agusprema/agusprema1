removeHooks()
enabled = false
BlockId = 340
SeedId = 341
groundBlockID = 5042
displayBlockID = 1422
CountID = 200 
world_drop = "chant9"
world_break = "dfsdf348"
delay_moveWorld = 5000 
default_command_start = "SGP"
default_command_stop = "SGPs"
default_command_set = "SGPa"

-- utils Function
function dropItem(itemID, count)
    hideDrop = true
    sendPacket("action|drop\n|itemID|" .. itemID, 2)
    sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemID .. "|\ncount|" .. count, 2)
    sleep(175)
    hideDrop = false
end

function joinWorld(world)
    sendPacket("action|join_request\nname|" .. world, 3)
end

function faceSide(side)
    if side == "left" then
        packet = {}
        packet.type = 0
        packet.pos_x = getLocal().pos.x
        packet.pos_y = getLocal().pos.y
        packet.flags = 48
        sendPacketRaw(packet)
        return
    end
    if side == "right" then
        packet = {}
        packet.type = 0
        packet.pos_x = getLocal().pos.x
        packet.pos_y = getLocal().pos.y
        packet.flags = 32
        sendPacketRaw(packet)
        return
    end
    log("`cInvalid side chosen (`4" .. side .. "`c)")
end

function collect(range,id) 
    pos = getLocal().pos
    for _, obj in pairs(getObjects()) do
        posx = math.abs(pos.x - obj.pos.x)
        posy = math.abs(pos.y - obj.pos.y)
        if posx < (range * 32) and posy < (range * 32) then
            if id then
                if obj.id~=id then goto END end 
            end
            
            pkt = {}
            pkt.type = 11
            pkt.int_data = obj.oid
            pkt.pos_x = obj.pos.x
            pkt.pos_y = obj.pos.y
            sleep(100)
            sendPacketRaw(pkt)
        end
        ::END::
    end
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
    auto_move = false

    addHook('OnVarlist', 'command', function(vlist)
        if vlist[0]=="OnConsoleMessage" then
            pname__=vlist[1]:match('<`.[^`]+'):sub(4)
            pcmd__=vlist[1]:match('`$[^`]+'):sub(3)


            if pcmd__ and pcmd__:sub(1,1)=='!' then
                if owner then
                    if pname__~=owner then
                        return
                    end
                end
                pcmd__=getArgs(pcmd__:sub(2))

                if pcmd__[1]==default_command_start then
                    if pcmd__[2]=='move' then
                        sendtext('`2Auto Move enabled')
                        sleep(300)
                        auto_move = true
                    elseif pcmd__[2]=='goto' then
                        if pcmd__[3] =='1' then
                            if getLocal().name == 'grstpbotc1' then
                                sendPacket("action|join_request\nname|"..pcmd__[4],3)
                                sendPacket("action|input\n|text|Menuju ke"..pcmd__[4], 2)
                                sleep(2000)
                            end
                        elseif pcmd__[3] =='2' then
                            if getLocal().name == 'grstpbotc2' then
                                sendPacket("action|join_request\nname|"..pcmd__[4],3)
                                sendPacket("action|input\n|text|Menuju ke"..pcmd__[4], 2)
                                sleep(2000)
                            end
                        end
                    end
                elseif pcmd__[1]==default_command_set then
                    if pcmd__[2]=='drop' then
                        world_drop = pcmd__[3]
                        sleep(300)
                        sendtext('`2World drop changed to '..world_drop)
                    elseif pcmd__[2]=='break' then
                        world_break = pcmd__[3]
                        sleep(300)
                        sendtext('`2World break changed to '..world_break)
                    end
                elseif pcmd__[1]==default_command_stop then
                    if pcmd__[2]=='move' then
                        auto_move = false
                        sleep(300)
                        sendtext('`2Auto Move disabled')
                    end
                end
            end
        end
    end)
end
command ()


function AutoMove()
    displayBlock = 0
    displayBlockPos = {}

    sleep(2000)

    for _, tile in ipairs(getTiles()) do 
        if tile.fg == groundBlockID then 
            collect(1, BlockId)
            findPath(tile.pos.x, tile.pos.y)
            collect(1, BlockId) 
        end
    end

    sleep(2000)

    for _, tile in ipairs(getTiles()) do 
        if tile.fg == displayBlockID then 
            table.insert(displayBlockPos, tile.pos)
            displayBlock = displayBlock + 1
        end
    end

    if displayBlock > 0 then
        for i = 1, displayBlock do
            findPath(displayBlockPos[i].x+1, displayBlockPos[i].y)
            faceSide("left")
            sleep(500)
            dropItem(BlockId,CountID)
            sleep(500)
            sendPacket(pkt, 2)
        end
    end
end
-- utils Function


-- Function
while true do 
    if auto_move then
        AutoMove()
    end
end
-- Function