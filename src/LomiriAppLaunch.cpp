/*
 * Copyright (C) 2023  Maciej Sopylo
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

#include "LomiriAppLaunch.h"
#include <lomiri-app-launch/application.h>
#include <lomiri-app-launch/registry.h>

QStringList LomiriAppLaunch::iconAndName(const QString &id) const {
  QStringList list;

  try {
    auto appid = lomiri::app_launch::AppID::find(id.toUtf8().constData());

    if (appid.empty()) {
      return list;
    }

    std::shared_ptr<lomiri::app_launch::Application> app = lomiri::app_launch::Application::create(
          appid, lomiri::app_launch::Registry::getDefault());

    if (!app) {
      return list;
    }
    
    auto info = app->info();

    list << QString::fromStdString(info->iconPath().value());
    list << QString::fromStdString(info->name().value());

    return list;
  } catch (std::runtime_error &e) {
    return list;
  }
}
