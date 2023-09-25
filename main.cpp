/*
 * Copyright (C) 2022-2023  Maciej Sopylo
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * logviewerfocal is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>

#include "bootmodel.h"
#include "fieldfilterproxymodel.h"
#include "journalduniquequerymodel.h"
#include "journaldviewmodel.h"
#include "src/LomiriAppLaunch.h"

int main(int argc, char *argv[]) {
  QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
  app->setApplicationName("logviewer.ruditimmer");

  qmlRegisterType<JournaldViewModel>("kjournald", 1, 0, "JournaldViewModel");
  qmlRegisterType<JournaldUniqueQueryModel>("kjournald", 1, 0, "JournaldUniqueQueryModel");
  qmlRegisterType<FieldFilterProxyModel>("kjournald", 1, 0, "FieldFilterProxyModel");
  qmlRegisterType<BootModel>("kjournald", 1, 0, "BootModel");

  qmlRegisterSingletonType<LomiriAppLaunch>("LomiriAppLaunch", 1, 0, "LomiriAppLaunch", [](QQmlEngine*, QJSEngine*) -> QObject* { return new LomiriAppLaunch; });

  QQuickView *view = new QQuickView();
  view->setSource(QUrl("qrc:/Main.qml"));
  view->setResizeMode(QQuickView::SizeRootObjectToView);
  view->show();

  return app->exec();
}
