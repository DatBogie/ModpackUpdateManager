import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Effects

Window {
    id: wizardWindow
    visible: false
    width: 600
    height: 400
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    color: window.color

    onVisibleChanged: {
        if (!visible) {
            wizard.currentIndex = 0;
            return;
        }
    }

    property color childColor: window.surface0
    property color childPressColor: window.surface1

    Item {
        width: parent.width-window.globalPadding*2
        height: parent.height-window.globalPadding*2
        anchors.centerIn: parent

        Rectangle {
            id: wizardNavbar
            property real textSize: window.globalTextSize
            color: window.base
            height: textSize*2;
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            radius: window.globalBorderRadius

            Text {
                anchors {
                    left: parent.left
                    right: wizardNavbarTicker.left
                    top: parent.top
                    bottom: parent.bottom
                }
                color: window.text
                text: `${wizardWindow.mi.name} — ${wizard.currentItem.pageTitle}`
                elide: Text.ElideMiddle

                GlobalToolTip {
                    text: parent.text
                    visible: wizardNavbarTitleMs.containsMouse
                }

                font.pointSize: wizardNavbar.textSize
                horizontalAlignment: Text.AlignHCenter
                leftPadding: window.globalPadding
                rightPadding: window.globalPadding
                MouseArea {
                    id: wizardNavbarTitleMs
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Text {
                id: wizardNavbarTicker
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                color: window.text
                text: `(${wizard.currentIndex+1}/${wizard.count})`
                font.pointSize: wizardNavbar.textSize
                horizontalAlignment: Text.AlignRight
                leftPadding: window.globalPadding
                rightPadding: window.globalPadding
            }
        }

        Rectangle {
            color: window.crust
            anchors {
                left: parent.left
                right: parent.right
                top: wizardNavbar.bottom
                bottom: wizardControls.parent.top
            }

            SwipeView {
                id: wizard
                interactive: false
                anchors.fill: parent
                clip: true

                Item {
                    property string pageTitle: "Linking a GitHub Repository"
                    Column {
                        width: parent.width
                        height: parent.height-window.globalPadding*2
                        anchors {
                            centerIn: parent
                        }
                        spacing: window.globalPadding

                        TextEdit {
                            property bool linkHover: false
                            width: parent.width
                            textFormat: Text.MarkdownText
                            text: "1. Go to [_GitHub_](https://github.com/signup)\n2. [_Create a *public* repository_](https://github.com/new). Its name doesn't matter!\n3. Copy the url and paste it in the box below.\n4. Click the `Add file` dropdown, then click `Create new file`.\n5. Name it `modpackupdatemanager.json`, then copy the code from [_here_](https://raw.githubusercontent.com/DatBogie/ModpackUpdateManager-ExamplePack/refs/heads/main/modpackupdatemanager.json) and paste it into the editor, then press `Commit changes` twice."
                            wrapMode: Text.Wrap
                            color: window.text
                            onLinkHovered: link=>{ linkHover = link !== "" }
                            onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                            font.pointSize: window.globalTextSize
                            topPadding: window.globalPadding
                            readOnly: true

                            HoverHandler {
                                cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.IBeamCursor
                            }
                        }

                        TextField {
                            property string outputText: text === ""? "1.0.1" : text
                            id: wizardUrl
                            placeholderText: "Enter GitHub Repo Url (eg. https://github.com/<user>/<name>)..."
                            width: parent.width
                            background: Rectangle {
                                color: wizardWindow.childColor
                                radius: window.globalBorderRadius
                            }
                        }
                    }
                }

                Item {
                    property string pageTitle: "Creating New Versions"
                    Column {
                        width: parent.width
                        height: parent.height-window.globalPadding*2
                        anchors {
                            centerIn: parent
                        }
                        spacing: window.globalPadding

                        TextField {
                            property string outputText: text === ""? "1.0.1" : text
                            id: wizardVersionId
                            placeholderText: "Enter new Version Id (eg. 1.0.1)..."
                            width: parent.width
                            background: Rectangle {
                                color: wizardWindow.childColor
                                radius: window.globalBorderRadius
                            }
                        }

                        TextEdit {
                            property bool linkHover: false
                            width: parent.width
                            textFormat: Text.MarkdownText
                            text: `1. Go to the root of your repo.\n2. Create a new file called \`versions/${wizardVersionId.outputText}/mods/.DS_Store\` and commit.\n3. Click \`Upload files\` under \`Add file\` and upload any mods you're adding to or updating in this new version!`
                            wrapMode: Text.Wrap
                            color: window.text
                            onLinkHovered: link=>{ linkHover = link !== "" }
                            onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                            font.pointSize: window.globalTextSize
                            readOnly: true

                            HoverHandler {
                                cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.IBeamCursor
                            }
                        }
                    }
                }

                Item {
                    property string pageTitle: "Done!"
                    Text {
                        property bool linkHover: false
                        width: parent.width
                        textFormat: Text.MarkdownText
                        text: "- Click `Finish` below to complete the setup."
                        wrapMode: Text.Wrap
                        color: window.text
                        onLinkHovered: link=>{ linkHover = link !== "" }
                        onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                        font.pointSize: window.globalTextSize
                        topPadding: window.globalPadding
                    }
                }
            }
        }

        Rectangle {
            color: window.base
            height: window.globalCtrlSize+window.globalPadding*2
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            radius: window.globalBorderRadius

            RowLayout {
                id: wizardControls
                spacing: window.globalPadding
                height: window.globalCtrlSize
                anchors {
                    left: parent.left
                    right: parent.right
                    centerIn: parent
                }

                Button {
                    id: wizardBackBtn
                    visible: wizard.currentIndex > 0
                    enabled: visible
                    padding: 0
                    property string btnText: "Back"
                    Layout.fillHeight: true
                    background: Rectangle {
                        color: !parent.down? wizardWindow.childColor : wizardWindow.childPressColor
                        radius: window.globalBorderRadius
                    }
                    onClicked: {
                        wizard.currentIndex--;
                    }

                    contentItem: RowLayout {
                        height: parent.height
                        spacing: 0

                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            scale: window.globalIconScale
                            source: "assets/arrow_left_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: parent.parent.btnText
                            horizontalAlignment: Text.AlignLeft
                            color: window.text
                            rightPadding: window.globalPadding
                        }
                    }
                }

                Button {
                    id: wizardNextBtn
                    visible: (wizard.currentIndex !== 0 || wizardUrl.text.startsWith("https://github.com/")) && (wizard.currentIndex < wizard.count-1)
                    enabled: visible
                    padding: 0
                    property string btnText: "Next"
                    Layout.fillHeight: true
                    background: Rectangle {
                        color: !parent.down? wizardWindow.childColor : wizardWindow.childPressColor
                        radius: window.globalBorderRadius
                    }
                    onClicked: wizard.currentIndex++

                    contentItem: RowLayout {
                        height: parent.height
                        spacing: 0

                        Text {
                            text: parent.parent.btnText
                            horizontalAlignment: Text.AlignRight
                            color: window.text
                            leftPadding: window.globalPadding
                        }

                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            scale: window.globalIconScale
                            source: "assets/arrow_right_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                    }
                }

                Button {
                    id: wizardFinishBtn
                    visible: wizard.currentIndex >= wizard.count-1
                    enabled: visible
                    padding: 0
                    property string btnText: "Finish"
                    Layout.fillHeight: true
                    background: Rectangle {
                        color: !parent.down? wizardWindow.childColor : wizardWindow.childPressColor
                        radius: window.globalBorderRadius
                    }
                    onClicked: {
                        wizardWindow.visible = false;
                        wizardWindow.mi.updateUrl = wizardUrl.text;
                        backend.setUpdateUrlProperty(wizardWindow.mi.index, wizardWindow.mi.updateUrl);
                        globalMessageDialog.title = wizardWindow.title;
                        globalMessageDialog.text = `## ${wizardWindow.mi.name}\n\n --- \n\n**Setup ${backend.setupPack(wizardWindow.mi)? "Completed Successfully!" : "Failed!"}**`;
                        globalMessageDialog.visible = true;
                    }

                    contentItem: RowLayout {
                        height: parent.height
                        spacing: 0

                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            scale: window.globalIconScale
                            source: "assets/check_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                            fillMode: Image.PreserveAspectFit
                            MultiEffect {
                                anchors.fill: parent
                                source: parent
                                colorization: 1.0
                                colorizationColor: window.green
                            }
                        }

                        Text {
                            text: parent.parent.btnText
                            horizontalAlignment: Text.AlignLeft
                            color: window.text
                            rightPadding: window.globalPadding
                        }
                    }
                }
            }
        }
    }
}

