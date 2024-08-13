/********************************************************************************
** Form generated from reading UI file 'udp_gui.ui'
**
** Created by: Qt User Interface Compiler version 6.7.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_UDP_GUI_H
#define UI_UDP_GUI_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_udp_guiClass
{
public:
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QWidget *centralWidget;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *udp_guiClass)
    {
        if (udp_guiClass->objectName().isEmpty())
            udp_guiClass->setObjectName("udp_guiClass");
        udp_guiClass->resize(600, 400);
        menuBar = new QMenuBar(udp_guiClass);
        menuBar->setObjectName("menuBar");
        udp_guiClass->setMenuBar(menuBar);
        mainToolBar = new QToolBar(udp_guiClass);
        mainToolBar->setObjectName("mainToolBar");
        udp_guiClass->addToolBar(mainToolBar);
        centralWidget = new QWidget(udp_guiClass);
        centralWidget->setObjectName("centralWidget");
        udp_guiClass->setCentralWidget(centralWidget);
        statusBar = new QStatusBar(udp_guiClass);
        statusBar->setObjectName("statusBar");
        udp_guiClass->setStatusBar(statusBar);

        retranslateUi(udp_guiClass);

        QMetaObject::connectSlotsByName(udp_guiClass);
    } // setupUi

    void retranslateUi(QMainWindow *udp_guiClass)
    {
        udp_guiClass->setWindowTitle(QCoreApplication::translate("udp_guiClass", "udp_gui", nullptr));
    } // retranslateUi

};

namespace Ui {
    class udp_guiClass: public Ui_udp_guiClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_UDP_GUI_H
