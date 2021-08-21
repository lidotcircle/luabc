CPMAddPackage(
    NAME luajit
    GITHUB_REPOSITORY LuaJIT/LuaJIT
    VERSION 2.1
)

if(luajit_ADDED)
    set(LUAJIT_LIB ${luajit_SOURCE_DIR}/src/lua51.lib)
    if(NOT TARGET luajit)
        set(LUAJIT_INCLUDE_DIR ${luajit_SOURCE_DIR}/include)
        add_custom_command(OUTPUT ${LUAJIT_LIB}
            COMMAND msvcbuild.bat
            COMMAND ${CMAKE_COMMAND} -E make_directory ${LUAJIT_INCLUDE_DIR}/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lua.h     ${LUAJIT_INCLUDE_DIR}/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/luaconf.h ${LUAJIT_INCLUDE_DIR}/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lauxlib.h ${LUAJIT_INCLUDE_DIR}/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lualib.h  ${LUAJIT_INCLUDE_DIR}/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/luajit.h  ${LUAJIT_INCLUDE_DIR}/lua
            COMMAND ${CMAKE_COMMAND} -E copy ${luajit_SOURCE_DIR}/src/lua.hpp   ${LUAJIT_INCLUDE_DIR}/lua
            WORKING_DIRECTORY "${luajit_SOURCE_DIR}/src"
            DEPENDS "${luajit_SOURCE_DIR}/src/msvcbuild.bat"
            COMMENT "build luajit ${luajit_SOURCE_DIR}"
            VERBATIM
            )
        add_custom_target(luajit_lua51lib DEPENDS ${LUAJIT_LIB})
        add_library(luajit INTERFACE)
        add_dependencies(luajit luajit_lua51lib)
        target_include_directories(luajit INTERFACE ${LUAJIT_INCLUDE_DIR})
        target_link_directories(luajit INTERFACE ${luajit_SOURCE_DIR}/src)
        target_link_libraries(luajit INTERFACE ${LUAJIT_LIB})
    endif()

    function(link_luajit target)
        add_dependencies(${target} luajit)
        target_link_libraries(${target} PRIVATE luajit)
    endfunction()
endif()

