
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Window {
    id: root

    title: "Calculator :D"
    width: 320
    height: 440
    visible: false
    color: "#1e1e2e"
    flags: Qt.Window | Qt.WindowStaysOnTopHint

    property string expression: ""
    property string result: "0"

    function calculate(source) {
        let pos = 0

        function spaces() {
            while (pos < source.length && source[pos] === " ")
                pos++
        }

        function primary() {
            spaces()

            if (source[pos] === "(") {
                pos++
                let value = sum()
                spaces()
                if (source[pos++] !== ")")
                    throw new Error("Missing )")
                return value
            }

            let match = source.slice(pos).match(
                /^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?/
            )
            if (!match)
                throw new Error("Expected a number")

            pos += match[0].length
            return Number(match[0])
        }

        function unary() {
            spaces()
            if (source[pos] === "+") {
                pos++
                return unary()
            }
            if (source[pos] === "-") {
                pos++
                return -unary()
            }
            return primary()
        }

        function product() {
            let value = unary()
            while (true) {
                spaces()
                let op = source[pos]
                if (op !== "*" && op !== "/" && op !== "%")
                    break
                pos++
                let rhs = unary()
                if ((op === "/" || op === "%") && rhs === 0)
                    throw new Error("Division by zero")
                if (op === "*") value *= rhs
                if (op === "/") value /= rhs
                if (op === "%") value %= rhs
            }
            return value
        }

        function sum() {
            let value = product()
            while (true) {
                spaces()
                let op = source[pos]
                if (op !== "+" && op !== "-")
                    break
                pos++
                let rhs = product()
                value = op === "+" ? value + rhs : value - rhs
            }
            return value
        }

        let value = sum()
        spaces()

        if (pos !== source.length || !Number.isFinite(value))
            throw new Error("Invalid expression")

        return Number(value.toPrecision(12)).toString()
    }

    function updateResult() {
        if (!expression.length) {
            result = "0"
            return
        }

        try {
            result = calculate(expression)
        } catch (e) {
            result = "…"
        }
    }

    function press(key) {
        if (key === "AC") {
            expression = ""
        } else if (key === "⌫") {
            expression = expression.slice(0, -1)
        } else if (key === "=") {
            try {
                expression = calculate(expression)
            } catch (e) {
                result = "Error"
                return
            }
        } else {
            expression += key
        }
        updateResult()
    }

    onVisibleChanged: {
        if (visible)
            forceActiveFocus()
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            press("=")
            event.accepted = true
        } else if (event.key === Qt.Key_Backspace) {
            press("⌫")
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            visible = false
            event.accepted = true
        } else if (event.key === Qt.Key_Delete) {
            press("AC")
            event.accepted = true
        } else {
            let key = event.text
            if ("0123456789.+-*/%()".includes(key)) {
                press(key)
                event.accepted = true
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Label {
            text: "TacoCalc"
            color: "#cba6f7"
            font.pixelSize: 20
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: 12
            color: "#181825"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Label {
                    Layout.fillWidth: true
                    text: root.expression || "0"
                    color: "#a6adc8"
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 16
                    elide: Text.ElideLeft
                }

                Label {
                    Layout.fillWidth: true
                    text: root.result
                    color: "#cdd6f4"
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 28
                    font.bold: true
                    elide: Text.ElideLeft
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 4
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: [
                    "AC", "(", ")", "⌫",
                    "7", "8", "9", "/",
                    "4", "5", "6", "*",
                    "1", "2", "3", "-",
                    "0", ".", "%", "+",
                    "="
                ]

                Button {
                    required property string modelData
                    text: modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: modelData === "=" ? 4 : 1

                    background: Rectangle {
                        radius: 8
                        color: modelData === "=" ? "#cba6f7"
                             : ["+", "-", "*", "/", "%", "(", ")"].includes(modelData)
                               ? "#313244" : "#45475a"
                    }

                    contentItem: Text {
                        text: parent.text
                        color: modelData === "=" ? "#1e1e2e" : "#cdd6f4"
                        font.pixelSize: 18
                        font.bold: modelData === "="
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: root.press(modelData)
                }
            }
        }
    }
}

