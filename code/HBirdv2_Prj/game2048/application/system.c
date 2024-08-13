#include"global.h"
#include"system.h"
#include<stdlib.h>
#include"palette.h"
#include"lcd.h"

#define pad_up 1
#define pad_down 2
#define pad_left 3
#define pad_right 4
#define pad_run 5
#define pad_back 6
#define pad_key0 7
#define pad_key1 8


char Random[5] = {2,4,4,2,8};       				//随机数字
int  RANDOM = 0;
void Random_Funcation(void)					  	 	//随机函数
{
	char z;	

	srand(RANDOM);
	
	uint8_t flag=0;
	for(int ii=0;ii<16;ii++)
	{
		if(interface[ii]==0)
		{
			flag=1;
			break;
		}
	}
	while(flag)
	{
		z = rand()%16;
		
		if(interface[z] == 0)
		{
			interface[z] = Random[rand()%5];
			break;
		}
		else
			continue;
	}
	
}



uint8_t OverGame_Funcation(void)   //结束游戏功能函数
{
	
	int i = 0,j = 0,x = 0;
	for(i=0;i<16;i++)
	if(interface[i] == 0)
	{
		j++;
	}
	if(j == 0)
	{
		for(x=0;x<16;x+=4)
		{
			for(i=0;i<4;i++)
			{
				
				if(i!=3&&interface[x+i] == interface[x+i+1])
				{
					return 1;
				}
				if(x!=12&&interface[x+i] == interface[x+i+4])
				{
					return 1;
				}
			}
		}
		//GameOverShow();
		Update_Flag = 0;
		GameOver_Flag = 1;
		return 0;
	}
	//return 1;
}
void GameOverShow(void)
{
	BACK_COLOR=YELLOW;
    POINT_COLOR=RED;
    LCD_Fill(260,190,120,100,YELLOW);
    LCD_ShowString(266,240,108,24,24,"GAME OVER");
}

void Move_Up(void)   						//左移函数
{
	int i,j,x,z;	
	char cnt_1 = 0;
	char cnt_2 = 0;
	
	for(x=0;x<4;x++)
	{
		for(i=0;i<4;i++)
		{
			for(j=i+1;j<4;j++)
			{
				if(interface[cnt_1+i] == interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					interface[cnt_1+i] = interface[cnt_1+i]+interface[cnt_1+j];
					interface[cnt_1+j] = 0;
					score += interface[cnt_1+i];
					break;
				}
				else if(interface[cnt_1+i] != interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					break;
				}
			}
		}
		cnt_1 += 4;
	}
	for(x=0;x<4;x++)					   //循环四次，(4*4)遍历16个单元
	{
		for(i=0;i<4;i++)
		{
			if(interface[cnt_2+i] == 0)
			{
				for(j=i+1;j<4;j++)
				{
					if(interface[cnt_2+j] != 0)
					{
						for(z=0;z<4-j;z++)
						{
							interface[cnt_2+i+z] = interface[cnt_2+j+z];
							interface[cnt_2+j+z] = 0;
						}
						break;
					}
				}
			}
		}
		cnt_2 += 4;
	}
}

void Move_Down(void)    //右移函数
{
	int i,j,x,z;	
	char cnt_1 = 0;
	char cnt_2 = 0;
		
	for(x=0;x<4;x++)
	{
		for(i=0;i<4;i++)
		{
			for(j=i+1;j<4;j++)
			{
				if(interface[cnt_1+i] == interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					interface[cnt_1+j] = interface[cnt_1+i]+interface[cnt_1+j];
					interface[cnt_1+i] = 0;
					score += interface[cnt_1+j];
					break;
				}
				else if(interface[cnt_1+i] != interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					break;
				}
			}
		}
		cnt_1 += 4;
	}
	for(x=0;x<4;x++)//循环四次，(4*4)遍历16个单元
	{
		for(i=3;i>=0;i--)
		{
			if(interface[cnt_2+i] == 0)
			{
				for(j=i-1;j>=0;j--)
				{
					if(interface[cnt_2+j] != 0)
					{
						for(z=0;z<j+1;z++)
						{
							interface[cnt_2+i-z] = interface[cnt_2+j-z];
							interface[cnt_2+j-z] = 0;
						}
						break;
					}
				}
			}
		}
		cnt_2 += 4;
	}
}

void Move_Left(void)    //上移函数
{
	int i,j,x,z;	
	char cnt_1 = 0;
	char cnt_2 = 0;
		
	for(x=0;x<4;x++)
	{
		for(i=0;i<16;i+=4)
		{
			for(j=i+4;j<16;j+=4)
			{
				if(interface[cnt_1+i] == interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					interface[cnt_1+i] = interface[cnt_1+i]+interface[cnt_1+j];
					interface[cnt_1+j] = 0;
					score += interface[cnt_1+i];
					break;
				}
				else if(interface[cnt_1+i] != interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					break;
				}
			}
		}
		cnt_1 += 1;
	}
	for(x=0;x<4;x++)//循环四次，(4*4)遍历16个单元
	{
		for(i=0;i<16;i+=4)
		{
			if(interface[cnt_2+i] == 0)
			{
				for(j=i+4;j<16;j+=4)
				{
					if(interface[cnt_2+j] != 0)
					{
						for(z=0;z<(4-(j/4));z++)
						{
							interface[cnt_2+i+4*z] = interface[cnt_2+j+4*z];
							interface[cnt_2+j+4*z] = 0;
						}
						break;
					}
				}
			}
		}
		cnt_2 += 1;
	}
}

void Move_Right(void)    //下移函数
{
	int i,j,x,z;	
	char cnt_1 = 0;
	char cnt_2 = 0;
		
	for(x=0;x<4;x++)
	{
		for(i=12;i>=0;i-=4)
		{
			for(j=i-4;j>=0;j-=4)
			{
				if(interface[cnt_1+i] == interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					interface[cnt_1+i] = interface[cnt_1+i]+interface[cnt_1+j];
					interface[cnt_1+j] = 0;
					score += interface[cnt_1+i];
					break;
				}
				else if(interface[cnt_1+i] != interface[cnt_1+j]&&interface[cnt_1+i] != 0&&interface[cnt_1+j] != 0)
				{
					break;
				}
			}
		}
		cnt_1 += 1;
	}
	for(x=0;x<4;x++)//循环四次，(4*4)遍历16个单元
	{
		for(i=12;i>=0;i-=4)
		{
			if(interface[cnt_2+i] == 0)
			{
				for(j=i-4;j>=0;j-=4)
				{
					if(interface[cnt_2+j] != 0)
					{
						for(z=0;z<((j/4)+1);z++)
						{
							interface[cnt_2+i-4*z] = interface[cnt_2+j-4*z];
							interface[cnt_2+j-4*z] = 0;
						}
						break;
					}
				}
			}
		}
		cnt_2 += 1;
	}
}





void switch_game(void)
{
	LCD_Fill(120,140,400,200,YELLOW);
	LCD_Fill(124,144,392,192,WHITE);
	POINT_COLOR=BLACK;
	BACK_COLOR=WHITE;
	LCD_ShowString(236,200,312,24,24,"Return to game menu!");
	LCD_ShowString(248,265,324,24,24,"Please wait!");
	__asm__ __volatile__(
		"lui	ra,0x20400\n"
		"ret	\n"
	);

}


void game_init(void)
{
    for(int i=0;i<16;i++)
    {
        interface[i]=0;
    }
	score=0;
	GameOver_Flag=0;
	Update_Flag=0;
    Palette_Init();
    Random_Funcation();
	Print_Interface(interface);
}

void game_main(void)
{
	while (1)
	{
		if(key_data==pad_back | PS2_B_In)
		{
			switch_game();
		}
		if((key_data==pad_run|PS2_A_In) && switchGameChart==0)
		{
			key_data=0;
			game_init();
		}
		if(switchGameChart==0)
		{
			if(key_data==1 | PS2_UP_In)
			{
				Update_Flag=1;
				Move_Up();
			}
			else if(key_data==2 | PS2_DOWN_In)
			{
				Update_Flag=1;
				Move_Down();
			}
			else if(key_data==3 | PS2_LEFT_In)
			{
				Move_Left();
				Update_Flag=1;
			}
			else if(key_data==4 | PS2_RIGHT_In)
			{
				Move_Right();
				Update_Flag=1;
				printf("right\n");
			}
			if(Update_Flag)
			{
				Random_Funcation();
				OverGame_Funcation();
			}
			
			if(GameOver_Flag)GameOverShow();
			else if(Update_Flag)Print_Interface(interface);
			key_data=0;
			Update_Flag=0;
			delay_1ms(50);
		}
		
	}
	
}
