function(enable_optional_manifest target)
    if (NOT MSVC)
        return()
    endif()

    target_link_options(${target} PRIVATE /MANIFEST:NO)

    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND}
            -DMANIFEST_FILE=${CMAKE_CURRENT_SOURCE_DIR}/${target}.manifest
            -DTARGET_EXE=$<TARGET_FILE:${target}>
            -P ${CMAKE_SOURCE_DIR}/cmake/embed_manifest.cmake
        VERBATIM
    )
endfunction()
