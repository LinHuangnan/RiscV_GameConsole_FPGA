
#include"global.h"
#include "palette.h"
#include "lcd.h"
 
/*按钮结构体数组*/
Touch_Button button;

/*画笔参数*/
Brush_Style  			brush;
Block_Colour 			Block_Colour_BUFF[12];
Block_place  			Block_place_BUFF[16];

Direction_Struct        Direction_Structure;

Direction_Struct_FLAG   Direction_Structure_FLAG;//上下左右标志

uint16_t interface[16] = {0};//16个块的数字

uint8_t Status_flag = 0;  //按下或松开标志

static void Draw_Color_Button(void *btn);

void Print_Interface(uint16_t * Interface);

void Block_Colour_init(void)
{
	Direction_Structure.Down  = 0;                //初始化方向结构体
	Direction_Structure.Left  = 0;
	Direction_Structure.Right = 0;
	Direction_Structure.Up    = 0;
	
	Block_Colour_BUFF[0].Block_Color = CL_WHITE;  //2     这都是绑定每个数字对应的颜色，后面直接调用结构体数组就能够方便的更新显示
	Block_Colour_BUFF[0].Num_Color = CL_GREY3;	
	Block_Colour_BUFF[0].CHAR[0] = '0';
	Block_Colour_BUFF[0].CHAR[1] = '0';
	Block_Colour_BUFF[0].CHAR[2] = '0';
	Block_Colour_BUFF[0].CHAR[3] = '2';	
	
	Block_Colour_BUFF[1].Block_Color = CL_BLACK;  //4
	Block_Colour_BUFF[1].Num_Color = CL_WHITE;	
	Block_Colour_BUFF[1].CHAR[0] = '0';
	Block_Colour_BUFF[1].CHAR[1] = '0';
	Block_Colour_BUFF[1].CHAR[2] = '0';
	Block_Colour_BUFF[1].CHAR[3] = '4';	

	Block_Colour_BUFF[2].Block_Color = CL_RED;    //8
	Block_Colour_BUFF[2].Num_Color = CL_WHITE;	
	Block_Colour_BUFF[2].CHAR[0] = '0';
	Block_Colour_BUFF[2].CHAR[1] = '0';
	Block_Colour_BUFF[2].CHAR[2] = '0';
	Block_Colour_BUFF[2].CHAR[3] = '8';	

	Block_Colour_BUFF[3].Block_Color = CL_GREEN;  //16
	Block_Colour_BUFF[3].Num_Color = CL_WHITE;	
	Block_Colour_BUFF[3].CHAR[0] = '0';
	Block_Colour_BUFF[3].CHAR[1] = '0';
	Block_Colour_BUFF[3].CHAR[2] = '1';
	Block_Colour_BUFF[3].CHAR[3] = '6';	

	Block_Colour_BUFF[4].Block_Color = CL_BLUE;   //32
	Block_Colour_BUFF[4].Num_Color = CL_WHITE;
	Block_Colour_BUFF[4].CHAR[0] = '0';
	Block_Colour_BUFF[4].CHAR[1] = '0';
	Block_Colour_BUFF[4].CHAR[2] = '3';
	Block_Colour_BUFF[4].CHAR[3] = '2';	
	
	Block_Colour_BUFF[5].Block_Color = CL_YELLOW; //64
	Block_Colour_BUFF[5].Num_Color = CL_GREY3;
	Block_Colour_BUFF[5].CHAR[0] = '0';
	Block_Colour_BUFF[5].CHAR[1] = '0';
	Block_Colour_BUFF[5].CHAR[2] = '6';
	Block_Colour_BUFF[5].CHAR[3] = '4';	
	
	Block_Colour_BUFF[6].Block_Color = CL_GREY;   //128
	Block_Colour_BUFF[6].Num_Color = CL_WHITE;
	Block_Colour_BUFF[6].CHAR[0] = '0';
	Block_Colour_BUFF[6].CHAR[1] = '1';
	Block_Colour_BUFF[6].CHAR[2] = '2';
	Block_Colour_BUFF[6].CHAR[3] = '8';	
	
	Block_Colour_BUFF[7].Block_Color = CL_GREY3;  //256
	Block_Colour_BUFF[7].Num_Color = CL_GREY1;
	Block_Colour_BUFF[7].CHAR[0] = '0';
	Block_Colour_BUFF[7].CHAR[1] = '2';
	Block_Colour_BUFF[7].CHAR[2] = '5';
	Block_Colour_BUFF[7].CHAR[3] = '6';	
	
	Block_Colour_BUFF[8].Block_Color = CL_MAGENTA;//512
	Block_Colour_BUFF[8].Num_Color = CL_WHITE;
	Block_Colour_BUFF[8].CHAR[0] = '0';
	Block_Colour_BUFF[8].CHAR[1] = '5';
	Block_Colour_BUFF[8].CHAR[2] = '1';
	Block_Colour_BUFF[8].CHAR[3] = '2';	
	
	Block_Colour_BUFF[9].Block_Color = CL_CYAN;   //1024
	Block_Colour_BUFF[9].Num_Color = CL_GREY3;
	Block_Colour_BUFF[9].CHAR[0] = '1';
	Block_Colour_BUFF[9].CHAR[1] = '0';
	Block_Colour_BUFF[9].CHAR[2] = '2';
	Block_Colour_BUFF[9].CHAR[3] = '4';	
	
	Block_Colour_BUFF[10].Block_Color = CL_BLUE1; //2048
	Block_Colour_BUFF[10].Num_Color = CL_GREY3;
	Block_Colour_BUFF[10].CHAR[0] = '2';
	Block_Colour_BUFF[10].CHAR[1] = '0';
	Block_Colour_BUFF[10].CHAR[2] = '4';
	Block_Colour_BUFF[10].CHAR[3] = '8';

	Block_Colour_BUFF[11].Block_Color = CL_ZERO;  //0
	Block_Colour_BUFF[11].Num_Color = CL_GREY3;
	Block_Colour_BUFF[11].CHAR[0] = '0';
	Block_Colour_BUFF[11].CHAR[1] = '0';
	Block_Colour_BUFF[11].CHAR[2] = '0';
	Block_Colour_BUFF[11].CHAR[3] = '0';

	Block_place_BUFF[0].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH;//板块1              //因为是手动画的界面，所有这些都是每个小方块的坐标位置，
	Block_place_BUFF[0].y_start = 0+BUTTON_AND_BUTTON_WIDTH;								  //后面直接调用结构体数组就能够方便的显示出来
	Block_place_BUFF[0].x_end   = BUTTON_START_X+COLOR_BLOCK_WIDTH+BUTTON_AND_BUTTON_WIDTH;
	Block_place_BUFF[0].y_end   = COLOR_BLOCK_HEIGHT+BUTTON_AND_BUTTON_WIDTH;
	
	Block_place_BUFF[1].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH;//板块2
	Block_place_BUFF[1].y_start = COLOR_BLOCK_HEIGHT+BUTTON_AND_BUTTON_WIDTH*2;
	Block_place_BUFF[1].x_end   = BUTTON_START_X+COLOR_BLOCK_WIDTH+BUTTON_AND_BUTTON_WIDTH;
	Block_place_BUFF[1].y_end   = COLOR_BLOCK_HEIGHT*2+BUTTON_AND_BUTTON_WIDTH*2;
	
	Block_place_BUFF[2].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH;//板块3
	Block_place_BUFF[2].y_start = COLOR_BLOCK_HEIGHT*2+BUTTON_AND_BUTTON_WIDTH*3;
	Block_place_BUFF[2].x_end   = BUTTON_START_X+COLOR_BLOCK_WIDTH+BUTTON_AND_BUTTON_WIDTH;
	Block_place_BUFF[2].y_end   = COLOR_BLOCK_HEIGHT*3+BUTTON_AND_BUTTON_WIDTH*3;
	
	Block_place_BUFF[3].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH;//板块4
	Block_place_BUFF[3].y_start = COLOR_BLOCK_HEIGHT*3+BUTTON_AND_BUTTON_WIDTH*4;
	Block_place_BUFF[3].x_end   = BUTTON_START_X+COLOR_BLOCK_WIDTH+BUTTON_AND_BUTTON_WIDTH;
	Block_place_BUFF[3].y_end   = COLOR_BLOCK_HEIGHT*4+BUTTON_AND_BUTTON_WIDTH*4;
	
	Block_place_BUFF[4].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH;//板块5
	Block_place_BUFF[4].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*1+COLOR_BLOCK_HEIGHT*0;
	Block_place_BUFF[4].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH*2;
	Block_place_BUFF[4].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH+COLOR_BLOCK_HEIGHT;
	
	Block_place_BUFF[5].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH;//板块6
	Block_place_BUFF[5].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_HEIGHT;
	Block_place_BUFF[5].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH*2;
	Block_place_BUFF[5].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_HEIGHT*2;
	
	Block_place_BUFF[6].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH;//板块7
	Block_place_BUFF[6].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_HEIGHT*2;
	Block_place_BUFF[6].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH*2;
	Block_place_BUFF[6].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_HEIGHT*3;
	
	Block_place_BUFF[7].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH;//板块8
	Block_place_BUFF[7].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_HEIGHT*3;
	Block_place_BUFF[7].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_WIDTH*2;
	Block_place_BUFF[7].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_HEIGHT*4;
	
	Block_place_BUFF[8].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*2;//板块9
	Block_place_BUFF[8].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*1+COLOR_BLOCK_HEIGHT*0;
	Block_place_BUFF[8].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*3;
	Block_place_BUFF[8].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*1+COLOR_BLOCK_HEIGHT*1;
	
	Block_place_BUFF[9].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*2;//板块10
	Block_place_BUFF[9].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_HEIGHT*1;
	Block_place_BUFF[9].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*3;
	Block_place_BUFF[9].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_HEIGHT*2;
	
	Block_place_BUFF[10].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*2;//板块11
	Block_place_BUFF[10].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_HEIGHT*2;
	Block_place_BUFF[10].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*3;
	Block_place_BUFF[10].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_HEIGHT*3;
	
	Block_place_BUFF[11].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*2;//板块12
	Block_place_BUFF[11].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_HEIGHT*3;
	Block_place_BUFF[11].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_WIDTH*3;
	Block_place_BUFF[11].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_HEIGHT*4;
	
	Block_place_BUFF[12].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*3;//板块13
	Block_place_BUFF[12].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*1+COLOR_BLOCK_HEIGHT*0;
	Block_place_BUFF[12].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*4;
	Block_place_BUFF[12].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*1+COLOR_BLOCK_HEIGHT*1;
	
	Block_place_BUFF[13].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*3;//板块14
	Block_place_BUFF[13].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_HEIGHT*1;
	Block_place_BUFF[13].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*4;
	Block_place_BUFF[13].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*2+COLOR_BLOCK_HEIGHT*2;
	
	Block_place_BUFF[14].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*3;//板块15
	Block_place_BUFF[14].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_HEIGHT*2;
	Block_place_BUFF[14].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*4;
	Block_place_BUFF[14].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*3+COLOR_BLOCK_HEIGHT*3;
	
	Block_place_BUFF[15].x_start = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*3;//板块16
	Block_place_BUFF[15].y_start = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_HEIGHT*3;
	Block_place_BUFF[15].x_end   = BUTTON_START_X+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_WIDTH*4;
	Block_place_BUFF[15].y_end   = PALETTE_START_Y+BUTTON_AND_BUTTON_WIDTH*4+COLOR_BLOCK_HEIGHT*4;
}

/**
* @brief  Palette_Init 画板初始化
* @param  无
* @retval 无
*/
void Palette_Init(void)
{
	/* 整屏清为白色 */
	LCD_Clear(CL_BACK);	/* 清屏*/
	Block_Colour_init();    //初始化相关数组

	//LCD_SetColors(CL_GREY,CL_WHITE);   //画屏幕左边的框
	LCD_Fill(6,16,158,448,CL_GREY);
	//LCD_DrawFullRect(16,16,304,448);
	
	//LCD_SetColors(CL_GREY3,CL_WHITE);
	LCD_Fill(10,20,150,440,CL_GREY3);
	
	//LCD_SetColors(CL_GREY1,CL_WHITE);
	LCD_Fill(25,40,110,100,CL_GREY1);
	
	/*选择字体，使用中英文显示时，尽量把英文选择成16*24的字体，
	  中文字体大小是24*24的，需要其它字体请自行制作字模
	  这个函数只对英文字体起作用*/
	//LCD_SetFont(&Font24x56);
	//LCD_DispString_EN_CH(50,153,(uint8_t*)"2048",LCD_COLOR565_CYAN,0);
	//POINT_COLOR=CYAN;
	POINT_COLOR=RED;
	BACK_COLOR=CL_GREY1;
	LCD_ShowString(26,78,108,24,24,"Game:2048");
	//LCD_DispChar_CH(110,125,0xD0A1); //'小'
	//LCD_DispChar_CH(110,150,0xD3CE); //'游'
	//LCD_DispChar_CH(110,175,0xCFB7); //'戏'
	
	//LCD_SetColors(CL_GREY1,CL_WHITE);   //重新开始按钮
	//LCD_Fill(118,390,100,50,CL_GREY1);
	
	//LCD_SetFont(&Font16x24);
	//LCD_DispString_EN_CH(405,145,(uint8_t*)"重开",LCD_COLOR565_CYAN,1);
	//LCD_ShowString(126,405,84,24,24,"Restart");

	//LCD_SetColors(CL_YELLOW,CL_WHITE);   //参数一为边框颜色，参数二无用
	//LCD_DrawRect(118,390,100,50);
	//LCD_DrawRectangle(118,390,100,50,YELLOW);

//	LCD_SetFont(&Font24x56);
//	LCD_DispString_EN_CH(160,125,(uint8_t*)score_buff,LCD_COLOR565_CYAN,0);
}



/**
* @brief  Touch_Button_Init 初始化按钮参数
* @param  Block_place:  板块的位置
		  Block_Colour：板块颜色(颜色和数字是捆绑在一起的，所以颜色代表数字，数字代表颜色)
* @retval 无
*/

void Touch_Button_Update(uint8_t Block_place,uint16_t Block_Colour)
{
	switch(Block_Colour)
	{
		case 0:
			Block_Colour = 11;
			break;
		case 2:
			Block_Colour = 0;
			break;
		case 4:
			Block_Colour = 1;
			break;
		case 8:
			Block_Colour = 2;
			break;
		case 16:
			Block_Colour = 3;
			break;
		case 32:
			Block_Colour = 4;
			break;
		case 64:
			Block_Colour = 5;
			break;
		case 128:
			Block_Colour = 6;
			break;
		case 256:
			Block_Colour = 7;
			break;
		case 512:
			Block_Colour = 8;
			break;
		case 1024:
			Block_Colour = 9;
			break;
		case 2048:
			Block_Colour = 10;
			break;
//		defualt:
//			break;
	}
	button.start_x      = Block_place_BUFF[Block_place].x_start;
	button.start_y      = Block_place_BUFF[Block_place].y_start;
	button.end_x        = Block_place_BUFF[Block_place].x_end;
	button.end_y        = Block_place_BUFF[Block_place].y_end;
	button.Block_Color  = Block_Colour_BUFF[Block_Colour].Block_Color;
	button.Num_Color    = Block_Colour_BUFF[Block_Colour].Num_Color;
	button.CHAR_BUFF[0] = Block_Colour_BUFF[Block_Colour].CHAR[0];
	button.CHAR_BUFF[1] = Block_Colour_BUFF[Block_Colour].CHAR[1];
	button.CHAR_BUFF[2] = Block_Colour_BUFF[Block_Colour].CHAR[2];
	button.CHAR_BUFF[3] = Block_Colour_BUFF[Block_Colour].CHAR[3];
	button.draw_btn     = Draw_Color_Button ;
	
	button.draw_btn(&button);
}


void Print_Interface(uint16_t * Interface)      //界面刷新函数
{
	uint8_t Count = 0;
	for(Count=0;Count<16;Count++)
	{
		Touch_Button_Update(Count,Interface[Count]);   //更新所有的板块
	}
	
	//LCD_SetFont(&Font16x24);
	//LCD_DispString_EN_CH(180,40,(uint8_t*)"分数》",LCD_COLOR565_CYAN,1);
	POINT_COLOR=GREEN;
	BACK_COLOR=CL_GREY3;
	LCD_ShowString(21,180,72,24,24,"Score:");
	POINT_COLOR=GREEN;
	//LCD_SetFont(&Font16x24);
	//LCD_DispString_EN_CH(183,140,score_buff,CL_GREY1,2);     //更新计分显示
	LCD_ShowNum(93,180,score,5,24);

}


static void Draw_Color_Button(void *btn)
{
	Touch_Button *ptr = (Touch_Button *)btn;
	
	//背景为功能键相应的颜色
	//LCD_SetColors(ptr->Block_Color,CL_WHITE);//参数一为填充颜色，参数二无用
	//LCD_DrawFullRect(ptr->start_x,ptr->start_y,ptr->end_x - ptr->start_x,ptr->end_y - ptr->start_y);
	BACK_COLOR=ptr->Block_Color;
	LCD_Fill(ptr->start_x,ptr->start_y,ptr->end_x - ptr->start_x,ptr->end_y - ptr->start_y,ptr->Block_Color);
	
	//按钮边框
	//LCD_SetColors(CL_BLUE4,CL_WHITE);   //参数一为边框颜色，参数二无用
	//LCD_DrawRect(ptr->start_x,ptr->start_y,ptr->end_x - ptr->start_x,ptr->end_y - ptr->start_y);
	LCD_DrawRectangle(ptr->start_x,ptr->start_y,ptr->end_x - ptr->start_x,ptr->end_y - ptr->start_y,CL_BLUE4);

	
//	LCD_SetColors(CL_BLACK,CL_BUTTON_GREY);
	//选择字体，使用中英文显示时，尽量把英文选择成16*24的字体，
	//中文字体大小是24*24的，需要其它字体请自行制作字模
	//这个函数只对英文字体起作用
	//LCD_SetFont(&Font24x56);
	//LCD_DispString_EN_CH( ptr->start_y+(COLOR_BLOCK_HEIGHT-56)/2,ptr->start_x + (COLOR_BLOCK_WIDTH-24)/2,(uint8_t*)ptr->CHAR_BUFF,ptr->Num_Color,0); 
	POINT_COLOR=ptr->Num_Color;
	LCD_ShowString(ptr->start_x + (COLOR_BLOCK_WIDTH-24)/2,ptr->start_y+(COLOR_BLOCK_HEIGHT-56)/2,48,24,24,(uint8_t*)ptr->CHAR_BUFF);

}



/* ------------------------------------------end of file---------------------------------------- */
