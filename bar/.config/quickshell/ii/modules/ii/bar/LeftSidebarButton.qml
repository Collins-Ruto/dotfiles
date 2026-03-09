import QtQuick
import Quickshell.Io
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

RippleButton {
    id: root

    property real buttonPadding: 5
    implicitWidth: distroIcon.width + buttonPadding * 2
    implicitHeight: distroIcon.height + buttonPadding * 2
    buttonRadius: Appearance.rounding.full
    colBackgroundHover: Appearance.colors.colLayer1Hover
    colRipple: Appearance.colors.colLayer1Active

    onPressed: {
        rofiProcess.running = true
    }

    Process {
        id: rofiProcess
        command: ["rofi", "-show", "drun"]
    }

    CustomIcon {
        id: distroIcon
        anchors.centerIn: parent
        width: 19.5
        height: 19.5
        source: SystemInfo.distroIcon
        colorize: true
        color: Appearance.colors.colOnLayer0
    }
}