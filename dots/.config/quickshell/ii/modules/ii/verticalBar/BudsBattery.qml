import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

// Bateria de fone Bluetooth (Galaxy Buds etc.) para a barra vertical: visível
// apenas quando um fone conectado reporta bateria via BlueZ.
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
    implicitHeight: batteryProgress.implicitHeight
    hoverEnabled: true

    ClippedProgressBar {
        id: batteryProgress
        anchors.centerIn: parent
        vertical: true
        valueBarWidth: 20
        valueBarHeight: 36
        value: root.percentage
        text: Math.round(root.percentage * 100)
        highlightColor: root.isLow ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer

        font {
            pixelSize: 13
            weight: Font.DemiBold
        }

        textMask: Item {
            anchors.centerIn: parent
            width: batteryProgress.valueBarWidth
            height: batteryProgress.valueBarHeight

            Column {
                anchors.centerIn: parent
                spacing: -4

                MaterialSymbol {
                    anchors.horizontalCenter: parent.horizontalCenter
                    fill: 1
                    text: "earbuds"
                    iconSize: Appearance.font.pixelSize.normal
                }
                StyledText {
                    visible: text.length <= 2
                    anchors.horizontalCenter: parent.horizontalCenter
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
