#pragma once

#include <QtWidgets/QMainWindow>
#include "ui_udp_gui.h"
#include "ui_gui_main.h"

class udp_gui : public QWidget
{
    Q_OBJECT

public:
    udp_gui(QWidget *parent = nullptr);
    ~udp_gui();
    int globalbreak;
    int startTrans;
    int udpWork(void);
    
public slots:
    void startEvent(void);
    void closeEvent(void);
    

private:
    Ui::gui_main* ui=nullptr;
};
