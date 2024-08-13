#include "global.h"
#include "hbird_sdk_soc.h"
#include "system.h"
#include "lcd.h"




#define pad_up 1
#define pad_down 2
#define pad_left 3
#define pad_right 4
#define pad_run 5
#define pad_back 6
#define pad_volp 7
#define pad_voln 8




#define game_show_height 430
#define game_show_width 640
#define bird_crash_y1 31
#define bird_crash_y2 game_show_height-1
#define info_height LCD_H_MAX-game_show_height



//0透明1(0X0000)2(0XFFFF)3(0XFE00)4(0XF800)
//翅膀在中间
const uint8_t bird_ico1[12*17]=
{
	0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,3,3,3,1,2,2,1,0,0,0,0,
	0,0,0,1,3,3,3,3,1,2,2,2,2,1,0,0,0,
	0,0,1,3,3,3,3,3,1,2,2,2,1,2,1,0,0,
	0,1,3,3,3,3,3,3,1,2,2,2,1,2,1,0,0,
	0,1,1,1,1,1,3,3,3,1,2,2,2,2,1,0,0,
	1,2,2,2,2,2,1,3,3,3,1,1,1,1,1,1,0,
	1,2,2,2,2,2,1,3,3,1,4,4,4,4,4,4,1,
	0,1,1,1,1,1,3,3,1,4,1,1,1,1,1,1,0,
	0,0,1,3,3,3,3,3,3,1,4,4,4,4,4,1,0,
	0,0,0,1,1,3,3,3,3,3,1,1,1,1,1,0,0,
	0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,
};
//翅膀在下面
static const uint16_t bird_ico2[12*17]=
{
	0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,3,3,3,1,2,2,1,0,0,0,0,
	0,0,0,1,3,3,3,3,1,2,2,2,2,1,0,0,0,
	0,0,1,3,3,3,3,3,1,2,2,2,1,2,1,0,0,
	0,1,3,3,3,3,3,3,1,2,2,2,1,2,1,0,0,
	0,1,1,1,1,1,3,3,3,1,2,2,2,2,1,0,0,
	1,1,2,2,2,2,1,3,3,3,1,1,1,1,1,1,0,
	1,2,2,2,2,2,1,3,3,1,4,4,4,4,4,4,1,
	1,2,2,2,2,1,3,3,1,4,1,1,1,1,1,1,0,
	1,2,2,2,2,3,3,3,3,1,4,4,4,4,4,1,0,
	1,2,2,2,1,3,3,3,3,3,1,1,1,1,1,0,0,
	0,1,1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,
};
//翅膀在上面
static const uint16_t bird_ico3[12*17]=
{
	0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,3,3,3,1,2,2,1,0,0,0,0,
	0,1,1,1,3,3,3,3,1,2,2,2,2,1,0,0,0,
	1,2,2,2,1,3,3,3,1,2,2,2,1,2,1,0,0,
	1,2,2,2,2,3,3,3,1,2,2,2,1,2,1,0,0,
	1,2,2,2,2,1,3,3,3,1,2,2,2,2,1,0,0,
	1,2,2,2,2,2,1,3,3,3,1,1,1,1,1,1,0,
	1,1,2,2,2,2,1,3,3,1,4,4,4,4,4,4,1,
	0,1,1,1,1,1,3,3,1,4,1,1,1,1,1,1,0,
	0,0,1,3,3,3,3,3,3,1,4,4,4,4,4,1,0,
	0,0,0,1,1,3,3,3,3,3,1,1,1,1,1,0,0,
	0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,
};

static struct game_bird_conf //鸟信息控制块
{
	uint8_t mode; //0:开始界面1:开始游戏2:游戏结束
	uint64_t fps_t0,fps_t1;
	uint16_t fps_num;
} _game_bird_conf;
static struct bird_info //鸟信息控制块
{
	int x0,y0,y1;
	uint8_t h,w;
	uint64_t t0,t1;
	uint64_t t2,t3; //翅膀扇动时间
	uint32_t f; //翅膀扇状态0中间1下面2中间3上面
	float v0,a;
	uint32_t num; //通过柱数量
	uint8_t num_lock1,num_lock2,num_lock3;
} bird,bird_last;

static struct pillar_info //柱信息控制块
{
	int x0,x1;
	int16_t h,w,j;
	uint64_t t0,t1; //运动时间
	float v0;
} pillar1,pillar2,pillar3,pillar1_last,pillar2_last,pillar3_last;

//鸟初始化
void bird_init(void)
{
	bird.y0=200;  //初始位置
	bird.y1=200;  //初始位置
	bird.x0=30;    
	bird.w=34;    //宽
	bird.h=24;		//高
	bird.t0=SysTimer_GetLoadValue()/32; //初始时间
	bird.t2=SysTimer_GetLoadValue()/32; //初始时间
	bird.f=0; 		//初始翅膀状态
	bird.v0=0;		//初始速度
	bird.a=0.0005;//初始加速度
	bird.num=0;
	bird.num_lock1=0;
	bird.num_lock2=0;
	bird.num_lock3=0;
}



//柱初始化
void pillar_init(void)
{

	pillar1.x0=game_show_width-380;  //初始位置
	pillar1.x1=game_show_width-380;  //初始位置
	pillar1.h=40;//相对地高
	pillar1.w=40;			//宽
	pillar1.j=100;   //间隙
	pillar1.t0=SysTimer_GetLoadValue()/32; //初始时间
	pillar1.v0=0.1;		//初始速度
	
	pillar2.x0=game_show_width-170;  //初始位置
	pillar2.x1=game_show_width-170;  //初始位置
	pillar2.h=70;
	pillar2.w=40;
	pillar2.j=100;
	pillar2.t0=SysTimer_GetLoadValue()/32; //初始时间
	pillar2.v0=0.1;		//初始速度


	pillar3.x0=game_show_width+40;  //初始位置
	pillar3.x1=game_show_width+40;  //初始位置
	pillar3.h=180;
	pillar3.w=40;
	pillar3.j=100;
	pillar3.t0=SysTimer_GetLoadValue()/32; //初始时间
	pillar3.v0=0.1;		//初始速度




}

//计算鸟移动位置
static void bird_move(void)
{
	bird.t1=SysTimer_GetLoadValue()/32-bird.t0;
	bird.t3=SysTimer_GetLoadValue()/32-bird.t2;//翅膀
	bird.y1=(int)(bird.y0-(bird.v0*bird.t1)+(bird.a*bird.t1*bird.t1));
	//限位
	/*
	if(bird.y1<29+bird.h)
	{
		bird.y1=29+bird.h;
	}else if(bird.y1>239)
	{
		bird.y1=239;
	}
	*/
	if(bird.y1<bird_crash_y1)
	{
		bird.y1=bird_crash_y1;
	}else if(bird.y1>bird_crash_y2-bird.h)
	{
		bird.y1=bird_crash_y2-bird.h;
	}

	//翅膀时间
	if(bird.t3>50)
	{
		if(bird.f==3)bird.f=0;
		else bird.f++;
		bird.t2=SysTimer_GetLoadValue()/32; //更新初时间
	}
}
//计算柱移动位置
static void pillar_move(void)
{
	pillar1.t1=SysTimer_GetLoadValue()/32-pillar1.t0;
	pillar1.x1=(int)(pillar1.x0-(pillar1.v0*pillar1.t1));
	if(pillar1.x1<=-pillar1.w)
	{
		//pillar1.x0=240;
		//pillar1.x1=240;
		pillar1.x0=game_show_width;
		pillar1.x1=game_show_width;
		pillar1.h=rand()%290+30;
		pillar1.t0=SysTimer_GetLoadValue()/32;
		bird.num_lock1=0; //解锁
	}
	
	pillar2.t1=SysTimer_GetLoadValue()/32-pillar2.t0;
	pillar2.x1=(int)(pillar2.x0-(pillar2.v0*pillar2.t1));
	if(pillar2.x1<=-pillar2.w)
	{
		//pillar2.x0=240;
		//pillar2.x1=240;
		pillar2.x0=game_show_width;
		pillar2.x1=game_show_width;
		pillar2.h=rand()%290+30;
		pillar2.t0=SysTimer_GetLoadValue()/32;
		bird.num_lock2=0; //解锁
	}

	pillar3.t1=SysTimer_GetLoadValue()/32-pillar3.t0;
	pillar3.x1=(int)(pillar3.x0-(pillar3.v0*pillar3.t1));
	if(pillar3.x1<=-pillar3.w)
	{
		//pillar2.x0=240;
		//pillar2.x1=240;
		pillar3.x0=game_show_width;
		pillar3.x1=game_show_width;
		pillar3.h=rand()%290+30;
		pillar3.t0=SysTimer_GetLoadValue()/32;
		bird.num_lock3=0; //解锁
	}
	//鸟通过次数
	if(pillar1.x1+pillar1.w<bird.x0&&bird.num_lock1==0)
	{
		bird.num++;
		bird.num_lock1=1; //上锁
	}
	if(pillar2.x1+pillar2.w<bird.x0&&bird.num_lock2==0)
	{
		bird.num++;
		bird.num_lock2=1; //上锁
	}
	if(pillar3.x1+pillar3.w<bird.x0&&bird.num_lock3==0)
	{
		bird.num++;
		bird.num_lock3=1; //上锁
	}
}

//判断碰撞
static void bird_crash(void)
{
	
	if((bird.y1)<=bird_crash_y1||bird.y1>=bird_crash_y2-bird.h)//鸟碰地
	{
		_game_bird_conf.mode=3;//游戏结束
	}
	
	if((pillar1.x1-bird.x0)>=-pillar1.w+5&&(pillar1.x1-bird.x0)<=bird.w-5)//鸟碰柱1
	{
		/*
		if((bird.y1-pillar1.h-30)<=bird.h||(bird.y1-pillar1.h-30)>=pillar1.j)
		{
			_game_bird_conf.mode=3;//游戏结束
		}
		*/
		if((game_show_height-bird.y1-pillar1.h)<=bird.h||(game_show_height-bird.y1-pillar1.h)>=pillar1.j)
			{
				_game_bird_conf.mode=3;//游戏结束
			}
		}
	if((pillar2.x1-bird.x0)>=-pillar2.w+5&&(pillar2.x1-bird.x0)<=bird.w-5)//鸟碰柱2
	{
		/*
		if((bird.y1-pillar2.h-30)<=bird.h||(bird.y1-pillar2.h-30)>=pillar2.j)
		{
			_game_bird_conf.mode=3;//游戏结束
		}
		*/
		if((game_show_height-bird.y1-pillar2.h)<=bird.h||(game_show_height-bird.y1-pillar2.h)>=pillar2.j)
		{
			_game_bird_conf.mode=3;//游戏结束
		}
	}
	if((pillar3.x1-bird.x0)>=-pillar3.w+5&&(pillar3.x1-bird.x0)<=bird.w-5)//鸟碰柱3
	{
		if((game_show_height-bird.y1-pillar3.h)<=bird.h||(game_show_height-bird.y1-pillar3.h)>=pillar3.j)
		{
			_game_bird_conf.mode=3;//游戏结束
		}
	}
}

//画鸟
//0透明1(0X0000)2(0XFFFF)3(0XFE00)4(0XF800)
//mode:0	清楚
//mode:1	画鸟
void draw_bird(struct bird_info * bird,uint8_t mode)//34*24
{
	if(mode==1)
	{
		for(char i=0;i<12;i++)
		{
		for(char j=0;j<17;j++)
		{
				switch(bird->f)
				{
					case 0: 
						switch(bird_ico1[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0X0000);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFFFF);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFE00);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XF800);break;
						}	
					break;
					case 1: 
						switch(bird_ico2[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0X0000);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFFFF);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFE00);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XF800);break;
						}
					break;
					case 2: 
						switch(bird_ico1[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0X0000);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFFFF);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFE00);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XF800);break;
						}	
					break;
					case 3: 
						switch(bird_ico3[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0X0000);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFFFF);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XFE00);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0XF800);break;
						}
					break;
				}
		}
		}
	}
	else
	{
		for(char i=0;i<12;i++)
		{
		for(char j=0;j<17;j++)
		{
				switch(bird->f)
				{
					case 0: 
						switch(bird_ico1[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
						}	
					break;
					case 1: 
						switch(bird_ico2[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
						}
					break;
					case 2: 
						switch(bird_ico1[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
						}	
					break;
					case 3: 
						switch(bird_ico3[i*17+j])
						{
							case 0: break;
							case 1: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 2: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 3: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
							case 4: LCD_DrawRectangle(bird->x0+j*2,(bird->y1)+i*2,2,2,0x8638);break;
						}
					break;
				}
		}
		}

	}
	
}
//画柱
static void draw_pillar(struct pillar_info * pillar,uint8_t mode)
{
	if(mode==1)
	{
		uint16_t pillar_ico1[18]={0X0000,0XFF91,0XFF91,0XAE91,0XAE91,0X354C,0XAE91,0X354C,0X354C,0X354C,0X354C,
															0X354C,0X354C,0X354C,0X2D22,0X354C,0X0C85,0X0000};
		uint16_t pillar_ico2[14]={0X0000,0XFF91,0XFF91,0XAE91,0XAE91,0X354C,0XAE91,0X354C,0X354C,0X354C,0X2D22,0X354C,0X0C85,0X0000};

		//LCD_Fill(pillar->x1,240-pillar->h-30,36,1,0X0000);
		LCD_Fill(pillar->x1,game_show_height-pillar->h,36,1,0X0000);
		for(char j=0;j<18;j++)
		{
			//LCD_Fill(pillar->x1+j*2,240-pillar->h-30+1+i,2,1,pillar_ico1[j]);
			LCD_Fill(pillar->x1+j*2,game_show_height-pillar->h+1,2,8,pillar_ico1[j]);
		}
		//LCD_Fill(pillar->x1,240-pillar->h-30+9,36,1,0X0000);
		LCD_Fill(pillar->x1,game_show_height-pillar->h+9,36,1,0X0000);
		LCD_Fill(pillar->x1+5,game_show_height-pillar->h+11,26,pillar->h-12,0x8dc3);
		LCD_DrawRectangle(pillar->x1+4,game_show_height-pillar->h+10,28,pillar->h-10,0x0000);
		
		
		//LCD_Fill(pillar->x1,240-pillar->h-30-pillar->j-1,36,1,0X0000);
		LCD_Fill(pillar->x1,game_show_height-pillar->h-pillar->j-1,36,1,0X0000);
		for(char j=0;j<18;j++)
		{
			//LCD_Fill(pillar->x1+j*2,240-pillar->h-30-pillar->j-i-2,2,1,pillar_ico1[j]);
			LCD_Fill(pillar->x1+j*2,game_show_height-pillar->h-pillar->j-9,2,8,pillar_ico1[j]);
		}
		
		//LCD_Fill(pillar->x1,240-pillar->h-30-pillar->j-10,36,1,0X0000);
		LCD_Fill(pillar->x1,game_show_height-pillar->h-pillar->j-10,36,1,0X0000);
		LCD_Fill(pillar->x1+5,31,26,288-pillar->h,0x8dc3);
		LCD_DrawRectangle(pillar->x1+4,30,28,290-pillar->h,0x0000);

		
	}
	else
	{
		LCD_Fill(pillar->x1,game_show_height-pillar->h,36,10,BACK_COLOR);
		LCD_Fill(pillar->x1+4-2,game_show_height-pillar->h+10,28+4,pillar->h-10,BACK_COLOR);
		
		
		LCD_Fill(pillar->x1,game_show_height-pillar->h-pillar->j-10,36,10,BACK_COLOR);
		LCD_Fill(pillar->x1+4-2,30,28+4,290-pillar->h,BACK_COLOR);
	}
	
}
//画地面
void draw_brick(void)
{
	LCD_DrawRectangle(0,game_show_height,game_show_width,1,0X0000);
	LCD_Fill(0,game_show_height+1,game_show_width,7,0x8dc3);
	LCD_DrawRectangle(0,game_show_height+9,game_show_width,1,0X0000);

	
	LCD_ShowNum(92,game_show_height+14,bird.num,3,24);
	LCD_ShowNum(288,game_show_height+14,_game_bird_conf.fps_num,3,24);
	
}


//画背景
void draw_back(void)
{
	//天空
	//LCD_Fill(0,0,240,210,0x8638);
	//房子
	//LCD_Fill(0,169,5,40,0xcfda);
	//LCD_Fill(5,169,15,40,0x9673);
	//LCD_Fill(20,149,5,60,0xcfda);
	//LCD_Fill(25,149,40,60,0xaed6);
	//LCD_Fill(65,179,20,30,0x9673);
	
	//LCD_Fill(85,169,5,40,0xcfda);
	//LCD_Fill(90,169,15,40,0x9673);
	//LCD_Fill(105,149,5,60,0xcfda);
	//LCD_Fill(110,149,40,60,0xaed6);
	//LCD_Fill(150,179,20,30,0x9673);
	
	//LCD_Fill(170,169,5,40,0xcfda);
	//LCD_Fill(175,169,15,40,0x9673);
	//LCD_Fill(190,149,5,60,0xcfda);
	//LCD_Fill(195,149,40,60,0xaed6);
	//LCD_Fill(235,179,5,30,0x9673);
}
	
//画游戏结束对话框
static void draw_game_over(void)
{
	LCD_DrawRectangle(220,165,200,150,0x0000);
	LCD_DrawRectangle(221,166,198,148,0xf64f);

	LCD_ShowString(272,190,96,24,24,"GameOver");
	LCD_ShowString(260,265,120,24,24,"A:Gontinue");
}
//画游戏开始对话框
static void draw_game_start(void)
{
	LCD_DrawRectangle(220,165,200,150,0x0000);
	LCD_DrawRectangle(221,166,198,148,0xf64f);
	LCD_ShowString(278,228,84,24,24,"A:Start");
}



//flappy bird初始化
void game_flappy_bird_init(void)
{
	POINT_COLOR= RED;
	BACK_COLOR = 0x8638;
	LCD_Fill(0,0,game_show_width,game_show_height,BACK_COLOR);
	LCD_ShowString(20,game_show_height+14,144,24,24,"Score:");
	LCD_ShowString(240,game_show_height+14,96,24,24,"FPS:");
	bird_init(); 
	pillar_init();
	draw_brick();      				//画地面
	draw_pillar(&pillar1,1);    //画柱1
	draw_pillar(&pillar2,1);    //画柱2
	draw_pillar(&pillar3,1);    //画柱2
	draw_bird(&bird,1);


	
}
//flappy bird游戏运行时按键处理
void game_flappy_bird_run_key(void)
{
	if(key_data==1 | PS2_Y_In)//按下只执行一次
	{
		bird.y0=bird.y1; //更新位置
		bird.t0=SysTimer_GetLoadValue()/32; //更新初时间
		bird.v0=0.3; //速度
		
		key_data=0; //表示按下
	}
}

//flappy bird游戏开始时按键处理
void game_flappy_bird_start_key(void)
{
	bird_last=bird;
	pillar1_last=pillar1;
	pillar2_last=pillar2;
	pillar3_last=pillar3;

	if(key_data==pad_run | PS2_A_In)//按下只执行一次
	{
		_game_bird_conf.mode=2;//运行游戏
		game_flappy_bird_init();   //初始化
		key_data=0; //表示按下
	}
}
//flappy bird游戏结束时按键处理
void game_flappy_bird_over_key(void)
{
	if(key_data==pad_run | PS2_A_In)//按下只执行一次
	{
		_game_bird_conf.mode=2;//运行游戏
		game_flappy_bird_init();   //初始化
		
		key_data=0; //表示按下
	}
}
void game_flappy_bird_break_key(void)
{
	if(key_data==pad_back | PS2_B_In)//按下只执行一次
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
	else if(key_data==pad_right || PS2_X_In)
	{
		if(LCDinverse)
		{
			LCDinverse=0;
		}
		else
		{
			LCDinverse=1;
		}
		game_flappy_bird_init();   //初始化
		if(_game_bird_conf.mode==2)
		{
			_game_bird_conf.mode=1;
		}
		key_data=0;
	}
}
//flappy bird逻辑计算
void game_flappy_bird_logic(void)
{
	bird_move(); //移动计算
	pillar_move(); //移动计算
	bird_crash();  //判断碰撞
}

//flappy bird画图
void game_flappy_bird_draw(void)
{
	if(_game_bird_conf.mode==2)
	{

		draw_brick();      				//画地面
		draw_pillar(&pillar1_last,0);    //画柱1
		draw_pillar(&pillar1,1);    //画柱1
		draw_pillar(&pillar2_last,0);    //画柱2
		draw_pillar(&pillar2,1);    //画柱2
		draw_pillar(&pillar3_last,0);    //画柱3
		draw_pillar(&pillar3,1);    //画柱3
		draw_bird(&bird_last,0);			 		//画鸟
		draw_bird(&bird,1);			 				//画鸟
	}
	/*
	else if(_game_bird_conf.mode==1)
	{
		draw_brick();      				//画地面
		draw_pillar(&pillar1,1);    //画柱1
		draw_pillar(&pillar2,1);    //画柱2
		draw_pillar(&pillar3,1);    //画柱2

		draw_bird(&bird,1);			 				//画鸟
	}
	*/
	else
	{
		switch(_game_bird_conf.mode)
		{
			case 1:
				draw_game_start(); //画游戏开始对话框
				break;
			case 3:
				draw_game_over(); //画游戏结束对话框
				break;
		}
	}
	
	
}

//flappy bird主循环
void game_flappy_bird_main(void)
{
	uint32_t _fps_num=0;
	_game_bird_conf.fps_t0=SysTimer_GetLoadValue();
	_game_bird_conf.fps_num=0;
	game_flappy_bird_init();   //初始化
	_game_bird_conf.mode=1;//开始态
	//uint32_t ii=0;
	
	while(_game_bird_conf.mode && switchGameChart==0)
	{
		//FPS
		_fps_num++;
		_game_bird_conf.fps_t1=SysTimer_GetLoadValue()-_game_bird_conf.fps_t0;
		if(_game_bird_conf.fps_t1>=SOC_TIMER_FREQ)
		{
			_game_bird_conf.fps_t0=SysTimer_GetLoadValue();
			_game_bird_conf.fps_num=_fps_num;
			_fps_num=0;
		}
		
		//游戏
		switch(_game_bird_conf.mode)
		{
			case 1:
				game_flappy_bird_start_key();	//	检查
				
				break;
			case 2:
				bird_last=bird;
				pillar1_last=pillar1;
				pillar2_last=pillar2;
				pillar3_last=pillar3;

				game_flappy_bird_run_key();  //按键处理
				game_flappy_bird_logic();//逻辑计算

				break;
			case 3:
				game_flappy_bird_over_key();
				break;
				
		}
		game_flappy_bird_break_key();
		
		game_flappy_bird_draw(); //往缓冲区画图
	}
	
}






