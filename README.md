# Create Train Control
This system is composed of a client and a server:
- The client requests for the train for be sent to it's location when needed
- The server waits for any clients to request a delivery

Tested on Create 0.5.1.f, should work on 0.5.1.j

Makes use of [tizu's scheduling library](https://github.com/tizu69/cclibs/tree/main/scheduler)

## Usage

### Client
- Place computer next to station block
- Place modem on computer (can be any type, although the server must be able to recieve the messages)
- Run `wget run https://github.com/Ictoan42/create-train-control/raw/refs/heads/main/installer.lua`
- Select Client to install
- Configure client by modifying variables at the top of `/startup/ctc-client.lua`
- Build station to automatically extract from the delivery train, and connect a redstone signal to the computer that describes how full the station's storage is. For example if the station unloads fluids into a tank, place a comparator on the tank that transmits it's signal to the computer.

### Server
- Place computer next to station block
- Place modem on computer
- run `wget run https://github.com/Ictoan42/create-train-control/raw/refs/heads/main/installer.lua`
- Select Server to install
- Configure server by modifying variables at the top of `/startup/ctc-server.lua`
- OPTIONAL: If `DEBUG = true` is set and an [Advanced Peripherals](https://modrinth.com/mod/advancedperipherals) chat box peripheral is next to the computer, it will put a message in chat every time the train departs.

