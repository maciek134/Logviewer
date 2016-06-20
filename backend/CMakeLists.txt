include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    Logviewerbackend_SRCS
    modules/Logviewer/backend.cpp
    modules/Logviewer/logreaderservice.cpp
    modules/Logviewer/logviewer.cpp
)

# Make the unit test files visible on qtcreator
add_custom_target(Logviewerbackend_UNITTEST_QML_FILES ALL SOURCES "tests/unit/tst_mytype.qml")

add_library(Logviewerbackend MODULE
    ${Logviewerbackend_SRCS}
)

set_target_properties(Logviewerbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY Logviewer)

qt5_use_modules(Logviewerbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(Logviewerbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Logviewer/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Logviewer
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS Logviewerbackend DESTINATION ${QT_IMPORTS_DIR}/Logviewer/)
install(FILES   modules/Logviewer/qmldir DESTINATION ${QT_IMPORTS_DIR}/Logviewer/)

