cmake_minimum_required(VERSION 3.16)

set(RELEASE_SERVICE_VERSION_MAJOR "0")
set(RELEASE_SERVICE_VERSION_MINOR "1")
set(RELEASE_SERVICE_VERSION_MICRO "90")
set(KJOURNALD_VERSION "${RELEASE_SERVICE_VERSION_MAJOR}.${RELEASE_SERVICE_VERSION_MINOR}.${RELEASE_SERVICE_VERSION_MICRO}")

project(kjournald VERSION ${KJOURNALD_VERSION})

set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FeatureSummary)
include(GenerateExportHeader)
include(CMakePackageConfigHelpers)

add_definitions(
  -DQT_DISABLE_DEPRECATED_BEFORE=0x051500
  -DQT_DEPRECATED_WARNINGS_SINCE=0x060000
  -DKF_DISABLE_DEPRECATED_BEFORE_AND_AT=0x055600
  -DKF_DEPRECATED_WARNINGS_SINCE=0x060000
)

set(KF5_VERSION 5.68.0)
find_package(ECM ${KF5_VERSION} NO_MODULE)
set_package_properties(ECM PROPERTIES
  TYPE REQUIRED
  DESCRIPTION "Extra CMake Modules."
  URL "https://invent.kde.org/frameworks/extra-cmake-modules")
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})
# include(ECMAddTests)
include(ECMEnableSanitizers)
include(ECMCoverageOption)
include(ECMSetupVersion)
include(ECMQtDeclareLoggingCategory)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDEClangFormat)

ecm_setup_version(${KJOURNALD_VERSION}
  VARIABLE_PREFIX KJOURNALD
  VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kjournald_version.h"
  PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KJournaldConfigVersion.cmake"
  SOVERSION 0
)

find_package(KF5 ${KF5_VERSION} REQUIRED COMPONENTS
  CoreAddons
  I18n
)
add_definitions(-DTRANSLATION_DOMAIN=\"kjournald\")

find_package(PkgConfig REQUIRED)
pkg_check_modules(SYSTEMD REQUIRED IMPORTED_TARGET libsystemd)

set(QT_MAJOR_VERSION 5)
set(REQUIRED_QT_VERSION 5.12.0)
find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS
  Core
  Quick
  QuickControls2
  Widgets
)

option(INSTALL_EXPERIMENTAL_HEADERS "Install headers for libkjournald (no stable API yet)" OFF)

add_subdirectory(upstream/lib)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KJournald")
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/upstream/KJournaldConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/KJournaldConfig.cmake"
  INSTALL_DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
)
if(INSTALL_EXPERIMENTAL_HEADERS)
  install(
    FILES
      "${CMAKE_CURRENT_BINARY_DIR}/KJournaldConfig.cmake"
      "${CMAKE_CURRENT_BINARY_DIR}/KJournaldConfigVersion.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
  )

  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/kjournald_version.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}
    COMPONENT Devel
  )

  install(EXPORT KJournaldTargets
          DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
          FILE KJournaldTargets.cmake)

  install(FILES
    upstream/lib/fieldfilterproxymodel.h
    upstream/lib/filtercriteriamodel.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}
  )
endif()

ki18n_install(po)
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
