breaklmao = true;
HIT = 10
function hit_tile(x, y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = 18
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    --sendPacketRaw(false, pkt)
    sendPacketRaw(pkt)
end

function putTile(blockID, x, y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = blockID
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
end

function break_tile(x, y)
    for i=1,HIT do
        hit_tile(x, y)
        sleep(200)
    end
end

function CheckCaveBackground()
    for __, tile in pairs(getTiles()) do
        if tile.fg == 10 or tile.fg == 5032 or tile.fg == 5036 then
            findPath(tile.pos.x, tile.pos.y + 1)
            sleep(300)
            break_tile(tile.pos.x, tile.pos.y)
            sleep(300)
            putTile(2, tile.pos.x, tile.pos.y)
            sleep(200)
        end
    end
    return false
end

while breaklmao do
    CheckCaveBackground()
end