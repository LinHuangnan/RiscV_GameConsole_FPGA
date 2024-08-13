// See LICENSE for license details.
#include "hbird_sdk_soc.h"
#include "global.h"
#include "lcd.h"
#include "key.h"
#include "InfoNES.h"
//#include <time.h>
//#include <stdlib.h>

void	ps2_init(void);
void plic_init(void);
void plic_btn_handler(void);

void switch_game(void);
void SwitchGameChartRunKey(void);
void drawSwitchGameChart(void);
void SwitchGameChartInit();
void GameChange();

//LCD基地址
uint16_t*LCD_P=(uint16_t*)0x80200000;
//LCD的画笔颜色和背景色	   
uint16_t POINT_COLOR=0x0000;	//画笔颜色
uint16_t BACK_COLOR=0xFFFF;  //背景色 
uint8_t falg_scankey=0;
volatile uint8_t key_data=0;

int main(void)
{
	ps2_init();
	plic_init();
	LCD_Clear(WHITE);
	if(InfoNES_Load(NULL)==0)
	{
		InfoNES_Main();
	}
	while(1)
	{
	}
    return 0;
}



void ps2_init()
{
    int mask=0xff00ff00;
    gpio_enable_input(GPIOA, mask);
}
void plic_init()
{
    int mask=RCV_UP | RCV_DOWN | RCV_LEFT |RCV_RIGHT|RCV_PLAY|RCV_BACK |RCV_VOlP|RCV_VOlN;
    gpio_enable_input(GPIOA, mask);
    gpio_enable_interrupt(GPIOA, mask, GPIO_INT_RISE);
    PLIC_Register_IRQ(PLIC_GPIOA_IRQn, 1, plic_btn_handler);
	//Core_Register_IRQ(SysTimer_IRQn, mtimer_irq_handler); /* register system timer interrupt */
    // Enable interrupts in general.
    __enable_irq();
	//uint64_t now = SysTimer_GetLoadValue();
    //uint64_t then = now + 0.1 * SOC_TIMER_FREQ;
    //SysTimer_SetCompareValue(then);

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
		switch_game();
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

}


void switch_game(void)
{
	LCD_Fill(120,140,520,340,YELLOW);
	LCD_Fill(124,144,516,336,WHITE);
	POINT_COLOR=BLACK;
	BACK_COLOR=WHITE;
	LCD_ShowString(236,200,312,24,24,"Return to game menu!");
	LCD_ShowString(248,265,324,24,24,"Please wait!");
	__asm__ __volatile__(
		"lui	ra,0x20400\n"
		"ret	\n"
	);

}




