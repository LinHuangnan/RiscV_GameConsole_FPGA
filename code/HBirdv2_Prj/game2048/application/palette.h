#ifndef _PALETTE_H
#define _PALETTE_H

 
#define ABS(X)  ((X) > 0 ? (X) : -(X))   //取绝对值

#define COLOR_BLOCK_WIDTH   100
#define COLOR_BLOCK_HEIGHT  100
#define BUTTON_AND_BUTTON_WIDTH 16

#define BUTTON_NUM 16
#define PALETTE_START_Y   0
#define PALETTE_END_Y     LCD_PIXEL_HEIGHT

#if 1     //按钮栏在左边
  #define BUTTON_START_X      174
  #define PALETTE_START_X     175
  #define PALETTE_END_X       LCD_PIXEL_WIDTH

#else     //按钮栏在右边，(存在触摸按键时也会的bug仅用于测试触摸屏左边界)
  #define BUTTON_START_X      LCD_PIXEL_WIDTH-2*COLOR_BLOCK_WIDTH
  #define PALETTE_START_X   0
  #define PALETTE_END_X     LCD_PIXEL_WIDTH-2*COLOR_BLOCK_WIDTH

#endif

/*
	LCD 颜色代码，CL_是Color的简写
	16Bit由高位至低位， RRRR RGGG GGGB BBBB

	下面的RGB 宏将24位的RGB值转换为16位格式。
	启动windows的画笔程序，点击编辑颜色，选择自定义颜色，可以获得的RGB值。

	推荐使用迷你取色器软件获得你看到的界面颜色。
*/
#if LCD_RGB_888
/*RGB888颜色转换*/
#define RGB(R,G,B)	( (R<< 16) | (G << 8) | (B))	/* 将8位R,G,B转化为 24位RGB888格式 */

#else 
/*RGB565 颜色转换*/
#define RGB(R,G,B)	(((R >> 3) << 11) | ((G >> 2) << 5) | (B >> 3))	/* 将8位R,G,B转化为 16位RGB565格式 */
#define RGB565_R(x)  ((x >> 8) & 0xF8)
#define RGB565_G(x)  ((x >> 3) & 0xFC)
#define RGB565_B(x)  ((x << 3) & 0xF8)

#endif

extern uint16_t interface[16];

enum
{
	CL_WHITE    = RGB(255,255,255),	/* 白色 */
	CL_BLACK    = RGB(  0,  0,  0),	/* 黑色 */
	CL_RED      = RGB(255,	0,  0),	/* 红色 */
	CL_GREEN    = RGB(  0,255,  0),	/* 绿色 */
	CL_BLUE     = RGB(  0,	0,255),	/* 蓝色 */
	CL_YELLOW   = RGB(255,255,  0),	/* 黄色 */
	CL_BACK     = RGB(64,232,232),
	
	CL_GREY    = RGB( 98, 98, 98), 	/* 深灰色 */
	CL_GREY1		= RGB( 150, 150, 150), 	/* 浅灰色 */
	CL_GREY2		= RGB( 180, 180, 180), 	/* 浅灰色 */
	CL_GREY3		= RGB( 200, 200, 200), 	/* 最浅灰色 */
	CL_GREY4		= RGB( 230, 230, 230), 	/* 最浅灰色 */

	CL_BUTTON_GREY	= RGB( 220, 220, 220), /* WINDOWS 按钮表面灰色 */

	CL_MAGENTA      = RGB(255, 0, 255),	/* 红紫色，洋红色 */
	CL_CYAN         = RGB( 0, 255, 255),	/* 蓝绿色，青色 */

	CL_ZERO         = RGB(149,242,242),
	
	CL_BLUE1        = RGB(  0,  0, 240),		/* 深蓝色 */
	CL_BLUE2        = RGB(  0,  0, 128),		/* 深蓝色 */
	CL_BLUE3        = RGB(  68, 68, 255),		/* 浅蓝色1 */
	CL_BLUE4        = RGB(  0, 64, 128),		/* 浅蓝色1 */

	/* UI 界面 Windows控件常用色 */
	CL_BTN_FACE		  = RGB(236, 233, 216),	/* 按钮表面颜色(灰) */
	CL_BOX_BORDER1	= RGB(172, 168,153),	/* 分组框主线颜色 */
	CL_BOX_BORDER2	= RGB(255, 255,255),	/* 分组框阴影线颜色 */

	CL_MASK			    = 0x7FFF	/* RGB565颜色掩码，用于文字背景透明 */
};
/*数字和颜色块互相对应结构体*/
typedef struct
{
	uint16_t Block_Color;

	uint8_t CHAR[4];
	
	uint16_t Num_Color;
}Block_Colour;


/*方向判断结构体*/
typedef struct
{

	uint16_t Down;
	uint16_t Up;
	uint16_t Right;
	uint16_t Left;
}Direction_Struct;

typedef struct
{
	uint16_t Down_FLAG;
	uint16_t Up_FLAG;
	uint16_t Right_FLAG;
	uint16_t Left_FLAG;
}Direction_Struct_FLAG;


/*所有方块的坐标*/
typedef struct
{
	uint16_t x_start;
	uint16_t y_start;
	uint16_t x_end;
	uint16_t y_end;
}Block_place;


typedef struct 
{
	uint16_t start_x;           //按键的x起始坐标  
	uint16_t start_y;           //按键的y起始坐标
	uint16_t end_x;             //按键的x结束坐标 
	uint16_t end_y;             //按键的y结束坐标
	uint16_t Block_Color;       //颜色按钮中表示选择的颜色，笔迹形状按钮中表示选择的画刷
	uint16_t Num_Color;         //颜色按钮中表示选择的颜色，笔迹形状按钮中表示选择的画刷	
	uint8_t  CHAR_BUFF[4];

	void (*draw_btn)(void * btn);     //按键描绘函数
}Touch_Button;


/*画刷形状列表*/
typedef enum 
{
  LINE_SINGLE_PIXCEL = 0,   //单像素线
  
  LINE_2_PIXCEL,  //2像素线
  
  LINE_4_PIXCEL,  //4像素线
  
  LINE_6_PIXCEL,  //6像素线
  
  LINE_8_PIXCEL,  //8像素线
  
  LINE_16_PIXCEL, //16像素线
  
  LINE_20_PIXCEL, //20像素线
  
  LINE_WITH_CIRCLE,  //珠子连线
    
  RUBBER,           //橡皮

}SHAPE;

/*画刷参数*/
typedef struct
{
  uint32_t color;
  
  SHAPE  shape;
  
}Brush_Style;

extern Direction_Struct        Direction_Structure;

extern Direction_Struct_FLAG   Direction_Structure_FLAG;//上下左右标志

extern uint8_t Again_Flag;

/*brush全局变量在其它文件有使用到*/
extern Brush_Style brush;
//extern void Delay(__IO uint32_t nCount);	 //简单的延时函数

void Palette_Init(void);
//void Touch_Button_Update(uint8_t Block_place,uint16_t Block_Colour);
//void Touch_Button_Down(uint32_t x,uint32_t y);
//void Touch_Button_Up(uint32_t x,uint32_t y);
//void Draw_Trail(int32_t pre_x,int32_t pre_y,int32_t x,int32_t y);
//void Block_Colour_init(void);
void Print_Interface(uint16_t * Interface);

#endif //_PALETTE_H
