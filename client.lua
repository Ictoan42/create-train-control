PORT = 12776
RESOURCE_ID = "log"
CALL_SIGNAL = 0
DEPART_SIGNAL = 15
STATION_NAME = ""

function main()
    st = peripheral.find("Create_Station")
    if st == nil then
        error("No Station connected")
    end
    if st.getStationName() == "Track Station" then
        error("Set station name before use")
    end
    STATION_NAME = st.getStationName()
    modem = peripheral.find("modem")
    if modem == nil then
        error("No modem connected")
    end
    
    while true do
        os.sleep(1)
        local signal = getRS()
        print(signal)
        if signal <= CALL_SIGNAL then
            call()
        elseif signal >= DEPART_SIGNAL then
            depart()
        end
    end
end

function call()
    modem.transmit(PORT, PORT+1,
        {RESOURCE_ID, STATION_NAME}
    )
end

function depart()
    -- find side of Station periph
    local stSide
    for _,v in pairs(peripheral.getNames()) do
        local type = peripheral.getType(v)
        if type == "Create_Station" then
            stSide = v
        end
    end
    rs.setOutput(stSide, true)
    os.sleep(0.1)
    rs.setOutput(stSide, false)
end

function getRS()
    -- find if there is a redstone signal
    -- to any side
    local signal = 0
    for _,side in pairs(rs.getSides()) do
        signal = math.max(
            signal,
            rs.getAnalogueInput(side)
        )
    end
    return signal
end

main()
