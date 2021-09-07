#include "../pluginmain.h"
#include "libx64dbg.h"
#include <lua/lua.hpp>
#include <string>
using namespace std;


namespace x64dbg{

static int plugin_logprint(lua_State* L) {
    auto str = lua_tostring(L, 1);
    _plugin_logprint(str);
    return 0;
}

static const luaL_Reg pluginLib[] = {
    {"logprint", plugin_logprint},
    {nullptr, nullptr}
};

int luaopen_x64dbg(lua_State* L) {
    luaL_register(L, "x64dbg", pluginLib);
    luaL_newlib(L, pluginLib);

    char hellostr[256];
    sprintf(hellostr, "%s.logprint(\"-> hello lua\\n\")", "x64dbg");
    auto result = luaL_dostring(L, hellostr);
    if (result == LUA_OK) {
        return 1;
    }
    else {
        _plugin_logprintf("load lua fail, %d\n", result);
        return 0;
    }
}

} // namespace x64dbg
