/********************************************************************************
** Form generated from reading UI file 'gui_main.ui'
**
** Created by: Qt User Interface Compiler version 5.15.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GUI_MAIN_H
#define UI_GUI_MAIN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFrame>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_gui_main
{
public:
    QGridLayout *gridLayout_2;
    QFrame *frame;
    QHBoxLayout *MyGUI_box;
    QVBoxLayout *Mygui_left_box;
    QLabel *system_name;
    QLabel *imageLabel;
    QHBoxLayout *button_box;
    QPushButton *start;
    QPushButton *quit;
    QFrame *line;
    QVBoxLayout *main_right_box;
    QLabel *timelabel;
    QGridLayout *gridLayout;
    QLineEdit *textRPort;
    QLineEdit *textRIP;
    QLabel *remotePort;
    QLineEdit *textLocalIP;
    QLabel *remoteIP;
    QLabel *localIP;
    QLabel *localPort;
    QLineEdit *textLocalPOrt;
    QVBoxLayout *people_signed_table_box;
    QLabel *figLabel1;
    QVBoxLayout *people_unsigned_box;
    QLabel *figLabel2;

    void setupUi(QWidget *gui_main)
    {
        if (gui_main->objectName().isEmpty())
            gui_main->setObjectName(QString::fromUtf8("gui_main"));
        gui_main->resize(1024, 746);
        gui_main->setMinimumSize(QSize(1024, 640));
        QFont font;
        font.setPointSize(11);
        font.setBold(true);
        //font.setWeight(75);
        gui_main->setFont(font);
        gridLayout_2 = new QGridLayout(gui_main);
        gridLayout_2->setObjectName(QString::fromUtf8("gridLayout_2"));
        frame = new QFrame(gui_main);
        frame->setObjectName(QString::fromUtf8("frame"));
        frame->setStyleSheet(QString::fromUtf8("border-image:url(:/images/back.png)"));
        frame->setFrameShape(QFrame::StyledPanel);
        frame->setFrameShadow(QFrame::Raised);

        gridLayout_2->addWidget(frame, 0, 0, 2, 2);

        MyGUI_box = new QHBoxLayout();
        MyGUI_box->setObjectName(QString::fromUtf8("MyGUI_box"));
        Mygui_left_box = new QVBoxLayout();
        Mygui_left_box->setObjectName(QString::fromUtf8("Mygui_left_box"));
        system_name = new QLabel(gui_main);
        system_name->setObjectName(QString::fromUtf8("system_name"));
        system_name->setMaximumSize(QSize(16777215, 80));
        QFont font1;
        font1.setPointSize(26);
        font1.setBold(true);
        font1.setItalic(false);
        //font1.setWeight(75);
        font1.setKerning(true);
        system_name->setFont(font1);
        system_name->setLayoutDirection(Qt::LeftToRight);
        system_name->setAutoFillBackground(true);
        system_name->setStyleSheet(QString::fromUtf8("border-image:rgb(0, 255, 255)"));
        system_name->setAlignment(Qt::AlignCenter);
        system_name->setOpenExternalLinks(true);

        Mygui_left_box->addWidget(system_name);

        imageLabel = new QLabel(gui_main);
        imageLabel->setObjectName(QString::fromUtf8("imageLabel"));
        imageLabel->setMinimumSize(QSize(640, 480));
        imageLabel->setMaximumSize(QSize(640, 480));
        imageLabel->setFrameShape(QFrame::Panel);
        imageLabel->setFrameShadow(QFrame::Plain);
        imageLabel->setLineWidth(2);

        Mygui_left_box->addWidget(imageLabel);

        button_box = new QHBoxLayout();
        button_box->setObjectName(QString::fromUtf8("button_box"));
        start = new QPushButton(gui_main);
        start->setObjectName(QString::fromUtf8("start"));
        start->setFont(font);

        button_box->addWidget(start);

        quit = new QPushButton(gui_main);
        quit->setObjectName(QString::fromUtf8("quit"));
        quit->setFont(font);

        button_box->addWidget(quit);


        Mygui_left_box->addLayout(button_box);

        Mygui_left_box->setStretch(0, 1);
        Mygui_left_box->setStretch(1, 8);
        Mygui_left_box->setStretch(2, 1);

        MyGUI_box->addLayout(Mygui_left_box);

        line = new QFrame(gui_main);
        line->setObjectName(QString::fromUtf8("line"));
        line->setFrameShape(QFrame::VLine);
        line->setFrameShadow(QFrame::Sunken);

        MyGUI_box->addWidget(line);

        main_right_box = new QVBoxLayout();
        main_right_box->setSpacing(8);
        main_right_box->setObjectName(QString::fromUtf8("main_right_box"));
        main_right_box->setContentsMargins(0, 0, 0, 0);
        timelabel = new QLabel(gui_main);
        timelabel->setObjectName(QString::fromUtf8("timelabel"));
        timelabel->setMinimumSize(QSize(290, 0));
        timelabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        timelabel->setIndent(-1);

        main_right_box->addWidget(timelabel);

        gridLayout = new QGridLayout();
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        textRPort = new QLineEdit(gui_main);
        textRPort->setObjectName(QString::fromUtf8("textRPort"));

        gridLayout->addWidget(textRPort, 1, 1, 1, 1);

        textRIP = new QLineEdit(gui_main);
        textRIP->setObjectName(QString::fromUtf8("textRIP"));

        gridLayout->addWidget(textRIP, 0, 1, 1, 1);

        remotePort = new QLabel(gui_main);
        remotePort->setObjectName(QString::fromUtf8("remotePort"));
        remotePort->setMaximumSize(QSize(120, 16777215));
        remotePort->setFont(font);

        gridLayout->addWidget(remotePort, 1, 0, 1, 1);

        textLocalIP = new QLineEdit(gui_main);
        textLocalIP->setObjectName(QString::fromUtf8("textLocalIP"));

        gridLayout->addWidget(textLocalIP, 2, 1, 1, 1);

        remoteIP = new QLabel(gui_main);
        remoteIP->setObjectName(QString::fromUtf8("remoteIP"));
        remoteIP->setMaximumSize(QSize(120, 16777215));

        gridLayout->addWidget(remoteIP, 0, 0, 1, 1);

        localIP = new QLabel(gui_main);
        localIP->setObjectName(QString::fromUtf8("localIP"));

        gridLayout->addWidget(localIP, 2, 0, 1, 1);

        localPort = new QLabel(gui_main);
        localPort->setObjectName(QString::fromUtf8("localPort"));

        gridLayout->addWidget(localPort, 3, 0, 1, 1);

        textLocalPOrt = new QLineEdit(gui_main);
        textLocalPOrt->setObjectName(QString::fromUtf8("textLocalPOrt"));

        gridLayout->addWidget(textLocalPOrt, 3, 1, 1, 1);


        main_right_box->addLayout(gridLayout);

        people_signed_table_box = new QVBoxLayout();
        people_signed_table_box->setSpacing(5);
        people_signed_table_box->setObjectName(QString::fromUtf8("people_signed_table_box"));
        people_signed_table_box->setContentsMargins(2, 0, 2, -1);
        figLabel1 = new QLabel(gui_main);
        figLabel1->setObjectName(QString::fromUtf8("figLabel1"));
        figLabel1->setMinimumSize(QSize(0, 280));

        people_signed_table_box->addWidget(figLabel1);


        main_right_box->addLayout(people_signed_table_box);

        people_unsigned_box = new QVBoxLayout();
        people_unsigned_box->setObjectName(QString::fromUtf8("people_unsigned_box"));
        people_unsigned_box->setContentsMargins(2, 0, 2, -1);
        figLabel2 = new QLabel(gui_main);
        figLabel2->setObjectName(QString::fromUtf8("figLabel2"));
        figLabel2->setMinimumSize(QSize(0, 280));

        people_unsigned_box->addWidget(figLabel2);


        main_right_box->addLayout(people_unsigned_box);


        MyGUI_box->addLayout(main_right_box);

        MyGUI_box->setStretch(0, 6);
        MyGUI_box->setStretch(1, 1);
        MyGUI_box->setStretch(2, 4);

        gridLayout_2->addLayout(MyGUI_box, 1, 1, 1, 1);


        retranslateUi(gui_main);

        QMetaObject::connectSlotsByName(gui_main);
    } // setupUi

    void retranslateUi(QWidget *gui_main)
    {
        gui_main->setWindowTitle(QCoreApplication::translate("gui_main", "\344\273\245\345\244\252\347\275\221\344\270\212\344\275\215\346\234\272", nullptr));
        system_name->setText(QCoreApplication::translate("gui_main", "\344\273\245\345\244\252\347\275\221\344\270\212\344\275\215\346\234\272", nullptr));
        imageLabel->setText(QString());
        start->setText(QCoreApplication::translate("gui_main", "\345\274\200\345\247\213", nullptr));
        quit->setText(QCoreApplication::translate("gui_main", "\351\200\200\345\207\272", nullptr));
        timelabel->setText(QCoreApplication::translate("gui_main", "TextLabel", nullptr));
        textRPort->setText(QCoreApplication::translate("gui_main", "1234", nullptr));
        textRIP->setText(QCoreApplication::translate("gui_main", "192.168.1.10", nullptr));
        remotePort->setText(QCoreApplication::translate("gui_main", "remote port", nullptr));
        textLocalIP->setText(QCoreApplication::translate("gui_main", "192.168.1.102", nullptr));
        remoteIP->setText(QCoreApplication::translate("gui_main", " remote IP", nullptr));
        localIP->setText(QCoreApplication::translate("gui_main", "local IP", nullptr));
        localPort->setText(QCoreApplication::translate("gui_main", "local port", nullptr));
        textLocalPOrt->setText(QCoreApplication::translate("gui_main", "1234", nullptr));
        figLabel1->setText(QString());
        figLabel2->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class gui_main: public Ui_gui_main {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GUI_MAIN_H
