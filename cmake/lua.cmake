CPMAddPackage(
    NAME luajit
    GITHUB_REPOSITORY LuaJIT/LuaJIT
    DOWNLOAD_ONLY ON
    VERSION 2.1
)

if(luajit_ADDED)
    if(NOT TARGET lua)
        file(GLOB_RECURSE luajit_sources CONFIGURE_DEPENDS ${luajit_SOURCE_DIR}/src/**.c)
        set(lua_dll ${luajit_SOURCE_DIR}/src/lua51.dll)
        add_custom_command(OUTPUT ${lua_dll}
            COMMAND msvcbuild.bat
            COMMAND ${CMAKE_COMMAND} -E rm -rf ${luajit_SOURCE_DIR}/include
            COMMAND ${CMAKE_COMMAND} -E make_directory ${luajit_SOURCE_DIR}/include/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lua.h     ${luajit_SOURCE_DIR}/include/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/luaconf.h ${luajit_SOURCE_DIR}/include/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lauxlib.h ${luajit_SOURCE_DIR}/include/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lualib.h  ${luajit_SOURCE_DIR}/include/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/luajit.h  ${luajit_SOURCE_DIR}/include/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lua.hpp   ${luajit_SOURCE_DIR}/include/lua
            WORKING_DIRECTORY "${luajit_SOURCE_DIR}/src"
            DEPENDS ${luajit_sources}
            COMMENT "BUILD LUAJIT"
            VERBATIM
            )
        add_library(lua INTERFACE)
        add_custom_target(luabuild DEPENDS ${lua_dll})
        add_dependencies(lua luabuild)
        target_link_directories(lua INTERFACE ${luajit_SOURCE_DIR}/src)
        target_link_libraries(lua INTERFACE lua51)
        target_include_directories(lua INTERFACE ${luajit_SOURCE_DIR}/include)
    endif()

    function(link_lua target)
        target_link_libraries(${target} PRIVATE lua)
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${lua_dll} $<TARGET_FILE_DIR:${target}>
            )
    endfunction()
endif()

