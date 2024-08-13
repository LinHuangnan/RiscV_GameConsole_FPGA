#ifndef __LCD_H
#define __LCD_H		
//#include "sys.h"	 
#include <stdlib.h>  
 

	    															  
void LCD_Init(void);													   	//初始化
void LCD_Clear(uint16_t Color);	 												//清屏
void LCD_DrawPoint(uint16_t x,uint16_t y);											//画点
uint16_t  LCD_ReadPoint(uint16_t x,uint16_t y); 											//读点 
void LCD_Draw_Circle(uint16_t x0,uint16_t y0,uint16_t r,uint16_t color);						 			//画圆
void LCD_DrawLine(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2,uint16_t color);							//画线
void LCD_DrawRectangle(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2,uint16_t color);		   				//画矩形
void LCD_Fill(uint16_t sx,uint16_t sy,uint16_t ex,uint16_t ey,uint16_t color);		   				//填充单色
void LCD_Color_Fill(uint16_t sx,uint16_t sy,uint16_t ex,uint16_t ey,uint16_t *color);				//填充指定颜色
void LCD_ShowChar(uint16_t x,uint16_t y,uint8_t num,uint8_t size,uint8_t mode);						//显示一个字符
void LCD_ShowNum(uint16_t x,uint16_t y,uint32_t num,uint8_t len,uint8_t size);  						//显示一个数字
void LCD_ShowxNum(uint16_t x,uint16_t y,uint32_t num,uint8_t len,uint8_t size,uint8_t mode);				//显示 数字
void LCD_ShowString(uint16_t x,uint16_t y,uint16_t width,uint16_t height,uint8_t size,uint8_t *p);		//显示一个字符串,12/16字体


void LCD_Set_Window(uint16_t sx,uint16_t sy,uint16_t width,uint16_t height);	//设置窗口					   						   																			 

#endif  
	 
	 



