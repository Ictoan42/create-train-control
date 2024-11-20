PORT = 12776
MODE = "dropoff" -- "dropoff" or "pickup"
RESOURCE_ID = "log"
-- The train will not leave the station if it contains
-- BELOW this amount of cargo, even if it is called.
-- this represents items if this is an item train, or
-- buckets if this is a fluid train.
RESOURCE_MIN = 2
-- Do not modify, set the name in the station itself
HOME_NAME = ""
DEBUG = false

function main()
    modem = peripheral.find("modem")
    if modem == nil then
        error("No modem connected")
    end
    st = peripheral.find("Create_Station")
    if st == nil then
        error("No station connected")
    end
    if st.getStationName() == "Track Station" then
        error("Set station name before use")
    end
    HOME_NAME = st.getStationName()
    
    if not fs.exists("/scheduler.lua") then
        print("Downloading scheduler lib..")
        --local url = "https://github.com/tizu69/cclibs/raw/refs/heads/main/scheduler/scheduler.lua"
        local url = "https://github.com/Ictoan42/cclibs/raw/refs/heads/main/scheduler/scheduler.lua"
        shell.run("wget "..url.." /scheduler.lua")
    end
    Scheduler = require("/scheduler")
    
    modem.closeAll()
    modem.open(PORT)
    
    print("Listening")
    while true do
        local ev = table.pack(os.pullEvent("modem_message"))
        local msg = ev[5]
        --require("cc.pretty").pretty_print(msg)
        
        if not (
            type(msg) == "table"
            and type(msg[1]) == "string"
            and type(msg[2]) == "string"
        ) then
            goto continue
        end
            
        local resource = msg[1]
        if resource ~= RESOURCE_ID then
            goto continue
        end
        
        local res, err = goto(msg[2])
        if DEBUG and not res then
            print("Could not depart: "..err)
        end
        ::continue::
    end
end

function goto(stName)
    if not st.isTrainPresent() then
        return false, "Train not present"
    end
    if st.hasSchedule() then
        -- train is already waiting to leave
        return false, "Train already has schedule"
    end
    local sched
    if MODE == "dropoff" then
        --print(RESOURCE_MIN)
        sched = Scheduler.new(false)
            :to(HOME_NAME)
                :item("minecraft:air", ">", RESOURCE_MIN)
                :OR()
                :fluid("minecraft:air", ">", RESOURCE_MIN)
            :to(stName)
                :powered()
                :OR()
                :unloaded()
                :OR()
                :item("minecraft:air", "=", 0)
                :fluid("minecraft:air", "=", 0)
                --:cargoidle(10)
            :to(HOME_NAME)
    elseif MODE == "pickup" then
        sched = Scheduler.new(false)
            :to(HOME_NAME)
                :fluid("minecraft:air", "=", 0)
                :item("minecraft:air", "=", 0)
            :to(stName)
                :powered()
                :OR():unloaded()
                :OR()
                :fluid("minecraft:air", ">", RESOURCE_MIN)
                :OR()
                :item("minecraft:air", ">", RESOURCE_MIN)
            :to(HOME_NAME)
    end
    if sched == nil then
        return false, "Failed to create schedule"
    end
    --print(sched:serialize(false))
    --require("cc.pretty").pretty_print(
    --    sched.entries[1].conditions[2][1]
    --)
    dbg("Departing to "..stName)
    st.setSchedule(sched)
    return true
end

function dbg(str)
    if DEBUG then
        print(str)
        local ch = peripheral.find("chatBox")
        if ch == nil then return false end
        ch.sendMessage(
            str,
            capitalise(RESOURCE_ID.." train")
        )
        return true
    else return false end
end

function capitalise(str)
    local out = str:gsub(" %l", string.upper)
    out = out:gsub("^%l", string.upper)
    return out
end

main()
