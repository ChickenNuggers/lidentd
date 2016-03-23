local ffi = require("ffi") -- vim:set noet sts=0 sw=3 ts=3:
local cq  = require("cqueues")
local so  = require("cqueues.socket")
local cqs = cqueues.new()

local bind = "0.0.0.0"
local port = 113

ffi.cdef[[
	struct passwd *getpwuid(int uid);
]]

local getpwuid = ffi.C.getpwuid

cqs:wrap(function()
	local srv = so.listen(bind, port)
	for client in srv:clients() do
		cq:wrap(function()
			local ports = client:read()
			local lport = assert(tonumber(ports:gsub(" ",""):match("(%d+),%d+")))
			local file
			if client:peername() == so.AF_INET then
				file = assert(io.open("/proc/net/tcp"))
			else
				file = assert(io.open("/proc/net/tcp6"))
			end
			file:read() -- chomp headers
			for line in file:lines() do
				local words = {}
				for word in line:gmatch("%S+") do
					words[#words + 1] = word
				end
				local port = tonumber(words[2]:match("%x*:(%x+)"), 16)
				local uid  = tonumber(words[8])
				if port == lport then
					local s_passwd = getpwuid(uid) -- Username from UID
					if not s_passwd then
						-- User not found
						client:write(ports .. ":USERID:LINUX:NO-USER")
					elseif not s_passwd.pw_name then
						-- Username not found
						client:write(ports .. ":USERID:LINUX:HIDDEN-USER")
					else
						client:write(ports .. ":USERID:LINUX:" .. s_passwd.pw_name
							.. "\n")
					end
				end
				file:close()
				client:shutdown()
			end
		end)
	end
end)

cqs:loop()
