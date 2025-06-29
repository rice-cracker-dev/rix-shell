//@ pragma UseQApplication

import Quickshell
import "./windows/wallpaper" as Wallpaper
import "./windows/mainbar" as Mainbar
import "./windows/notification" as Notification

ShellRoot {
  Wallpaper.Window {}
  Notification.Window {}
  Mainbar.Window {}
}
