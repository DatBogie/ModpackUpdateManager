import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects

ToolTip {
    id: root
    visible: true
    property bool fauxVisible: false
    opacity: fauxVisible? 1 : 0
    scale: fauxVisible? 1 : .95
    closePolicy: Popup.NoAutoClose

    Behavior on opacity {
        NumberAnimation {
            duration: 350
            easing: Easing.OutCirc
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 350
            easing: Easing.OutCirc
        }
    }

    contentItem: Text {
        text: root.text
        font: root.font
        color: window.text
        wrapMode: Text.Wrap
        elide: Text.ElideRight
    }

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
