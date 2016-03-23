if [ ! "$LUA" ]; then # vim:set noet sts=0 sw=3 ts=3:
	LUA=lua
fi; if [ ! "$LUAROCKS" ]; then
	LUAROCKS=luarocks
fi

if which $LUAROCKS; then
	# Get path for luarocks
	eval `$LUAROCKS path`
fi
$LUA main.lua
