#include "key.h"
#include "global.h"




//按键处理函数
//返回按键值
//mode:0,不支持连续按;1,支持连续按;
//0，没有任何按键按下
//1，KEY0按下
//2，KEY1按下
//3，KEY2按下 
//4，KEY3按下
//注意此函数有响应优先级,KEY0>KEY1>KEY2>KEY3
uint8_t KEY_Scan(uint8_t mode)
{	 
	/*
	static uint8_t key_up=1;//按键按松开标志
	if(mode)key_up=1;  //支持连按		  
	if(key_up&&(KEY0In==0||KEY3In==0))
	{
		//delay_ms(10);//去抖动 
		key_up=0;
		if(KEY0In==0)return KEY0_PRES;
		else if(KEY3In==0)return KEY3_PRES;
	}else if(KEY0In==1&&KEY3In==1)key_up=1; 	
	*/    
 	return 0;// 无按键按下
	
}






















