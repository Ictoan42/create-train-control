print("Which component to install?")
print("  1 - Server\n  2 - Client")

local to_install = ""
while true do
    local choice = read()
    if choice == "1" then
        to_install = "server.lua"
        break
    elseif choice == "2" then
        to_install = "client.lua"
        break
    else
        print("Unrecognised choice, please try again")
    end
end

if to_install == "" then
    error("Unknown error")
end

fs.makeDir("/startup")
local url = "https://github.com/Ictoan42/create-train-control/raw/refs/heads/main/"
shell.run("wget "..url..to_install.." /startup/ctc-"..to_install)
