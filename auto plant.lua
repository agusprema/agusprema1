platid = {2,4,8,10,5042,5032,102,1222,1224,1324,1914} --PlatId
owners = {"YouAreLucky06", "GraseTopia", 'hmht'}
seedid = 3 --SeedId
default_command_start = "SGP"
default_command_stop = "SGPs"
default_command_set = "SGPa"
default_command_pattern = "!"

function findItem(id)
    for _, itm in pairs(getInventory()) do
        if itm.id == id then
            return itm.count
        end
    end
    return 0
end

function hit_tile(x, y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = 18
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
end

function place_tile(x, y, id)
    pkt = {}
    pkt.type = 3
    pkt.int_data = id
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
end

startx = getLocal().pos.x / 32
starty = getLocal().pos.y / 32
function findEmptyPlat()
    for _, tile in pairs(getTiles()) do
        for _, plat in pairs(platid) do
            if tile.fg == plat then
                if getTile(tile.pos.x, tile.pos.y - 1).fg == 0 then
                    findPath(tile.pos.x, tile.pos.y - 1)
                    sleep(300)
                    place_tile(tile.pos.x, tile.pos.y - 1, seedid)  
                    sleep(300)                    
                    place_tile(tile.pos.x, tile.pos.y + 1, seedid)    
                    sleep(300)                 
                    place_tile(tile.pos.x, tile.pos.y - 3, seedid) 
                    sleep(300)                        
                    return true
                end
            end
        end
    end
    return false
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

while true do
    planting = findEmptyPlat()
    sleep(200)
    if findItem(seedid) < 180 then
        findPath(startx, starty)
        sleep(200)
        collect(1,seedid)
        sleep(200)
    end
end