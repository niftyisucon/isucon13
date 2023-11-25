-- Debian default Lua configuration file for PowerDNS Recursor

-- Load DNSSEC root keys from dns-root-data package.
-- Note: If you provide your own Lua configuration file, consider
-- running rootkeys.lua too.
dofile("/usr/share/pdns-recursor/lua-config/rootkeys.lua")
function preresolve(dq)
  if dq.qtype == pdns.ANY then
    return true, {rcode=pdns.REFUSED}
  end
  return false
end
