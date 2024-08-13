#include "udp_gui.h"
#include <QtWidgets/QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    udp_gui w;
    w.setStyleSheet("QFrame#myframe{border-image:url(images/back.png)}");
    w.show();
    return a.exec();
}
