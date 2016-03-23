# lidentd
Lua ident server

## Contributors

| Name            | Email                | GitHub Account |
| ----------------|----------------------|--------------- |
| Charles Heywood | charles@hashbang.sh  | ChickenNuggers |


## Requirements

 * LuaRocks (optional for installing dependencies)
 * cqueues
 * luaffi (may come included with LuaJIT or via luaffifb)

## Running

Two environmental variables may be set before running the program to customize
the interpreter and LuaRocks version used; the variables are respectively `LUA`
and `LUAROCKS` and should be set to the name of the program used to launch
them. Because most distributions require users to be a superuser for access to
ports below and including 1024, make sure libraries are installed for the root
user or systemwide (`sudo luarocks install --local` and `sudo luarocks install`
respectively).

**Example:**

```sh
LUA=lua5.3
LUAROCKS=luarocks-5.3
sudo ./start.sh
```
