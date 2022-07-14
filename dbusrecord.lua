
local dbusaddress=os.getenv("DBUS_SESSION_BUS_ADDRESS")
local recordfile=os.getenv("XDG_RUNTIME_DIR") .. "/dbus.addr"
local f=io.open(recordfile, "w")
f:write(dbusaddress)
f:close()
