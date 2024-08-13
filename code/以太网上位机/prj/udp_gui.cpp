#include<stdio.h>
#include<stdlib.h>
#include <winsock2.h>
#include <WS2tcpip.h>
#include<stdint.h>
#include <opencv2\opencv.hpp> 
#include <opencv2/core/utils/logger.hpp>
#include <QtGui>
#include <QApplication>
#include<time.h>
#include "udp_gui.h"
#include<string.h>

#pragma execution_character_set("utf-8")    //宏定义编码

#pragma comment(lib, "ws2_32.lib")

#define frameWidth 640
#define frameHeight 480

using namespace cv;

udp_gui::udp_gui(QWidget *parent)
    : QWidget(parent)
{
    ui = new Ui::gui_main();
    ui->setupUi(this);
    this->setWindowIcon(QIcon("./icon.ico"));
    this->resize(1024, 640);
    connect(ui->quit, SIGNAL(clicked()), this, SLOT(closeEvent()));
    connect(ui->start, SIGNAL(clicked()), this, SLOT(startEvent()));
    this->globalbreak = 0;
    this->startTrans = 0;

}

udp_gui::~udp_gui()
{
    delete ui;
    ui = nullptr;
}

void udp_gui::closeEvent()
{
    this->close();
}

void udp_gui::startEvent()
{
    if (this->startTrans == 0)
    {
        this->globalbreak = 0;
        this->startTrans = 1;
        ui->start->setText(QString::fromLocal8Bit("停止"));
        this->udpWork();
    }
    else
    {
        this->globalbreak = 1;
        this->startTrans = 0;
        ui->start->setText(QString::fromLocal8Bit("开始"));
    }
}

int udp_gui::udpWork()
{
	
    //qDebug() << "Hello" << 123;
	std::string cstr;
	cstr = std::string((const char*)ui->textLocalIP->text().toLocal8Bit());
	const char* local_ip = cstr.c_str();
	int local_port = ui->textLocalPOrt->text().toInt();
	
    cv::utils::logging::setLogLevel(utils::logging::LOG_LEVEL_SILENT);
    SOCKET mSocket;
    SOCKADDR_IN mLocalAddr;

    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
    {
        printf("WSAStartup error:%d\n", GetLastError());
        return false;
    }

    mSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (mSocket == INVALID_SOCKET)
	{
		closesocket(mSocket);
		mSocket = INVALID_SOCKET;
		printf("Invalid socket!\n");
		return false;
	}

	mLocalAddr.sin_family = AF_INET;
	//mLocalAddr.sin_addr.S_un.S_addr = inet_addr(local_ip);
	inet_pton(AF_INET, local_ip, &mLocalAddr.sin_addr.S_un.S_addr);
	mLocalAddr.sin_port = htons(local_port);

	int ret = bind(mSocket, (sockaddr*)&mLocalAddr, sizeof(SOCKADDR));
	if (ret == SOCKET_ERROR)
	{
		closesocket(mSocket);
		mSocket = INVALID_SOCKET;
		printf("Socket error!\n");
		return false;
	}

	uint16_t* recvBuf = (uint16_t*)malloc(sizeof(uint16_t) * frameHeight * frameWidth + 4);
	uint16_t* frameBuf[480];
	Mat frameMat = Mat::zeros(480, 640, CV_8UC3);
	QImage ImgShow;
	int temp1;
	uint16_t temp2;
	int ii = 0;
	int pckPerFrame = 480;
	int frameBegin = 0;
	int pckId = 0;
	
	while (this->globalbreak==0)
	{
		int recvLen = recvfrom(mSocket, (char*)(recvBuf + pckId * frameWidth), 1288, 0, NULL, NULL);
		//每帧的第一包长度是1288，其余为1280
		if (recvLen == 1288)
		{
			frameBuf[0] = recvBuf + 4;
			frameBegin = 1;
			pckId = 1;

		}
		else if (frameBegin == 1 && pckId < pckPerFrame)
		{
			frameBuf[pckId] = recvBuf + pckId * frameWidth + 4;
			pckId++;
			if (pckId == pckPerFrame)
			{
				frameBegin = 0;
				pckId = 0;
				for (int i = 0; i < 480; i++)
				{
					for (int j = 0; j < 640; j++)
					{
						temp1 = (i * 640 + j) * 3;
						temp2 = *(frameBuf[i] + j);
						frameMat.data[temp1+2] = (temp2 & 0x001f) << 3;
						frameMat.data[temp1 + 1] = (temp2 & 0x07e0) >> 3;
						frameMat.data[temp1] = (temp2 & 0xf800) >> 8;
					}
				}
				ImgShow = QImage((const uchar*)(frameMat.data), frameMat.cols, frameMat.rows, frameMat.cols * frameMat.channels(), QImage::Format_RGB888);
				ui->imageLabel->setPixmap(QPixmap::fromImage(ImgShow));
				waitKey(2);
			}
		}
		else
		{
			frameBegin = 0;
			pckId = 0;
		}

	}
	closesocket(mSocket);
	WSACleanup();

	ui->imageLabel->setPixmap(QPixmap(""));
	
	return true;
}


