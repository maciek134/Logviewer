TEMPLATE = subdirs
SUBDIRS = modules/logviewer

OTHER_FILES += $$system(find tests -type f)

check.target = check
check.commands = qmltestrunner -import modules -platform ubuntu
check.depends = modules/logviewer
QMAKE_EXTRA_TARGETS += check

