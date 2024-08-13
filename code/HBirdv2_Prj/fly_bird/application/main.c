
#include "global.h"
#include "hbird_sdk_soc.h"
#include "lcd.h"
#include "system.h"

//void led_test();
void	ps2_init(void);
void 	plic_init(void);
void 	plic_btn_handler(void);


//LCD基地址
uint16_t*LCD_P=(uint16_t*)0x80200000;
volatile uint8_t key_data=0;
uint16_t POINT_COLOR=0x0000;	//画笔颜色
uint16_t BACK_COLOR=0xFFFF;  //背景色 

volatile uint8_t switchGameChart=0;

volatile uint8_t LCDinverse=0;

int main(void)
{
	ps2_init();
	plic_init();		//外部中断初始化
    LCD_Clear(WHITE);
    //游戏入口函数，在system.c文件中
    game_flappy_bird_main();
	while(1)
	{
		
	}
    return 0;
}

/*
void led_test()
{
	uint32_t mask = LED0| LED1| LED2| LED3;
	gpio_enable_output(GPIOA, mask);
	LED0_SET;
	LED1_CLR;
	LED2_SET;
	LED3_CLR;
}
*/
void ps2_init()
{
    int mask=0xff00ff00;
    gpio_enable_input(GPIOA, mask);
}

void plic_init()
{
    int mask=RCV_UP | RCV_DOWN | RCV_LEFT |RCV_RIGHT|RCV_PLAY|RCV_BACK |RCV_VOlP|RCV_VOlN;
    gpio_enable_input(GPIOA, mask);
    gpio_enable_interrupt(GPIOA, mask, GPIO_INT_RISE);			//使能中断
    PLIC_Register_IRQ(PLIC_GPIOA_IRQn, 1, plic_btn_handler);	//注册中断发生的处理函数
    __enable_irq();												//全局中断开始

}

void plic_btn_handler(void)
{
    int mask;
    mask = gpio_clear_interrupt(GPIOA);	//清楚中断标志，并返回中断值

    if(mask==RCV_UP)	//红外按键:上
    {
    	key_data=1;
    }
    else if (mask==RCV_DOWN)	//红外按键:下
    {
    	key_data=2;
    }
    else if(mask==RCV_LEFT)		//红外按键:左
    {
    	key_data=3;
    }
    else if(mask==RCV_RIGHT)	//红外按键:右
    {
		key_data=4;
    }
	else if(mask==RCV_PLAY)			//红外按键:开始
	{
		//printf("5\n");
		key_data=5;
	}
	else if(mask==RCV_BACK)			//红外按键:返回
	{
		//switch_game();
		key_data=6;
	}
	else if(mask==RCV_VOlP)			//音量+
	{
		//printf("7\n");
		key_data=7;

	}
	else if(mask==RCV_VOlN)			//音量-
	{
		//printf("8\n");
		key_data=8;
	}
}



