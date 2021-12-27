removeHooks()
world='buygems'
message = "Haha Hahaa Hahaaa" -- spam text here CHANGE!

function joinWorld(world)
    sendPacket(false,"action|join_request\nname|" .. world, 3)
end

joinWorld(world)
sleep(2500)
findPath(0,44)
sleep(2500)
findPath(31, 51)
sleep(2500)
findPath(73, 46)

addHook('OnTrackPacket','autorejoin',function(otp)
    if otp:find('eventName%|worldexit') and not otp:find('worldname|^^EXIT') then
        joinWorld(world)
        sleep(2500)
        findPath(0,44)
        sleep(2500)
        findPath(31, 51)
        sleep(2500)
        findPath(73, 46)
    end
end)

while true do
sendPacket(false, "action|input\n|text|"..message,2 )
sleep(6200)
end