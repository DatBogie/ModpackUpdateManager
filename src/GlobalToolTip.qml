import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects

ToolTip {
    background: Item {
        implicitWidth: tipBubble.implicitWidth
        implicitHeight: tipBubble.implicitHeight

        Rectangle {
            id: tipBubble
            anchors.fill: parent
            color: window.base
            border.color: window.surface0
            border.width: window.globalBorderWidth
            radius: window.globalBorderRadius
        }

        MultiEffect {
            source: tipBubble
            anchors.fill: tipBubble
            shadowBlur: 1.0
            shadowEnabled: true
            shadowColor: "black"
            shadowVerticalOffset: 4
            shadowOpacity: .85
        }
    }
}
