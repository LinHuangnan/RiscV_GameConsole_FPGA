
#include "global.h"
#include "hbird_sdk_soc.h"
#include "lcd.h"

//void led_test();
void	ps2_init(void);
void 	plic_init(void);
void 	plic_btn_handler(void);


//LCD基地址
uint16_t*LCD_P=(uint16_t*)0x80200000;
uint32_t*Music_P=(uint32_t*)0x80400000;
volatile uint8_t key_data=0;
uint16_t POINT_COLOR=0x0000;	//画笔颜色
uint16_t BACK_COLOR=0xFFFF;  //背景色 

volatile uint8_t switchGameChart=0;
volatile uint8_t LCDinverse=0;


void switch_game(void);
void SwitchGameChartRunKey(void);
void drawSwitchGameChart(void);
void drawSwitchMusicChart(void);
void SwitchGameChartInit(void);
void GameChange(void);
void musicChange(void);
void drawListTable(void);

int main(void)
{
	ps2_init();
	plic_init();		//外部中断初始化
    LCD_Clear(WHITE);
    switch_game();
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
	else if(mask==RCV_VOlN)			//按键：2
	{
		//printf("8\n");
		key_data=8;
	}
}


uint8_t tableItemIdx=0;
uint8_t musicItemIdx=0;
uint8_t listIdx=0;
uint8_t musicAmp=4;

void GameChange()
{
	LCD_Fill(120,140,400,200,YELLOW);
	LCD_Fill(124,144,392,192,WHITE);
	LCD_ShowString(236,215,312,24,24,"Game changing!");
	LCD_ShowString(248,265,324,24,24,"Please wait!");
	if(tableItemIdx==0)
	{
		__asm__ __volatile__(
			"lui	ra,0x20380\n"
			"ret	\n"
		);
		//printf("%d\n",*Game_Base);
	}
	else if(tableItemIdx==1)
	{
		__asm__ __volatile__(
			"lui	ra,0x20480\n"
			"ret	\n"
		);
	}
	else if(tableItemIdx==2)
	{
		
		__asm__ __volatile__(
			"lui	ra,0x20680\n"
			"ret	\n"
		);
		
	}
	else if(tableItemIdx==3)
	{

		__asm__ __volatile__(
			"lui	ra,0x20500\n"
			"ret	\n"
		);

	}
    else if(tableItemIdx==4)
	{

		__asm__ __volatile__(
			"lui	ra,0x20580\n"
			"ret	\n"
		);

	}
    else if(tableItemIdx==5)
	{

		__asm__ __volatile__(
			"lui	ra,0x20600\n"
			"ret	\n"
		);

	}
    
    else if(tableItemIdx==6)
	{

		__asm__ __volatile__(
			"lui	ra,0x20700\n"
			"ret	\n"
		);

	}
    
	//while (1)
	//{
		
	//}
	

}

void musicChange()
{
	if(musicItemIdx==0)
	{
		//Two tiger
		*(Music_P+1)=21312;
		*(Music_P+2)=28714;
		
	}
	else if(musicItemIdx==1)
	{
		//only my railgun
		*(Music_P+1)=28736;
		*(Music_P+2)=52842;
	}
	else if(musicItemIdx==2)
	{
		//Take me hand
		*(Music_P+1)=52864;
		*(Music_P+2)=73084;
	}
	*(Music_P)=0xffffffff;
}

void drawListTable()
{
	if(listIdx==0)
	{
		POINT_COLOR=GREEN;
		LCD_ShowString(35,10,120,24,24,"Game List");
		POINT_COLOR=BLACK;
		LCD_ShowString(355,10,120,24,24,"Music List");
	}
	else
	{
		POINT_COLOR=GREEN;
		LCD_ShowString(355,10,120,24,24,"Music List");
		POINT_COLOR=BLACK;
		LCD_ShowString(35,10,120,24,24,"Game List");
	}
}

void SwitchGameChartInit()
{
	LCD_Clear(WHITE);
	LCD_Fill(10,5,620,470,BLUE);
	LCD_Fill(14,9,612,462,WHITE);
	/*
	BACK_COLOR=WHITE;
	POINT_COLOR=GREEN;
	LCD_ShowString(35,10,120,24,24,"Game List");
	POINT_COLOR=BLACK;
	LCD_ShowString(355,10,120,24,24,"Music List");
	POINT_COLOR=RED;
	LCD_ShowString(15,35,120,24,24,"1.Fly Bird");
	LCD_ShowString(330,35,132,24,24,"1.Two tiger");
	POINT_COLOR=BLACK;
	LCD_ShowString(15,60,132,24,24,"2.Game 2048");
	LCD_ShowString(330,60,204,24,24,"2.only My RailGun");
	//LCD_ShowString(15,60,168,24,24,"3.Greedy Snake");
    LCD_ShowString(15,85,108,24,24,"3.Contra");
	LCD_ShowString(330,85,168,24,24,"3.Take Me Hand");
	LCD_ShowString(15,110,156,24,24,"4.Super Mario");
    LCD_ShowString(15,135,156,24,24,"5.Salamander");
    LCD_ShowString(15,160,108,24,24,"6.Circus");
    LCD_ShowString(15,185,192,24,24,"7.I can remember");
	*/
	drawListTable();
	drawSwitchGameChart();
	drawSwitchMusicChart();
	


}

void drawSwitchGameChart(void)
{
	BACK_COLOR=WHITE;
	POINT_COLOR=BLACK;
	if(tableItemIdx==0)POINT_COLOR=RED;
	LCD_ShowString(15,35,120,24,24,"1.Fly Bird");
	POINT_COLOR=BLACK;
	if(tableItemIdx==1)POINT_COLOR=RED;
	LCD_ShowString(15,60,132,24,24,"2.Game 2048");
	POINT_COLOR=BLACK;
	if(tableItemIdx==2)POINT_COLOR=RED;
	//LCD_ShowString(15,60,168,24,24,"3.Greedy Snake");
    LCD_ShowString(15,85,108,24,24,"3.Contra");
	POINT_COLOR=BLACK;
	if(tableItemIdx==3)POINT_COLOR=RED;
	LCD_ShowString(15,110,156,24,24,"4.Super Mario");
    POINT_COLOR=BLACK;
	if(tableItemIdx==4)POINT_COLOR=RED;
	LCD_ShowString(15,135,156,24,24,"5.Salamander");
    POINT_COLOR=BLACK;
	if(tableItemIdx==5)POINT_COLOR=RED;
	LCD_ShowString(15,160,108,24,24,"6.Circus");
    POINT_COLOR=BLACK;
	if(tableItemIdx==6)POINT_COLOR=RED;
    LCD_ShowString(15,185,192,24,24,"7.I can remember");
}

void drawSwitchMusicChart(void)
{
	BACK_COLOR=WHITE;
	POINT_COLOR=BLACK;
	if(musicItemIdx==0)POINT_COLOR=RED;
	LCD_ShowString(330,35,132,24,24,"1.Two tiger");
	POINT_COLOR=BLACK;
	if(musicItemIdx==1)POINT_COLOR=RED;
	LCD_ShowString(330,60,204,24,24,"2.only My RailGun");
	POINT_COLOR=BLACK;
	if(musicItemIdx==2)POINT_COLOR=RED;
	LCD_ShowString(330,85,168,24,24,"3.Take Me Hand");

}

void SwitchGameChartRunKey(void)
{
	if(key_data==pad_down | PS2_DOWN_In)
	{
		delay_1ms(120);
		key_data=0;
		if(listIdx==0)
		{
			if(tableItemIdx<6)tableItemIdx++;
			drawSwitchGameChart();
		}
		else
		{
			if(musicItemIdx<2)musicItemIdx++;
			drawSwitchMusicChart();
		}
		
	}
	else if(key_data==pad_up | PS2_UP_In)
	{
		delay_1ms(120);
		key_data=0;
		if(listIdx==0)
		{
			if(tableItemIdx>0)tableItemIdx--;
			drawSwitchGameChart();
		}
		else
		{
			if(musicItemIdx>0)musicItemIdx--;
			drawSwitchMusicChart();
		}
	}
	else if(key_data==pad_left| PS2_LEFT_In | PS2_RIGHT_In)
	{
		delay_1ms(120);
		key_data=0;
		if(listIdx==0)
		{
			listIdx=1;
		}
		else
		{
			listIdx=0;
		}
		drawListTable();
	}
	else if(key_data==pad_right || PS2_B_In)
	{
		delay_1ms(120);
		key_data=0;
		if(LCDinverse)
		{
			LCDinverse=0;
		}
		else
		{
			LCDinverse=1;
		}
		SwitchGameChartInit();
	}
	else if(key_data==pad_back | PS2_X_In)
	{
		*(Music_P)=0x00000000;
	}
	else if(key_data==pad_volp | PS2_R2_In)
	{
		delay_1ms(120);
		if(musicAmp<5)
		{
			musicAmp++;
		}
		*(Music_P+3)=musicAmp;
	}
	else if(key_data==pad_voln | PS2_L2_In)
	{
		delay_1ms(120);
		if(musicAmp>0)
		{
			musicAmp--;
		}
		*(Music_P+3)=musicAmp;
	}
	else if(key_data==pad_run | PS2_A_In)
	{
		delay_1ms(120);
		key_data=0;
		if(listIdx==0)
		{
			GameChange();
		}
		else
		{
			musicChange();
		}
		
	}

}



void switch_game(void)
{
	tableItemIdx=0;
	SwitchGameChartInit();
	while (1)
	{
		SwitchGameChartRunKey();
	}

}

