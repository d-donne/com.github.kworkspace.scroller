import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
  id: root

  Layout.fillWidth: true
  Layout.fillHeight: true
  implicitWidth: 0
  implicitHeight: 0

  Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground


  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton

    onWheel: function (event) {
      if (event.angleDelta.y > 0) {
        switchDesktop("previous")
      } else {
        switchDesktop("next")
      }
    }
  }

  function switchDesktop (direction) {
    const service = "org.kde.KWin"
    const path = "/VirtualDesktopManager"
    const iface = "org.kde.KWin.VirtualDesktopManager"

    if (direction === "next") {
      desktopDBus.call("Next")
    } else {
      desktopDBus.call("Previous")
    }
  }
 

  PlasmaCore.DataSource {
    id: desktopDBus
    engine: "executable"

    function call (method) {
      const cmd = `qdbus org.kde.KWin /VirtualDesktopManage org.kde.KWin.VirtualDesktopManager.${method}`
      connectSource(cmd)
    }

    onNewData: function (source, data) {
      disconnectSource(source)
    }
  }
}
