#include <lua/lua.hpp>
#include "../pluginmain.h"

#define X64DbgModuleName "x64dbg"

BeginXDNameSpace

// register lua module
int luaopen_x64dbg(lua_State* L);

EndXDNameSpace
