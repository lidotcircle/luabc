#include "plugin.h"
#include <lua/lua.hpp>
#include "module/libx64dbg.h"

static lua_State *luaState = nullptr;

//Initialize your plugin data here.
bool pluginInit(PLUG_INITSTRUCT* initStruct)
{
    luaState = luaL_newstate();
    if (luaState == nullptr) {
        return false;
    }
    if (!x64dbg::luaopen_x64dbg(luaState)) {
        return false;
    };
    return true; //Return false to cancel loading the plugin.
}

//Deinitialize your plugin data here.
void pluginStop()
{
    if (luaState)
    {
        lua_close(luaState);
        luaState = nullptr;
    }
}

//Do GUI/Menu related things here.
void pluginSetup()
{
}
