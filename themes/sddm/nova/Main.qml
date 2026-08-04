/*
 * NovaOS SDDM Theme - Main.qml
 * Gaming-focused login screen
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.15

// Theme colors
Item {
    id: themeRoot
    property color novaPurple: "#0a0a14"
    property color novaBlue: "#0f3460"
    property color novaPink: "#e94560"
    property color novaCyan: "#00d4ff"
    property color textPrimary: "#ffffff"
    property color textSecondary: "#aaaaaa"
    
    // Background gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: novaPurple }
            GradientStop { position: 1.0; color: novaBlue }
        }
        
        // Background image overlay
        Image {
            anchors.fill: parent
            source: config.background || ""
            fillMode: Image.Stretch
            opacity: 0.3
        }
        
        // Subtle grid pattern overlay
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.03);
                ctx.lineWidth = 1;
                
                // Vertical lines
                for (var x = 0; x < width; x += 40) {
                    ctx.beginPath();
                    ctx.moveTo(x, 0);
                    ctx.lineTo(x, height);
                    ctx.stroke();
                }
                
                // Horizontal lines
                for (var y = 0; y < height; y += 40) {
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(width, y);
                    ctx.stroke();
                }
            }
        }
    }
    
    // Main content area
    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        
        // Top spacer
        Item { Layout.fillHeight: true }
        
        // Logo and title
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            
            Image {
                id: logo
                Layout.preferredWidth: 120
                Layout.preferredHeight: 120
                source: config.logo || ""
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Glow effect
                layer.enabled: true
                layer.effect: Glow {
                    color: novaPink
                    radius: 20
                    samples: 25
                }
            }
            
            Text {
                text: "NovaOS"
                color: textPrimary
                font.pixelSize: 48
                font.weight: Font.Light
                font.family: "Noto Sans"
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Text shadow
                layer.enabled: true
                layer.effect: DropShadow {
                    color: novaPink
                    radius: 15
                    samples: 20
                    spread: 0.5
                }
            }
            
            Text {
                text: "Gaming Edition"
                color: novaPink
                font.pixelSize: 14
                font.weight: Font.Medium
                font.family: "Noto Sans"
                anchors.horizontalCenter: parent.horizontalCenter
                letterSpacing: 4
            }
        }
        
        // Login form
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 400
            Layout.preferredHeight: loginColumn.height + 40
            Layout.maximumHeight: parent.height * 0.5
            
            color: Qt.rgba(0.1, 0.1, 0.15, 0.8)
            radius: 15
            border.width: 1
            border.color: novaPink
            
            // Inner glow
            layer.enabled: true
            layer.effect: Glow {
                color: novaPink
                radius: 10
                samples: 15
                spread: 0.3
            }
            
            ColumnLayout {
                id: loginColumn
                anchors.centerIn: parent
                spacing: 15
                
                // Username field
                TextField {
                    id: usernameField
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 50
                    placeholderText: "Username"
                    text: userModel.lastUser
                    font.pixelSize: 16
                    font.family: "Noto Sans"
                    color: textPrimary
                    selectionColor: novaPink
                    
                    background: Rectangle {
                        color: Qt.rgba(0.05, 0.05, 0.1, 0.8)
                        radius: 8
                        border.width: usernameField.activeFocus ? 2 : 1
                        border.color: usernameField.activeFocus ? novaPink : novaBlue
                    }
                    
                    Keys.onEnterPressed: passwordField.forceActiveFocus()
                }
                
                // Password field
                TextField {
                    id: passwordField
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 50
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    font.pixelSize: 16
                    font.family: "Noto Sans"
                    color: textPrimary
                    selectionColor: novaPink
                    
                    background: Rectangle {
                        color: Qt.rgba(0.05, 0.05, 0.1, 0.8)
                        radius: 8
                        border.width: passwordField.activeFocus ? 2 : 1
                        border.color: passwordField.activeFocus ? novaPink : novaBlue
                    }
                    
                    Keys.onEnterPressed: sddm.login(usernameField.text, passwordField.text, sessionModel.lastIndex)
                }
                
                // Login button
                Button {
                    id: loginButton
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 50
                    text: "Login"
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    font.family: "Noto Sans"
                    
                    contentItem: Text {
                        text: parent.text
                        color: textPrimary
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    background: Rectangle {
                        color: novaPink
                        radius: 8
                        
                        // Hover/press states
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                    
                    onClicked: sddm.login(usernameField.text, passwordField.text, sessionModel.lastIndex)
                    
                    // Glow on hover
                    layer.enabled: loginButton.hovered
                    layer.effect: Glow {
                        color: novaPink
                        radius: 15
                        samples: 20
                    }
                }
                
                // Session selector
                ComboBox {
                    id: sessionCombo
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 40
                    model: sessionModel
                    currentIndex: sessionModel.lastIndex
                    
                    contentItem: Text {
                        text: sessionCombo.currentText
                        color: textPrimary
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 15
                    }
                    
                    background: Rectangle {
                        color: Qt.rgba(0.05, 0.05, 0.1, 0.8)
                        radius: 8
                        border.width: 1
                        border.color: novaBlue
                    }
                    
                    delegate: ItemDelegate {
                        width: sessionCombo.width
                        contentItem: Text {
                            text: modelData
                            color: textPrimary
                            font.pixelSize: 14
                        }
                        background: Rectangle {
                            color: modelData === sessionCombo.currentText ? novaBlue : "transparent"
                        }
                    }
                }
            }
        }
        
        // Bottom action bar
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 30
            spacing: 20
            
            // Power buttons
            Repeater {
                model: [
                    { icon: "➊", action: "sddm.reboot()", tooltip: "Reboot" },
                    { icon: "⏻", action: "sddm.powerOff()", tooltip: "Shutdown" }
                ]
                
                ToolButton {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    text: modelData.icon
                    font.pixelSize: 20
                    palette.buttonText: textSecondary
                    
                    background: Rectangle {
                        color: Qt.rgba(0.1, 0.1, 0.15, 0.5)
                        radius: 8
                    }
                    
                    onClicked: eval(modelData.action)
                    
                    ToolTip.text: modelData.tooltip
                    ToolTip.visible: hovered
                }
            }
        }
        
        // Bottom spacer
        Item { Layout.fillHeight: true }
    }
    
    // Clock (top right)
    Column {
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 30
        spacing: 5
        
        Text {
            id: timeText
            text: new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
            color: textPrimary
            font.pixelSize: 48
            font.weight: Font.Light
            font.family: "Noto Sans"
        }
        
        Text {
            text: new Date().toLocaleDateString(Qt.locale(), "dddd, MMMM d")
            color: textSecondary
            font.pixelSize: 14
            font.family: "Noto Sans"
        }
        
        // Update clock
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                timeText.text = new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
            }
        }
    }
    
    // User list (left side)
    ListView {
        id: userList
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        width: 200
        height: 300
        model: userModel
        spacing: 10
        
        // Hide if only one user or no users
        visible: count > 1
        
        delegate: Item {
            width: userList.width
            height: 60
            
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0.1, 0.1, 0.15, 0.6)
                radius: 10
                border.width: 1
                border.color: index === userList.currentIndex ? novaPink : "transparent"
                
                // Glow on selection
                layer.enabled: index === userList.currentIndex
                layer.effect: Glow {
                    color: novaPink
                    radius: 10
                    samples: 15
                }
            }
            
            Item {
                anchors.fill: parent
                anchors.margins: 10
                
                // Avatar placeholder
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: novaPink
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData.name ? modelData.name[0].toUpperCase() : "?"
                        color: textPrimary
                        font.pixelSize: 20
                        font.weight: Font.Bold
                    }
                }
                
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 55
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.name || ""
                    color: textPrimary
                    font.pixelSize: 16
                    font.family: "Noto Sans"
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    userList.currentIndex = index
                    usernameField.text = modelData.name
                    passwordField.forceActiveFocus()
                }
            }
        }
    }
}
