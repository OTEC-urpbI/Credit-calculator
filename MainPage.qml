import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    // Градиентный фон
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#6a11cb" }
            GradientStop { position: 1.0; color: "#2575fc" }
        }
        opacity: 0.9
    }

    // Состояния страницы
    property bool isLoggedIn: false
    property string currentUser:  ""

    // Данные банков
    property var banks: [
        { name: "Сбербанк", rate: 7.1 },
        { name: "Т-Банк", rate: 7.5 },
        { name: "ВТБ", rate: 7.3 },
        { name: "Газпромбанк", rate: 7.4 },
        { name: "Альфа-Банк", rate: 7.6 }
    ]

    // Главный контейнер
    Column {
        width: Math.min(parent.width * 0.9, 600)
        anchors.centerIn: parent
        spacing: Theme.paddingLarge

        // Лоадер для динамической загрузки интерфейса
        Loader {
            id: pageLoader
            width: parent.width
            sourceComponent: isLoggedIn ? calculatorComponent : loginComponent

            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }
    }

    // Компонент для авторизации
    Component {
        id: loginComponent
        Column {
            width: parent.width
            spacing: Theme.paddingLarge

            // Заголовок
            Label {
                text: qsTr("Авторизация")
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                color: Theme.primaryColor
                font.bold: true
            }

            // Поле для логина
            TextField {
                id: loginField
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Логин")
                label: qsTr("Введите логин")
                color: Theme.primaryColor

                background: Rectangle {
                    radius: height / 2
                    color: Theme.secondaryColor
                    border.color: Theme.highlightColor
                    border.width: 2
                }
            }

            // Поле для пароля
            TextField {
                id: passwordField
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Пароль")
                label: qsTr("Введите пароль")
                echoMode: TextInput.Password
                color: Theme.primaryColor

                background: Rectangle {
                    radius: height / 2
                    color: Theme.secondaryColor
                    border.color: Theme.highlightColor
                    border.width: 2
                }
            }

            // Кнопка входа
            Button {
                text: qsTr("Войти")
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor

                Rectangle {
                    radius: height / 2
                    color: Theme.highlightColor
                }

                onClicked: {
                    if (loginField.text === "user" && passwordField.text === "1234") {
                        isLoggedIn = true
                        currentUser  = loginField.text
                    } else {
                        console.log("Неверный логин или пароль")
                    }
                }
            }

            // Кнопка сброса пароля
            Button {
                text: qsTr("Сбросить пароль")
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor

                Rectangle {
                    radius: height / 2
                    color: Theme.secondaryColor
                }

                onClicked: {
                    var email = "user@example.com"
                    console.log("Запрос на сброс пароля отправлен на: " + email)
                }
            }
        }
    }

    // Компонент для калькулятора
    Component {
        id: calculatorComponent
        Column {
            width: parent.width
            spacing: Theme.paddingLarge

            // Заголовок
            Label {
                text: qsTr("Ипотечный калькулятор")
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                color: Theme.primaryColor
                font.bold: true
            }

            // Поле для ввода суммы кредита
            TextField {
                id: loanAmount
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Сумма кредита (руб)")
                label: qsTr("Сумма кредита")
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                color: Theme.primaryColor

                validator: DoubleValidator {
                    bottom: 0
                    top: 100000000
                    decimals: 2
                }

                background: Rectangle {
                    radius: height / 2
                    color: Theme.secondaryColor
                    border.color: Theme.highlightColor
                    border.width: 2
                }
            }

            // Поле для ввода срока кредита
            TextField {
                id: loanTerm
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Срок (лет)")
                label: qsTr("Срок кредита")
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                color: Theme.primaryColor

                validator: IntValidator {
                    bottom: 1
                    top: 30
                }

                background: Rectangle {
                    radius: height / 2
                    color: Theme.secondaryColor
                    border.color: Theme.highlightColor
                    border.width: 2
                }
            }

            // Выбор банка
            Label {
                text: qsTr("Выберите банк")
                width: parent.width
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
            }

            // Индекс выбранного банка
            property int currentIndex: -1

            Column {
                width: parent.width
                spacing: Theme.paddingMedium

                Repeater {
                    model: banks
                    delegate: Rectangle {
                        width: parent.width
                        height: 60
                        radius: 10
                        color: index === currentIndex ? Theme.highlightColor : Theme.secondaryColor

                        Row {
                            anchors.fill: parent
                            anchors.margins: Theme.paddingMedium
                            spacing: Theme.paddingMedium

                            Label {
                                text: modelData.name
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.primaryColor
                            }

                            Label {
                                text: modelData.rate + "%"
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.primaryColor
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: currentIndex = index
                        }
                    }
                }
            }

            // Кнопка расчета
            Button {
                text: qsTr("Рассчитать")
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor

                Rectangle {
                    radius: height / 2
                    color: Theme.highlightColor
                }

                onClicked: {
                    if (currentIndex === -1) {
                        console.log("Пожалуйста, выберите банк")
                        return
                    }

                    var amount = parseFloat(loanAmount.text)
                    var term = parseFloat(loanTerm.text)
                    var rate = banks[currentIndex].rate / 100
                    var bank = banks[currentIndex].name

                    var monthlyRate = rate / 12
                    var numberOfPayments = term * 12

                    // Формула аннуитетного платежа
                    var monthlyPayment = amount * (monthlyRate * Math.pow(1 + monthlyRate, numberOfPayments)) / (Math.pow(1 + monthlyRate, numberOfPayments) - 1)
                    var totalPayment = monthlyPayment * numberOfPayments
                    var overpayment = totalPayment - amount

                    // Отображение результатов
                    results.monthlyPayment = monthlyPayment.toFixed(2)
                    results.totalPayment = totalPayment.toFixed(2)
                    results.overpayment = overpayment.toFixed(2)
                    results.bankName = bank
                    results.opacity = 1
                }
            }

            // Блок с результатами
            Column {
                id: results
                width: parent.width
                spacing: Theme.paddingMedium
                opacity: 0
                visible: opacity > 0

                property string monthlyPayment: "0"
                property string totalPayment: "0"
                property string overpayment: "0"
                property string bankName: ""

                Behavior on opacity {
                    NumberAnimation { duration: 500 }
                }

                Label {
                    text: qsTr("Банк: ") + results.bankName
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                }

                Label {
                    text: qsTr("Ежемесячный платеж: ") + results.monthlyPayment + qsTr(" руб")
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                }

                Label {
                    text: qsTr("Общая выплата: ") + results.totalPayment + qsTr(" руб")
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                }

                Label {
                    text: qsTr("Переплата: ") + results.overpayment + qsTr(" руб")
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                }
            }

            // Кнопка выхода
            Button {
                text: qsTr("Выйти")
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor

                Rectangle {
                    radius: height / 2
                    color: Theme.secondaryColor
                }

                onClicked: {
                    isLoggedIn = false
                    currentUser  = ""
                }
            }
        }
    }
}
