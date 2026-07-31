import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Button {
    id: root
    padding: 0
    property string btnText: "N/A"
    property color neutralColor: window.surface0
    property color pressColor: window.surface1
    property string iconPath: "assets/hide_image_800dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.svg"
    Layout.fillHeight: true
    background: Rectangle {
        color: !root.down? root.neutralColor : root.pressColor
        radius: window.globalBorderRadius
    }

    contentItem: RowLayout {
        height: root.height
        spacing: 0

        Text {
            text: root.btnText
            horizontalAlignment: Text.AlignRight
            color: window.text
            leftPadding: window.globalPadding
        }

        Image {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            scale: window.globalIconScale
            source: root.iconPath
            fillMode: Image.PreserveAspectFit
        }
    }
}
