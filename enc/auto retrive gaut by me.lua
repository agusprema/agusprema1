removeHooks()
direction = "left" -- 'left','right'
displayBlockID = 1422

gaia = 0
gaiaPos = {}

ut = 0
utPos = {}
-- https://github.com/ManualMap/teohook-scripting-wrapper --

function oprator(x,y) if direction == 'left' then return x - y else return x + y end end

function dropItem(itemID, count)
    hideDrop = true
    sendPacket("action|drop\n|itemID|" .. itemID, 2)
    sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemID .. "|\ncount|" .. count, 2)
    sleep(175)
    hideDrop = false
end

function wrenchTile(x, y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = 32
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
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

function TableGaia()
    for _, tile in pairs(getTiles()) do
        if tile.fg == 6946 then
            table.insert(gaiaPos, tile.pos)
            gaia = gaia + 1
        end
    end
end
TableGaia()

function TableUt()
    for _, tile in pairs(getTiles()) do
        if tile.fg == 6948 then
            table.insert(utPos, tile.pos)
            ut = ut + 1
        end
    end
end
TableUt()
-- https://github.com/ManualMap/teohook-scripting-wrapper --

-- ================================ GAIA ================================ --
while true do -- loop
function retrieve(varlist)
if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|itemsucker_seed|Close|Update|") then
kt = string.format([[action|dialog_return
dialog_name|itemsucker_seed
tilex|%d|
tiley|%d|
buttonClicked|retrieveitem

chk_enablesucking|1
]], varlist[1]:match("tilex|(%d+)"),varlist[1]:match("tiley|(%d+)"))
sendPacket(kt, 2)
return true
end
if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|itemremovedfromsucker|Close|Retrieve|") then
pkt = string.format([[action|dialog_return
dialog_name|itemremovedfromsucker
tilex|%d|
tiley|%d|
itemtoremove|200
]], varlist[1]:match("tilex|(%d+)"),varlist[1]:match("tiley|(%d+)"), varlist[1]:match("itemtoremove|(%d+)"))

sendPacket(pkt, 2)
return true
end
end
addHook("OnVarlist", "fastretrievegaia", retrieve)

seedsID = "341"

if gaia > 0 then
    for i = 1, gaia do
        for l=1,7 do 
            findPath(gaiaPos[i].x, gaiaPos[i].y - 1)
            sleep(2000)
            wrenchTile(gaiaPos[i].x, gaiaPos[i].y)
            findPath(oprator(gaiaPos[i].x, 4), gaiaPos[i].y - 3 - l)
            dropItem(seedsID, 200)
            sleep(2000)
        end
    end
end


-- dropping seeds --

-- ================================ GAIA ================================ --

removeHooks()

-- ================================ UT ================================ --
function retrieve(varlist)
if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|itemsucker_block|Close|Update|") then
kt = string.format([[action|dialog_return
dialog_name|itemsucker_block
tilex|%d|
tiley|%d|
buttonClicked|retrieveitem

chk_enablesucking|1
]], varlist[1]:match("tilex|(%d+)"),varlist[1]:match("tiley|(%d+)"))
sendPacket(kt, 2)
return true
end
if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|itemremovedfromsucker|Close|Retrieve|") then
pkt = string.format([[action|dialog_return
dialog_name|itemremovedfromsucker
tilex|%d|
tiley|%d|
itemtoremove|200
]], varlist[1]:match("tilex|(%d+)"),varlist[1]:match("tiley|(%d+)"), varlist[1]:match("itemtoremove|(%d+)"))

sendPacket(pkt, 2)
return true
end
end
addHook("OnVarlist", "fastretrieveut", retrieve)

blocksID = "340"

if ut > 0 then
    for i = 1, ut do
        for l=1,2 do 
            findPath(utPos[i].x, utPos[i].y - 1)
            sleep(2000)
            wrenchTile(utPos[i].x, utPos[i].y)
            sleep(500)
            for _, tile in ipairs(getTiles()) do 
                if tile.fg == displayBlockID then 
                    findPath(tile.pos.x+1, tile.pos.y)
                    faceSide("left")
                    sleep(500)
                    dropItem(blocksID, 200)
                    sleep(500)
                    sendPacket(pkt, 2)
                end
            end

        end
    end
end

end
-- dropping seeds --
-- ================================ UT ================================ --

-- ==================================================================== --
-- ================== https://discord.gg/5fpyrWcnhQ =================== --
-- =====================By: TheC0mpany#3528 =========================== --
-- ==================================================================== --
