import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

// Bateria de controle (DualSense/Xbox): visível apenas quando um controle
// está conectado — sumir da barra significa desconectado.
MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property var controller: {
        const devs = UPower.devices.values;
        let fallback = null;
        for (let i = 0; i < devs.length; ++i) {
            const d = devs[i];
            const m = (d.model ?? "").toLowerCase();
            const isPad = d.type === UPowerDeviceType.GamingInput
                || m.includes("dualsense") || m.includes("controller")
                || m.includes("gamepad") || m.includes("xbox");
            if (!isPad) continue;
            if (m.includes("dualsense")) return d; // DualSense tem prioridade
            if (!fallback) fallback = d;
        }
        return fallback;
    }
    readonly property bool available: root.controller !== null
    readonly property real percentage: root.controller?.percentage ?? 0
    readonly property bool isCharging: root.controller?.state === UPowerDeviceState.Charging
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
        highlightColor: (root.isLow && !root.isCharging) ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer

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
                    text: "sports_esports"
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
        text: (root.controller?.model || "Controle") + " — "
              + (root.isCharging ? "carregando" : "conectado") + " — "
              + Math.round(root.percentage * 100) + "%"
    }
}
