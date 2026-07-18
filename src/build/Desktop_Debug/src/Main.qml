import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window
    width: 1024
    height: 600
    minimumWidth: 640
    minimumHeight: 480
    visible: true
    title: qsTr("Modpack Update Manager")

    /* Colors */
    property color rosewater: "#f4dbd6"
    property color flamingo: "#f0c6c6"
    property color pink: "#f5bde6"
    property color mauve: "#c6a0f6"
    property color red: "#ed8796"
    property color maroon: "#ee99a0"
    property color peach: "#f5a97f"
    property color yellow: "#eed49f"
    property color green: "#a6da95"
    property color teal: "#8bd5ca"
    property color sky: "#91d7e3"
    property color sapphire: "#7dc4e4"
    property color blue: "#8aadf4"
    property color lavender: "#b7bdf8"
    property color text: "#cad3f5"
    property color subtext1: "#b8c0e0"
    property color subtext0: "#a5adcb"
    property color overlay2: "#939ab7"
    property color overlay1: "#8087a2"
    property color overlay0: "#6e738d"
    property color surface2: "#5b6078"
    property color surface1: "#494d64"
    property color surface0: "#363a4f"
    property color base: "#24273a"
    property color mantle: "#1e2030"
    property color crust: "#181926"
    property color accent: window.lavender

    property int globalPadding: 5
    property int globalBorderRadius: 10

    color: window.crust

    Component {
        id: modpackGridItem

        Item {
            width: modpackGrid.cellWidth
            height: modpackGrid.cellHeight
            Button {
                id: modpackThumbnail
                anchors.centerIn: parent
                background: Rectangle {
                    color: !parent.down? window.base : window.surface0
                    radius: window.globalBorderRadius
                }
                implicitWidth: modpackGrid.cellWidth-window.globalPadding
                implicitHeight: modpackGrid.cellHeight-window.globalPadding

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    height: 20
                    color: window.surface1
                    bottomLeftRadius: window.globalBorderRadius
                    bottomRightRadius: window.globalBorderRadius

                    RowLayout {
                        anchors.fill: parent
                        Label {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            horizontalAlignment: "AlignLeft"
                            verticalAlignment: "AlignVCenter"
                            text: "Testdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"
                            leftPadding: window.globalPadding
                            color: window.text
                            elide: Text.ElideRight
                        }
                        Button {
                            text: "M"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        Button {
                            text: "X"
                            color: window.text
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            background: Rectangle {
                                color: !parent.down? window.base : window.surface0
                                bottomRightRadius: window.globalBorderRadius
                            }
                        }
                    }
                }
            }
        }
    }

    RowLayout {
        anchors {
            fill: parent
            margins: window.globalPadding
        }

        GridView {
            id: modpackGrid
            Layout.alignment: Qt.AlignTop
            anchors.fill: parent
            model: 10
            delegate: modpackGridItem
            property int minCellWidth: 250
            property int minCellHeight: 150
            property int columns: Math.max(1, Math.floor(width/minCellWidth))
            cellWidth: width/columns
            cellHeight: minCellHeight
        }
    }
}
