#include <stdio.h>
#include<stdlib.h>
#include "hbirdv2.h"
#include "hbirdv2_gpio.h"


#define RCV_VOlP        1<<0
#define RCV_VOlN        1<<1
#define RCV_PLAY 		1<<2
#define RCV_BACK 		1<<3
#define RCV_UP 			1<<4
#define RCV_DOWN 		1<<5
#define RCV_LEFT 		1<<6
#define RCV_RIGHT 		1<<7



#define PS2_SELECT      1<<8
#define PS2_L3          1<<9
#define PS2_R3        	1<<10
#define PS2_START       1<<11
#define PS2_UP          1<<12
#define PS2_RIGHT       1<<13
#define PS2_DOWN        1<<14
#define PS2_LEFT        1<<15

#define PS2_L2          1<<24
#define PS2_R2          1<<25
#define PS2_L1        	1<<26
#define PS2_R1          1<<27
#define PS2_Y           1<<28
#define PS2_B           1<<29
#define PS2_A           1<<30
#define PS2_X           1<<31


#define PS2_Y_In GPIOA->PADIN & PS2_Y
#define PS2_B_In GPIOA->PADIN & PS2_B
#define PS2_A_In GPIOA->PADIN & PS2_A
#define PS2_X_In GPIOA->PADIN & PS2_X
#define PS2_UP_In GPIOA->PADIN & PS2_UP
#define PS2_DOWN_In GPIOA->PADIN & PS2_DOWN
#define PS2_LEFT_In GPIOA->PADIN & PS2_LEFT
#define PS2_RIGHT_In GPIOA->PADIN & PS2_RIGHT
#define PS2_SELECT_In GPIOA->PADIN & PS2_SELECT
#define PS2_START_In GPIOA->PADIN & PS2_START


#define BLUE			0x001f
#define RED				0xf800
#define GREEN			0x07e0
#define BLACK			0x0000
#define WHITE			0xffff


#define BRED             0XF81F
#define GRED 			 0XFFE0
#define GBLUE			 0X07FF
#define MAGENTA       	 0xF81F
#define CYAN          	 0x7FFF
#define YELLOW        	 0xFFE0
#define BROWN 			 0XBC40 //棕色
#define BRRED 			 0XFC07 //棕红色
#define GRAY  			 0X8430 //灰色
#define DARKBLUE      	 0X01CF	//深蓝色
#define LIGHTBLUE      	 0X7D7C	//浅蓝色  
#define GRAYBLUE       	 0X5458 //灰蓝色
#define LIGHTGREEN     	 0X841F //浅绿色
#define LGRAY 			 0XC618 //浅灰色(PANNEL),窗体背景色
#define LGRAYBLUE        0XA651 //浅灰蓝色(中间层颜色)
#define LBBLUE           0X2B12 //浅棕蓝色(选择条目的反色)





#define LCD_H_MAX 480
#define LCD_W_MAX 640
#define LCD_W_MAX_HALF 320

extern uint16_t*LCD_P;
extern uint16_t POINT_COLOR;
extern uint16_t BACK_COLOR;
extern volatile uint8_t key_data;
extern uint8_t falg_scankey;

void switch_game(void);
/*
extern volatile float dataR[1024];
extern volatile float dataI[1024];
extern float dataA[1024];
extern uint16_t adcDataBuf[sampleLength];
extern uint8_t TriPos;
extern uint32_t WaveFreq;
extern uint32_t WaveLengthSum;
extern uint8_t WaveLengthSumNum;
extern uint8_t display_fft;
extern uint16_t triLevel;
extern uint8_t sampleRate_set;


*/