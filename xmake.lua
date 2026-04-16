set_project("imnodes")
set_version("0.1.0")
set_languages("cxx14")

add_rules("mode.debug", "mode.release")

option("examples")
    set_default(false)
    set_showmenu(true)
    set_description("Build SDL2/OpenGL3 example applications")
option_end()

add_requires("imgui", {
    configs = {
        sdl2 = has_config("examples"),
        opengl3 = has_config("examples")
    }
})

if has_config("examples") then
    add_requires("sdl2")
    add_requires("opengl")
end

target("imnodes")
    set_kind("$(kind)")
    set_languages("cxx14")
    add_files("imnodes.cpp")
    add_headerfiles("imnodes.h", "imnodes_internal.h")
    add_includedirs(".", {public = true})
    add_packages("imgui", {public = true})

    if is_plat("windows") and is_kind("shared") then
        add_rules("utils.symbols.export_all", {export_classes = true})
    end

if has_config("examples") then
    local function add_example(name, source)
        target(name)
            set_kind("binary")
            set_languages("cxx14")
            add_deps("imnodes")
            add_files("example/main.cpp", source)
            add_headerfiles("example/graph.h", "example/node_editor.h")
            add_includedirs(".", "example")
            add_packages("imgui", "sdl2", "opengl")

            if is_plat("windows") then
                add_defines("SDL_MAIN_HANDLED")
            end
    end

    add_example("hello", "example/hello.cpp")
    add_example("colornode", "example/color_node_editor.cpp")
    add_example("multieditor", "example/multi_editor.cpp")
    add_example("saveload", "example/save_load.cpp")
end
