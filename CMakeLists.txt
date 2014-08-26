project(logviewer C CXX)
cmake_minimum_required(VERSION 2.8.9)

set (UBUNTU_PROJECT_TYPE "ClickApp" CACHE INTERNAL "Tells QtCreator this is a Click application project")
set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
#find_package(ubuntu-sdk-libs)

#automatically create moc files
set(CMAKE_AUTOMOC ON)

# components PATH
execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(QT_IMPORTS_DIR "lib/${ARCH_TRIPLET}")

option(INSTALL_TESTS "Install the tests on make install" on)

set(APP_NAME          logviewer)
set(LOGVIEWER_DIR     "app")
set(MAIN_QML          "logviewer.qml")
set(ICON              "icon.png")

#set install paths
set(CMAKE_INSTALL_PREFIX /)
set(DATA_DIR /)
set(DESKTOP_DIR ${DATA_DIR})

set(EXEC "qmlscene $@ ${LOGVIEWER_DIR}/${MAIN_QML}")

install(FILES manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
install(DIRECTORY "app/graphics" DESTINATION ${DATA_DIR})
install(FILES "Logviewer.json" ${ICON} DESTINATION ${DATA_DIR})

add_subdirectory(app)
add_subdirectory(backend)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    COMMAND ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    DEPENDS logviewerbackend logviewerbackend-qmldir
                    WORKING_DIRECTORY ./app)

add_custom_target("check" /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/app/tests/unit -import ${CMAKE_BINARY_DIR}/backend
                    DEPENDS logviewerbackend logviewerbackend-qmldir
                    WORKING_DIRECTORY ./app)

add_custom_target("run" /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/backend  ${CMAKE_SOURCE_DIR}/app/logviewer.qml
                    DEPENDS logviewerbackend logviewerbackend-qmldir
                    WORKING_DIRECTORY ./app)

