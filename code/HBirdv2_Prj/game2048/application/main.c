
#include "global.h"
#include "hbird_sdk_soc.h"
#include "lcd.h"
#include "palette.h"
#include"system.h"

void	ps2_init(void);
void plic_init(void);
void plic_btn_handler(void);



//LCD基地址
uint16_t*LCD_P=(uint16_t*)0x80200000; 
volatile uint8_t key_data=0;
uint16_t POINT_COLOR=0x0000;	//画笔颜色
uint16_t BACK_COLOR=0xFFFF;  //背景色 

volatile uint32_t  score = 0;										//计分变量
char score_buff[4] = {0};   						//计分数组

volatile uint8_t GameOver_Flag = 0;
volatile uint8_t Update_Flag = 0; 

volatile uint8_t switchGameChart=0;

int main(void)
{
    ps2_init();
	plic_init();		//外部中断初始化
    game_init();
    game_main();
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
        //printf("1\n");
        //Move_Up();
        //Update_Flag=1;
    }
    else if (mask==RCV_DOWN)	//红外按键:下
    {
        key_data=2;
        //printf("2\n");
    	//Update_Flag=1;
        //Move_Down();
		//Random_Funcation();
    }
    else if(mask==RCV_LEFT)		//红外按键:左
    {
        key_data=3;
        //printf("3\n"); 
        //Move_Left();
    	//Update_Flag=1;
    }
    else if(mask==RCV_RIGHT)	//红外按键:右
    {
        key_data=4;
        //printf("4\n");
        //Move_Right();
		//Update_Flag=1;
    }
	else if(mask==RCV_PLAY)			//红外按键:开始
	{
        //printf("5\n");
        //game_init();
		key_data=5;
	}
	else if(mask==RCV_BACK)			//红外按键:返回
	{
		//printf("6\n");
		key_data=6;
	}
	else if(mask==RCV_VOlP)			//按键：0
	{
		//printf("7\n");
		key_data=7;
	}
	else if(mask==RCV_VOlN)			//按键：2
	{
		//printf("8\n");
		key_data=8;
	}

    //Random_Funcation();
    //OverGame_Funcation();
    //Print_Interface(interface);
    //__enable_irq();
    
}




