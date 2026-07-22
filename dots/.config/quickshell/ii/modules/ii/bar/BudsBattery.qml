import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

// Bateria de fone Bluetooth (Galaxy Buds etc.): visível apenas quando um fone
// conectado reporta bateria via BlueZ (requer Experimental=true no bluetoothd).
MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property var buds: {
        const devs = Bluetooth.devices.values;
        let fallback = null;
        for (let i = 0; i < devs.length; ++i) {
            const d = devs[i];
            if (!d.connected || !d.batteryAvailable) continue;
            const n = (d.name ?? "").toLowerCase();
            const isAudio = (d.icon ?? "").startsWith("audio")
                || n.includes("buds") || n.includes("ear") || n.includes("head");
            if (isAudio) return d;
            if (!fallback) fallback = d;
        }
        return fallback;
    }
    readonly property bool available: root.buds !== null
    readonly property real percentage: root.buds?.battery ?? 0
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

    visible: root.available
    implicitWidth: root.available ? batteryProgress.implicitWidth : 0
    implicitHeight: Appearance.sizes.barHeight

    hoverEnabled: true

    ClippedProgressBar {
        id: batteryProgress
        anchors.centerIn: parent
        value: root.percentage
        text: Math.round(root.percentage * 100) + "%"
        highlightColor: root.isLow ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer

        Item {
            anchors.centerIn: parent
            width: batteryProgress.valueBarWidth
            height: batteryProgress.valueBarHeight

            RowLayout {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: (parent.height - height) / 2
                }
                spacing: 0

                MaterialSymbol {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: 1
                    fill: 1
                    text: "earbuds"
                    iconSize: Appearance.font.pixelSize.smaller
                }
                StyledText {
                    Layout.alignment: Qt.AlignVCenter
                    font: batteryProgress.font
                    text: batteryProgress.text
                }
            }
        }
    }

    StyledToolTip {
        extraVisibleCondition: root.containsMouse
        text: (root.buds?.name || "Fone") + " — conectado — "
              + Math.round(root.percentage * 100) + "%"
    }
}
