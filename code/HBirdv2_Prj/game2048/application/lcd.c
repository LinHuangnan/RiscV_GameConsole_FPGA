#include "global.h"
#include "FONT.h" 
#include "lcd.h"





//读取个某点的颜色值	 
//x,y:坐标
//返回值:此点的颜色
uint16_t LCD_ReadPoint(uint16_t x,uint16_t y)
{
	return *(LCD_P+y*LCD_W_MAX+x);
}			 

//画点
//x,y:坐标
//POINT_COLOR:此点的颜色
void LCD_DrawPoint(uint16_t x,uint16_t y)
{
	*(LCD_P+y*LCD_W_MAX+x)=POINT_COLOR;
}

//设置窗口,并自动设置画点坐标到窗口左上角(sx,sy).
//sx,sy:窗口起始坐标(左上角)
//width,height:窗口宽度和高度,必须大于0!!
//窗体大小:width*height. 
void LCD_Set_Window(uint16_t sx,uint16_t sy,uint16_t width,uint16_t height)
{    

}
//初始化lcd
void LCD_Init(void)
{ 	 
	LCD_Clear(WHITE);
}  
//清屏函数
//color:要清屏的填充色
void LCD_Clear(uint16_t color)
{
	//每个像素点是16位宽的
	//可以把两个16位宽的像素组成一个32位宽的像素一次性写入，从而减少写入次数
	//经过测试，用时可以减少一半
	uint32_t*P=(uint32_t*)0x80200000;
	uint32_t color_n2w= (uint32_t)color<<16;
	color_n2w = color_n2w + color;
	for(int i=0;i<LCD_H_MAX;i++)
	{
		for(int j=0;j<LCD_W_MAX/2;j++)
		{
			*(P+i*LCD_W_MAX/2+j)=color_n2w;
		}
	}
}  
//在指定区域内填充单个颜色
//(sx,sy),(ex,ey):填充矩形对角坐标,区域大小为:(ex-sx+1)*(ey-sy+1)   
//color:要填充的颜色
void LCD_Fill(int16_t sx,int16_t sy,uint16_t w,uint16_t h,uint16_t color)
{          



	
    int16_t ex=sx+w;
    int16_t ey=sy+h;
	if(sx<0)sx=0;
	if(sy<0)sy=0;
	if(sx>640)sx=640;
	if(sy>480)sy=480;
    if(ex>640)ex=640;
    if(ey>480)ey=480;
	if(ex<0)ex=0;
    if(ey<0)ey=0;
	for(int16_t i=sy;i<ey;i++)
	{
		for(int16_t j=sx;j<ex;j++)
		{
			*(LCD_P+i*LCD_W_MAX+j)=color;
		}
	}
}  
//在指定区域内填充指定颜色块			 
//(sx,sy),(ex,ey):填充矩形对角坐标,区域大小为:(ex-sx+1)*(ey-sy+1)   
//color:要填充的颜色
void LCD_Color_Fill(uint16_t sx,uint16_t sy,uint16_t ex,uint16_t ey,uint16_t *color)
{  
	uint16_t height,width;
	uint16_t i,j;
	width=ex-sx+1; 			//得到填充的宽度
	height=ey-sy+1;			//高度
 	for(i=0;i<height;i++)
	{
		for(j=0;j<width;j++)
		{	
			*(LCD_P+i*LCD_W_MAX+j)=color[i*width+j];
		}
	}		  
}  
//画线
//x1,y1:起点坐标
//x2,y2:终点坐标  
void LCD_DrawLine(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2,uint16_t color)
{
	
	uint16_t t; 
	int xerr=0,yerr=0,delta_x,delta_y,distance; 
	int incx,incy,uRow,uCol; 
	delta_x=x2-x1; //计算坐标增量 
	delta_y=y2-y1; 
	uRow=x1; 
	uCol=y1; 
	if(delta_x>0)incx=1; //设置单步方向 
	else if(delta_x==0)incx=0;//垂直线 
	else {incx=-1;delta_x=-delta_x;} 
	if(delta_y>0)incy=1; 
	else if(delta_y==0)incy=0;//水平线 
	else{incy=-1;delta_y=-delta_y;} 
	if( delta_x>delta_y)distance=delta_x; //选取基本增量坐标轴 
	else distance=delta_y; 
	for(t=0;t<=distance+1;t++ )//画线输出 
	{  
		*(LCD_P+uCol*LCD_W_MAX+uRow)=color;//画点 
		//LCD_DrawPoint(uRow,uCol);
		xerr+=delta_x ; 
		yerr+=delta_y ; 
		if(xerr>distance) 
		{ 
			xerr-=distance; 
			uRow+=incx; 
		} 
		if(yerr>distance) 
		{ 
			yerr-=distance; 
			uCol+=incy; 
		} 
	}  
}    
//画矩形	  
//(x1,y1),(x2,y2):矩形的对角坐标
void LCD_DrawRectangle(int16_t x1, int16_t y1, uint16_t w, uint16_t h,uint16_t color)
{
	int16_t x2=x1+w;
    int16_t y2=y1+h;
	if(x1<0)x1=0;
	if(y1<0)y1=0;
	if(x1>640)x1=640;
	if(y1>480)y1=480;
    if(x2>640)x2=640;
    if(y2>480)y2=480;
	if(x2<0)x2=0;
    if(y2<0)y2=0;
    for(int16_t ii=x1;ii<x2;ii++)
    {
        *(LCD_P+y1*LCD_W_MAX+ii)=color;
        *(LCD_P+(y2-1)*LCD_W_MAX+ii)=color;

    }
    for(int16_t ii=y1;ii<y2;ii++)
    {
        *(LCD_P+ii*LCD_W_MAX+x1)=color;
        *(LCD_P+ii*LCD_W_MAX+x2-1)=color;
    }

    //这里不调用画线来画矩形，可以使速度更快
	//LCD_DrawLine(x1,y1,x2,y1,color);
	//LCD_DrawLine(x1,y1,x1,y2,color);
	//LCD_DrawLine(x1,y2,x2,y2,color);
	//LCD_DrawLine(x2,y1,x2,y2,color);
}
//在指定位置画一个指定大小的圆
//(x,y):中心点
//r    :半径
void LCD_Draw_Circle(uint16_t x0,uint16_t y0,uint16_t r,uint16_t color)
{
	int a,b;
	int di;
	a=0;b=r;	  
	di=3-(r<<1);             //判断下个点位置的标志
	while(a<=b)
	{
		*(LCD_P+(y0-b)*LCD_W_MAX+(x0+a))=color;
		*(LCD_P+(y0-a)*LCD_W_MAX+(x0+b))=color;
		*(LCD_P+(y0+a)*LCD_W_MAX+(x0+b))=color;
		*(LCD_P+(y0+b)*LCD_W_MAX+(x0+a))=color;
		*(LCD_P+(y0+b)*LCD_W_MAX+(x0-a))=color;
		*(LCD_P+(y0+a)*LCD_W_MAX+(x0-b))=color;
		*(LCD_P+(y0-b)*LCD_W_MAX+(x0-a))=color;
		*(LCD_P+(y0-a)*LCD_W_MAX+(x0-b))=color;
		a++;
		//使用Bresenham算法画圆     
		if(di<0)di +=4*a+6;	  
		else
		{
			di+=10+4*(a-b);   
			b--;
		} 						    
	}
} 									  
//在指定位置显示一个字符
//x,y:起始坐标
//num:要显示的字符:" "--->"~"
//size:字体大小 12/16/24
//mode:叠加方式(1)还是非叠加方式(0)
void LCD_ShowChar(uint16_t x,uint16_t y,uint8_t num,uint8_t size,uint8_t mode)
{  							  
    uint8_t temp,t1,t;
	uint16_t y0=y;
	uint8_t csize=(size/8+((size%8)?1:0))*(size/2);		//得到字体一个字符对应点阵集所占的字节数	
 	num=num-' ';//得到偏移后的值（ASCII字库是从空格开始取模，所以-' '就是对应字符的字库）
	for(t=0;t<csize;t++)
	{   
		if(size==12)temp=asc2_1206[num][t]; 	 	//调用1206字体
		else if(size==16)temp=asc2_1608[num][t];	//调用1608字体
		else if(size==24)temp=asc2_2412[num][t];	//调用2412字体
		else return;								//没有的字库
		for(t1=0;t1<8;t1++)
		{			    
			if(temp&0x80)
			{
				*(LCD_P+y*LCD_W_MAX+x)=POINT_COLOR;
			}
			else if(mode==0)
			{
				*(LCD_P+y*LCD_W_MAX+x)=BACK_COLOR;
			}
			temp<<=1;
			y++;
			if(y>=LCD_H_MAX)return;		//超区域了
			if((y-y0)==size)
			{
				y=y0;
				x++;
				if(x>=LCD_W_MAX)return;	//超区域了
				break;
			}
		}  	 
	}  	    	   	 	  
}   
//m^n函数
//返回值:m^n次方.
uint32_t LCD_Pow(uint8_t m,uint8_t n)
{
	uint32_t result=1;	 
	while(n--)result*=m;    
	return result;
}			 
//显示数字,高位为0,则不显示
//x,y :起点坐标	 
//len :数字的位数
//size:字体大小
//color:颜色 
//num:数值(0~4294967295);	 
void LCD_ShowNum(uint16_t x,uint16_t y,uint32_t num,uint8_t len,uint8_t size)
{         	
	uint8_t t,temp;
	uint8_t enshow=0;						   
	for(t=0;t<len;t++)
	{
		temp=(num/LCD_Pow(10,len-t-1))%10;
		if(enshow==0&&t<(len-1))
		{
			if(temp==0)
			{
				LCD_ShowChar(x+(size/2)*t,y,' ',size,0);
				continue;
			}else enshow=1; 
		 	 
		}
	 	LCD_ShowChar(x+(size/2)*t,y,temp+'0',size,0); 
	}
} 
//显示数字,高位为0,还是显示
//x,y:起点坐标
//num:数值(0~999999999);	 
//len:长度(即要显示的位数)
//size:字体大小
//mode:
//[7]:0,不填充;1,填充0.
//[6:1]:保留
//[0]:0,非叠加显示;1,叠加显示.
void LCD_ShowxNum(uint16_t x,uint16_t y,uint32_t num,uint8_t len,uint8_t size,uint8_t mode)
{  
	uint8_t t,temp;
	uint8_t enshow=0;						   
	for(t=0;t<len;t++)
	{
		temp=(num/LCD_Pow(10,len-t-1))%10;
		if(enshow==0&&t<(len-1))
		{
			if(temp==0)
			{
				if(mode&0X80)LCD_ShowChar(x+(size/2)*t,y,'0',size,mode&0X01);  
				else LCD_ShowChar(x+(size/2)*t,y,' ',size,mode&0X01);  
 				continue;
			}else enshow=1; 
		 	 
		}
	 	LCD_ShowChar(x+(size/2)*t,y,temp+'0',size,mode&0X01); 
	}
} 
//显示字符串
//x,y:起点坐标
//width,height:区域大小  
//size:字体大小
//*p:字符串起始地址		  
void LCD_ShowString(uint16_t x,uint16_t y,uint16_t width,uint16_t height,uint8_t size,uint8_t *p)
{         
	uint8_t x0=x;
	width+=x;
	height+=y;
    while((*p<='~')&&(*p>=' '))//判断是不是非法字符!
    {       
        if(x>=width){x=x0;y+=size;}
        if(y>=height)break;//退出
        LCD_ShowChar(x,y,*p,size,0);
        x+=size/2;
        p++;
    }  
}






























