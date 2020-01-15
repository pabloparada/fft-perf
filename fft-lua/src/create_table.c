#ifdef __cplusplus
  #include "lua.hpp"
#else
  #include "lua.h"
  #include "lualib.h"
  #include "lauxlib.h"
#endif

#ifdef __cplusplus
extern "C"{
#endif

static int native_create_table(lua_State *L) {
  lua_createtable(L,luaL_checknumber(L,1),luaL_checknumber(L,2));
  return 1;
}

static const struct luaL_Reg create_table_lib [] = {
  {"create_table", native_create_table},
  {NULL, NULL}
};

int luaopen_create_table (lua_State *L){
    luaL_newlib(L, create_table_lib);
    return 1;
}

#ifdef __cplusplus
}
#endif