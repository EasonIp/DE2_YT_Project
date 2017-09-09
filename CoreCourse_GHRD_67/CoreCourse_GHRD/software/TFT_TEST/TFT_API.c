#include "TFT_API.h"
#include "stdarg.h"
#include "stdlib.h"
#include "unistd.h"
#include "system.h"

#include "font.h"

/***************************************************************************
*                              显示方向示意图                        O____________\
*                      X(0~479)                  复位键  |            /  X(0~271)
*	 O _______________________\                        |
*	  |                                                |     竖屏
*	  |      横屏(默认)                                 |   LCD_VERTICAL
*     |    LCD_HORIZONTAL                              |
*复位 \|/                                               |
* 键      Y (0~271)                                       |
*                                                      | Y(0~479)
*   技术支持QQ群：472607506                             \|/
*
*******************************************************************************/

//画笔颜色,背景颜色
alt_u16 POINT_COLOR = BLACK,BACK_COLOR = WHITE;

//管理屏幕重要参数，默认为横屏
_lcd_dev lcddev;

/*******************************************************
 *@功能描述:设置LCD显示方向
 *@输入参数:alt_u16 dir: LCD_HORIZONTAL 横屏显示
 *						 LCD_VERTICAL	竖屏显示
 *@返回值  :void
*******************************************************/
void LCD_Dir(alt_u16 dir)
{
	if(dir == LCD_HORIZONTAL)
	{

		lcddev.dir   = LCD_HORIZONTAL;//横屏显示
		lcddev.x_len= 480; //x的总长度
		lcddev.y_len= 272; //y的总长度
	}
	else if(dir == LCD_VERTICAL)
	{
		lcddev.dir   = LCD_VERTICAL;//横屏显示
		lcddev.x_len = 272; //x的总长度
		lcddev.y_len = 480; //y的总长度

}
}

/*******************************************************
 *@功能描述:初始化LCD,用白色清屏
 *@输入参数:void
 *@返回值  :void
*******************************************************/
void LCD_Init(void)
{
	LCD_Dir(LCD_HORIZONTAL);//横屏显示
	LCD_Clear(WHITE);
}

/*******************************************************
 *@功能描述:以POINT_COLOR颜色的在LCD(x,y)处画点
 *@输入参数:alt_u16 x    : x坐标
 *		   alt_u16 y    : y坐标
 *		   alt_u16 color: 点的颜色
 *@返回值  :0:正常, 1:坐标越界
*******************************************************/
alt_u8 LCD_DrawPoint(alt_u16 x,alt_u16 y,alt_u16 color)
{
//如果定义了打点的错误检查，就在打点前检查坐标是否越界。由于后面函数都已经做了检查，所以这里一般不需要
#ifdef DRAWPointCHECK
	if(x>=lcddev.x_len || y>=lcddev.y_len )
	{
			return 1;
	}
#endif

	if(lcddev.dir == LCD_HORIZONTAL)//横屏显示
		TFT_WR_XY(x,y, color);

	else //竖屏
		TFT_WR_XY((lcddev.x_len-1-x)<<9,y,color);

	return 0;
}

/*******************************************************
 *@功能描述:用指定颜色清屏
 *@输入参数:alt_u16 Color: 清屏的颜色
 *@返回值  :void
*******************************************************/
void LCD_Clear(alt_u16 Color)
{
	alt_u16 i,j;
	for(i=0; i<lcddev.x_len; i++)
	{
	  for(j=0; j<lcddev.y_len; j++)
	  {
		  LCD_DrawPoint(i,j,Color);
	  }
	}
}

/*******************************************************
 *@功能描述:在指定区域内填充color指定的颜色
 *@输入参数:alt_u16 sx   : start x,x起始坐标
 *			alt_u16 sy   : start y,y起始坐标
 *			alt_u16 ex   : end y  ,x结束坐标
 *			alt_u16 ey   : end y  ,y结束坐标
 *			alt_u16 color: 填充的颜色
 *@返回值  :0:正常, 1:填充失败
*******************************************************/
alt_u8 LCD_Fill(alt_u16 sx,alt_u16 sy,alt_u16 ex,alt_u16 ey,alt_u16 color)
{
	alt_u16 i=0,j=0;

	//坐标超出显示区域，或者结束坐标大于起始坐标，则直接返回
	if(sx>=lcddev.x_len || sy>=lcddev.y_len || ex>=lcddev.x_len || ey>=lcddev.y_len || sx>ex || sy>ey)
		return 1;

	//正常绘图
	for(i=sx;i<=ex;i++)
	  for(j=sy;j<=ey;j++)
	      LCD_DrawPoint(i,j,color);

	return 0;
}


/*******************************************************
 *@功能描述:以POINT_COLOR指定的颜色画直线
 *@输入参数:alt_u16 x1   : 第一个点的x坐标
 *			alt_u16 y1   : 第一个点的y坐标
 *			alt_u16 x2   : 第二个点的x坐标
 *			alt_u16 y2   : 第二个点的y坐标
 *			alt_u16 color: 线的颜色
 *使用说明 :使用这个函数只要求两个点都在LCD显示范围内，不要求点的相对位置
 *@返回值  :0:正常, 1:画线失败
*******************************************************/
alt_u8 LCD_DrawLine(alt_u16 x1, alt_u16 y1, alt_u16 x2, alt_u16 y2)
{
	alt_u16 t;
	int xerr=0,yerr=0,delta_x,delta_y,distance;
	int incx,incy,uRow,uCol;

	//坐标超出显示区域，则直接返回
	if(x1>=lcddev.x_len || y1>=lcddev.y_len || x2>=lcddev.x_len || y2>=lcddev.y_len)
	{
		return 1;
	}

	delta_x=x2-x1; //计算坐标增量
	delta_y=y2-y1;
	uRow=x1;
	uCol=y1;
	if(delta_x>0)
		incx=1; //x步进为-1
	else if(delta_x==0)
		incx=0;//垂直线
	else {
		incx=-1;//x步进为1
	}

	if(delta_y>0)
		incy=1;
	else if(delta_y==0)
		incy=0;//水平线
	else {
		incy=-1;delta_y=-delta_y;
	}

	if( delta_x>delta_y)
		distance=delta_x; //选取基本增量坐标轴
	else
		distance=delta_y;

	for(t=0;t<=distance+1;t++ )//画线输出
	{
		LCD_DrawPoint(uRow,uCol,POINT_COLOR);//画点
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
	return 0;
}


/*******************************************************
 *@功能描述:以两个点为对角点画矩形
 *@输入参数: alt_u16 xs   : 第一个点的x坐标
 			alt_u16 ys   : 第一个点的y坐标
 			alt_u16 xe   : 第二个点的x坐标
 			alt_u16 ye   : 第二个点的y坐标
 *@返回值  :0:正常, 1:画矩形失败
*******************************************************/
alt_u8 LCD_DrawRectangle(alt_u16 xs, alt_u16 ys, alt_u16 xe, alt_u16 ye)
{
	//坐标超出显示区域，则直接返回
	if(xs>=lcddev.x_len || ys>=lcddev.y_len || xe>=lcddev.x_len || ye>=lcddev.y_len)
	{
		return 1;
	}

	LCD_DrawLine(xs,ys,xe,ys);
	LCD_DrawLine(xs,ys,xs,ye);
	LCD_DrawLine(xs,ye,xe,ye);
	LCD_DrawLine(xe,ys,xe,ye);

	return 0;
}

/*******************************************************
 *@功能描述:画圆
 *@输入参数:alt_u16 x0   : 圆心的x坐标
 *			alt_u16 y0   : 圆心的y坐标
 *			alt_u8  r    : 圆的半径
 *@返回值  :0:正常, 1:画圆失败
*******************************************************/
alt_u8 Draw_Circle(alt_u16 x0,alt_u16 y0,alt_u8 r)
{
	int a,b;
	int di;
	alt_u16 color_tmp=POINT_COLOR;
	a=0;b=r;

    //坐标超出显示区域，则直接返回
	if(r>x0 || r>y0  || (x0+r)>=lcddev.x_len || (y0+r)>=lcddev.y_len)
	{
		return 1;
	}

	di=3-(r<<1);             //判断下个点位置的标志

	while(a<=b)
	{
		LCD_DrawPoint(x0-b,y0-a,color_tmp);             //3
		LCD_DrawPoint(x0+b,y0-a,color_tmp);
		LCD_DrawPoint(x0-a,y0+b,color_tmp);
		LCD_DrawPoint(x0-b,y0-a,color_tmp);
		LCD_DrawPoint(x0-a,y0-b,color_tmp);
		LCD_DrawPoint(x0+b,y0+a,color_tmp);             //4
		LCD_DrawPoint(x0+a,y0-b,color_tmp);
		LCD_DrawPoint(x0+a,y0+b,color_tmp);
		LCD_DrawPoint(x0-b,y0+a,color_tmp);
		a++;
		//使用Bresenham算法画圆
		if(di<0)di +=4*a+6;
		else
		{
			di+=10+4*(a-b);
			b--;
		}
		LCD_DrawPoint(x0+a,y0+b,color_tmp);
	}
	return 0;
}


/*******************************************************
 *@功能描述:在指定位置显示一个字符
 *@输入参数:alt_u16 x        : 显示左上角的x坐标
 *			alt_u16 y        : 显示左上角的y坐标
 *			alt_u8  show     : 要显示的ASCII字符,如:'a','8'
 *			alt_u8  size     : 字体大小 12:1206  16:1608.
 *			alt_u8  overlay  : 1:叠加 0不叠加
 *                           叠加显示适合在图片上显示固定的内容。不叠加适合显示温度、电压等经常变化的值。
 *@返回值  :0:正常, 1:显示字符失败
*******************************************************/
alt_u8 LCD_ShowChar(alt_u16 x,alt_u16 y,alt_u8 show,alt_u8 size,alt_u8 overlay)
{
	alt_u16 MAX_CHAR_POSX =  lcddev.x_len - size;
	alt_u16 MAX_CHAR_POSY =  lcddev.y_len - (size/2);

	alt_u8 num = show;
	alt_u8 temp;
	alt_u8 pos,t;
	alt_u16 x0=x;
	alt_u16 colortmp=POINT_COLOR;

    if(x>MAX_CHAR_POSX || y>MAX_CHAR_POSY)
		return 1;

	num=num-' ';//得到偏移后的值
	if(!overlay) //非叠加方式
	{
		for(pos=0;pos<size;pos++)
		{
			if(size==12)temp=asc2_1206[num][pos];//调用1206字体
			else temp=asc2_1608[num][pos];		 //调用1608字体
			for(t=0;t<size/2;t++)
		    {
		        if(temp&0x01)
		        	LCD_DrawPoint(x,y,colortmp);
				else
		        	LCD_DrawPoint(x,y,BACK_COLOR);

				temp>>=1;
				x++;
		    }
			x=x0;
	        y++;
		}
	}else//叠加方式
	{
		for(pos=0;pos<size;pos++)
		{
			if(size==12)temp=asc2_1206[num][pos];//调用1206字体
			else temp=asc2_1608[num][pos];		 //调用1608字体
			for(t=0;t<size/2;t++)
		    {
				if(temp&0x01)
					LCD_DrawPoint(x,y,colortmp);
				temp>>=1;
		    }
		}
	}
	return 0;
}

//m^n函数
alt_u32 mypow(alt_u8 m,alt_u8 n)
{
	alt_u32 result=1;
	while(n--)result*=m;
	return result;
}

/*******************************************************
 *@功能描述:显示长度为len的数
 *@输入参数:alt_u16 x        : 显示左上角的x坐标
 *			alt_u16 y        : 显示左上角的y坐标
 *			alt_u32 num      : 要显示数(0~4294967295);
 *			alt_u8  len      : 长度
 *			alt_u8  size     : 字体大小 12:1206  16:1608.
 *@返回值  :0:正常, 1:显示整数失败
*******************************************************/
alt_u8 LCD_ShowNum(alt_u16 x,alt_u16 y,alt_u32 num,alt_u8 len,alt_u8 size)
{
	alt_u8 t,temp;
	alt_u8 enshow=0;

	for(t=0;t<len;t++)
	{
		temp=(num/mypow(10,len-t-1))%10;
		if(enshow==0&&t<(len-1))
		{
			if(temp==0)
			{
				if( LCD_ShowChar(x+(size/2)*t,y,' ',size,0) )
					return 1;

				continue;
			}else enshow=1;

		}
	 	LCD_ShowChar(x+(size/2)*t,y,temp+'0',size,0);
	}
	return 0;
}

/*******************************************************
 *@功能描述:用size大小的字体显示字符串
 *@输入参数:alt_u16 x         : 显示左上角的x坐标
 *			alt_u16 y        : 显示左上角的y坐标
 *			alt_u8 size      : 字体大小 12:1206  16:1608.
 *			alt_u8 *p  : 字符串指针
 *@返回值  :0:正常, 1:显示字符串失败
*******************************************************/
alt_u8 LCD_ShowString(alt_u16 x,alt_u16 y,alt_u8 size,char *p)
{
	alt_u16 MAX_CHAR_POSX =  lcddev.x_len - size;
	alt_u16 MAX_CHAR_POSY =  lcddev.y_len - (size/2);

	while(*p!='\0')
    {
        if(x>MAX_CHAR_POSX){x=0;y+=size;}
        if(y>MAX_CHAR_POSY){y=x=0;LCD_Clear(WHITE);}

        if( LCD_ShowChar(x,y,*p,size,0))
        	return 1;

        x+=(size/2);
        p++;
    }
	return 0;
}


/*******************************************************
 *@功能描述:用size大小的字体显示中文
 *@输入参数: alt_u16 x         : 显示左上角的x坐标
 *			alt_u16 y         : 显示左上角的y坐标
 *			alt_u16 size      : 字体大小 输入24则为24*24,48则为48*48，不一定要求是12的整数倍
 *			alt_u8 overlay    : 是否叠加显示
 *			char    *p        : 字模数组指针
 *			alt_u8  num       ： 显示第几个字
 *@返回值  :0:正常, 1:画矩形失败
*******************************************************/
alt_u8 LCD_ShowChinese(alt_u16 x,alt_u16 y,alt_u16 size,alt_u8 overlay,alt_u8 num,const unsigned char *p)
{
	alt_u8 temp;
	alt_u16 i,j,line_byte,line_bit; //line_byte表示一个汉字一列在数组中几个字节,line_bit表示占多少位
	unsigned char * show ;

	line_byte= (alt_u16)((size+7)/8);//由于取模软件1字节对齐，不足8位按8位算
	line_bit = line_byte*8;
	show = (unsigned char*)p;
	show = show+ num*size*line_byte;
	if( x>(lcddev.x_len - size) || y >(lcddev.y_len - size) )
		return 1;

	//为了提高显示效率，显示时，取模软件在最后一字节自动填充的0不考虑，只显示有价值的点
	for(i=0;i<size;i++)
	{
		for(j=0;j<line_bit;j++)
		{
			if(j%8 == 0)
				temp = *show;
			else if( ((j+1)%8)== 0 )
				show++;

			if(j<size)//为了提高显示效率，显示时，取模软件在最后一字节自动填充的0不考虑，只显示有价值的点
			{
				if( temp&0x80 )
					LCD_DrawPoint(x+i,y+j,POINT_COLOR);//按列取模先加y
				else if(overlay == 0)
					LCD_DrawPoint(x+i,y+j,BACK_COLOR);//不叠加显示就用背景色打点

				temp = temp<<1;
			}
		}
	}
	return 0;
}

/*******************************************************
 *@功能描述: 滚动显示中文
 *@输入参数: alt_u16 x         : 显示左上角的x坐标
 *			alt_u16 y         : 显示左上角的y坐标
 *			alt_u16 size      : 字体大小 输入24则为24*24,48则为48*48，不一定要求是12的整数倍
 *			alt_u16 total     : 全部要显示的字数
 *			alt_u16 num       ： 滚动的起始地址在原来第几列
 *			char    *p        : 字模数组指针
 *
 *@返回值  :0:正常, 1:画矩形失败
*******************************************************/
alt_u8 LCD_MoveChinese(alt_u16 x,alt_u16 y,alt_u16 size,alt_u16 total,alt_u16 num,const unsigned char *p)
{
	alt_u8 temp;
	alt_u16 i,j,line_byte,line_bit; //v_byte表示一个汉字一列在数组中几个字节

	unsigned char * show ;

	line_byte= (alt_u16)((size+7)/8);//垂直方向几个Byte，不足一个字节按一个字节计算
	line_bit = line_byte*8;//垂直方向几个bit,不足一个字节按一个字节计算
	show = (unsigned char*)p;
	num = (num % (total*size));
	show = show+ num*line_byte;

	if( x>(lcddev.x_len - size) || y >(lcddev.y_len - size) )
		return 1;

	//为了提高显示效率，显示时，取模软件在最后一字节自动填充的0不考虑，只显示有价值的点
	for(i=0;i<size*total;i++)
	{
		for(j=0;j<line_bit;j++)
		{
			if(j%8 == 0)
				temp = *show;
			else if( ((j+1)%8)== 0 )
				show++;

			if(show >= (unsigned char*)p + line_byte*size*total)
				show =(unsigned char*)p;

			if(j<size)//为了提高显示效率，显示时，取模软件在最后一字节自动填充的0不考虑，只显示有价值的点
			{
				if( temp&0x80 )
					LCD_DrawPoint(x+i,y+j,POINT_COLOR);//按列取模先加y
				else
					LCD_DrawPoint(x+i,y+j,BACK_COLOR);//不叠加显示就用背景色打点

				temp = temp<<1;
			}
		}
	}
	return 0;
}

/***********printf格式化输出到液晶相关函数***********/
_Typedef_lcdprintf lcd_printf =
{
	0,  //光标当前位置
	0,
	0,  //设置显示起始位置
	0,
	7,  //最小宽度，默认最小7位宽度
	3,  //精度，默认3位小数精度
	0,  //显示模式，不叠加显示
	0,  //输出字符清零
};

alt_u32 Equation_Calculate(alt_u8 x, alt_u8 n)
{
	alt_u32 dat=1;
	while(n--)	dat *= x;  //n个x相乘
	return dat;
}

/**
  *****************************************************************************
  * @功能描述: 将数字转换成字符串
  *
  * @输入参数: arr:    要转换的数字
  * 		  strout: 字符串输出缓存
  * @返回值   : 字符串输出指针
  *****************************************************************************
**/
alt_u8 *Array_To_String(alt_u32 arr, alt_u8* strout)
{
	alt_u8 tmp=0,i=0;
	alt_u8 rec=0;

	for(i = 0;i < 10;i++)
	{
		tmp = (arr / (Equation_Calculate(10, 10-i-1))) % 10;    //取得数字的最高位
		if(rec==0 && i<9)  //最后一位不管是不是0都转换
		{
			if(tmp == 0)	continue;  //高位为0不转换
			else  rec = 1;  //不需要转换了
		}
		*strout = tmp + 0x30;
		strout++;
	}
	*strout = '\0';	//加入结束符

	return strout;
}

/**
  *****************************************************************************
  * @功能描述: 获取数值长度
  *			: 数字0返回的位数为0，即输入的数值为0。高位为0的不计算在内，默认从高位开始计算
  *
  * @输入参数: Num: 要检测的数值。数值范围: 0 ~ 4294967295
  * @返回值   : 数值长度，默认最大返回10位
  *****************************************************************************
**/
#define MAX_NUM_LEN          10    //最大返回位数
alt_u8 Get_NumLen(alt_u32 Num)
{
	alt_u8 i=0;
	alt_u8 tmp=0;

	i = MAX_NUM_LEN - 1;    //得到返回位数
	while(1)
	{
		tmp = (Num/Equation_Calculate(10, i)) % 10;    //得到位数
		if(tmp || i==0)
			break;    //完成
		i--;
	}
	     if(i)    return i+1;    //返回数值位数
	else if(tmp)  return 1;    //输入的数值只有一位
	else          return 0;    //输入的是0
}


#define ASCII_HEIGHT 16		//显示字符高度
#define ASCII_WIDTH   8		//显示字符宽度
/**
  *****************************************************************************
  * @功能描述: printf输出字符
  *			:
  *
  * @输入参数: lcd_ch: printf结构体指针
  * 		  ch:     要输出的字符
  *
  * @返回值   : none
  *****************************************************************************
**/
void _printfch(_Typedef_lcdprintf* lcd_ch, const char ch)
{
	if(ch == '\r')  //LF
	{
		lcd_ch->cursorx  = 0;
		lcd_ch->cursory += ASCII_HEIGHT;
		if(lcd_ch->cursory >= lcddev.y_len)
			lcd_ch->cursory = 0;
	}
	else if(ch == '\n')  //CR
	{
		lcd_ch->cursorx  = lcd_ch->cursorx0 - ASCII_WIDTH;
		lcd_ch->cursory += ASCII_HEIGHT;
		if(lcd_ch->cursory >= lcddev.y_len)
			lcd_ch->cursory = 0;
	}
	else if(ch == '\t')  //Tab
	{
		lcd_ch->cursorx += (ASCII_WIDTH * 3);  //默认4个字符宽度
		if(lcd_ch->cursorx >= lcddev.x_len)  lcd_ch->cursorx = 0;
	}
	else  //en
	{
		LCD_ShowChar(lcd_ch->cursorx, lcd_ch->cursory,ch,16,0);
		lcd_ch->charcnt++;
	}
}

/**
  *****************************************************************************
  * @功能描述: printf输出字符
  *			:
  *
  * @输入参数: lcd_st: printf结构体指针
  * 		  *str:   要输出的字符串
  *
  * @返回值   : none
  *****************************************************************************
**/
void _printfstr(_Typedef_lcdprintf* lcd_st, const char *str)
{
	for(;*str != '\0';str++)
	{
		if(*str < 0x80)  //en
		{
			_printfch(lcd_st, *str);
			lcd_st->cursorx += ASCII_WIDTH;
			if(lcd_st->cursorx >= lcddev.x_len)  lcd_st->cursory += ASCII_HEIGHT;
			if(lcd_st->cursory >= lcddev.y_len)  {lcd_st->cursory = 0;lcd_st->cursorx = 0;}
		}
	}
}

/**
  *****************************************************************************
  * @Name   : printf输出数字
  *
  * @Brief  : none
  *
  * @Input  : lcd_st: printf结构体指针
  *           dec:    要输出的数字
  *
  * @Output : none
  *
  * @Return : none
  *****************************************************************************
**/
void _printfint(_Typedef_lcdprintf* lcd_dec, const int dec)
{
	char st[10];
	int tmp = dec;

	if(tmp == 0)  return;
	else if(tmp < 0)  //负数
	{
		tmp = -tmp;
		_printfch(lcd_dec, '-');
		lcd_dec->cursorx += ASCII_WIDTH;
	}

	Array_To_String    ((alt_u32)tmp, (alt_u8*)st);
	_printfstr(lcd_dec, (const char *)st);
}

/**
  *****************************************************************************
  * @Name   : printf输出浮点数
  *
  * @Brief  : none
  *
  * @Input  : lcd_st: printf结构体指针
  *           flt:    要输出的浮点数
  *
  * @Output : none
  *
  * @Return : none
  *****************************************************************************
**/
void _printfflt(_Typedef_lcdprintf* lcd_dec, const float flt)
{
	int pre=0;
	int flt_int=0;
	int flt_flo=0;
	float tmp=flt;

	if(tmp < 0)
	{
		tmp = -tmp;
		_printfch(lcd_dec, '-');
		lcd_dec->cursorx += ASCII_WIDTH;
	}

	pre = (int)Equation_Calculate(10, lcd_dec->precision);  //得到小数精度
	flt_int = (int)(tmp);  //整数
	flt_flo = (int)((tmp - flt_int) * pre);  //小数

	pre = (int)Equation_Calculate(10, (lcd_dec->min_width - lcd_dec->precision - 1));

	_printfint(lcd_dec, flt_int%pre);  //显示整数位
	_printfch(lcd_dec, '.');
	lcd_dec->cursorx += ASCII_WIDTH;
	_printfint(lcd_dec, flt_flo);  //显示小数位
}

/**
  *****************************************************************************
  * @Name   : printf输出十六进制数
  *
  * @Brief  : none
  *
  * @Input  : lcd_st: printf结构体指针
  *           Hex:    要输出的十六进制数
  *           index:  要转换的进制数。16: 十六进制；8: 八进制
  *
  * @Output : none
  *
  * @Return : none
  *****************************************************************************
**/
void _printfhex(_Typedef_lcdprintf* lcd_hex, const int Hex, int index)
{
	char HexIndex[16] = "0123456789ABCDEF";
	char str[16];
	char tmp=0;
	int i = 0,j = 0;
	int temp=Hex;

	do
	{
		str[i++] = HexIndex[temp%index];
		temp /= index;
	}while(temp);
	str[i] = '\0';

	//字符串倒序
	for(j = 0;j <(i-1)/2;j++)
	{
		tmp = str[j];
		str[j] = str[i-1-j];
		str[i-1-j] = tmp;
	}

	if(index == 16)  //十六进制
	{
		_printfch(lcd_hex, '0');lcd_hex->cursorx += ASCII_WIDTH;
		_printfch(lcd_hex, 'x');lcd_hex->cursorx += ASCII_WIDTH;
	}
	else if(index == 8)  //八进制
	{
		_printfch(lcd_hex, '0');lcd_hex->cursorx += ASCII_WIDTH;
	}
	_printfstr(lcd_hex, (const char *)str);
}


/**
  *****************************************************************************
  * @功能描述 : printf格式化输出到液晶
  *
  * @输入参数 : lcd_ch: printf结构体指针
  *           format: 格式化字符串
  *           ...:    长参数
  *
  *
  * @返回值   : none
  *****************************************************************************
**/
int LCD_printf(_Typedef_lcdprintf* lcd_pr, const alt_u8 *format, ...)
{
    const char *str;
    char c=0;
    float valflt=0;
    int dec=0;
    alt_u8 index=0;

    va_list ap;
    va_start(ap, format);

    lcd_pr->min_width = 7;
    lcd_pr->precision = 3;
    lcd_pr->charcnt   = 0;

    while(*format != '\0')  //直到遇到结束符
    {
        if(*format == 0x5c)  //符号'\'
        {
            format++;
            switch(*format)
            {
                case 'r':  //LF
                        _printfch(lcd_pr, '\r');
                        format++;
                        break;

                case 'n':  //CR
                        _printfch(lcd_pr, '\n');
                        format++;
                        break;

                case 't':  //Tab
                        _printfch(lcd_pr, '\t');
                        format++;
                        break;

                default:
                        format++;
                        break;
            }
        }
        else if(*format == '%')  //带格式输出
        {
            format++;
            index = 0;
            lcd_pr->min_width = 0;
            while((*format <= '9') && (*format >= '0'))  //域宽
            {
                lcd_pr->min_width = (lcd_pr->min_width * index * 10) + (*format - '0');
                index++;
                format++;
            }
            if(*format == '.')  //检测到点
            {
                format++;
                index = 0;
                lcd_pr->precision = 0;
                while((*format <= '9') && (*format >= '0'))  //精度
                {
                    lcd_pr->precision = (lcd_pr->precision * index * 10) + (*format - '0');
                    index++;
                    format++;
                }
            }
            switch(*format)  //检测格式码
            {
                case '%':  //输出%符号
                        _printfch(lcd_pr, '%');
                        lcd_pr->cursorx += ASCII_WIDTH;
                        format++;
                        break;

                case 'c':  //输出字符
                        c = va_arg(ap, int);
                        _printfch(lcd_pr, c);
                        format++;
                        break;

                case 'S':
                case 's':  //输出字符串
                        str = va_arg(ap, const char *);
                        _printfstr(lcd_pr, (char*)str);
                        format++;
                        break;

                case 'd':  //输出十进制数
                        dec = va_arg(ap, int);
                        _printfint(lcd_pr, dec);
                        format++;
                        break;

                case 'f':  //输出浮点数
                        valflt = va_arg(ap, double);
                        _printfflt(lcd_pr, valflt);
                        format++;
                        break;

                case 'X':
                case 'x':  //输出十六进制数
                        dec = va_arg(ap, int);
                        _printfhex(lcd_pr, dec, 16);
                        format++;
                        break;

                case 'o':  //输出八进制数
                        dec = va_arg(ap, int);
                        _printfhex(lcd_pr, dec, 8);
                        format++;
                        break;

                case 'm':
                        dec = va_arg(ap, int);
                        if(dec > 21)  dec = 21;  //限制最大的域宽是21，包括小数点
                        lcd_pr->min_width = (alt_u16)dec;
                        format++;
                        if(*format == '.')
                        {
                            format++;
                            if(*format == 'n')
                            {
                                dec = va_arg(ap, int);
                                if(dec > 8)  dec = 8;  //限制最小的小数精度是，0.00000001
                                lcd_pr->precision = (alt_u16)dec;
                                format++;
                                if(*format == 'f')
                                {
                                    valflt = va_arg(ap, double);
                                    _printfflt(lcd_pr, valflt);
                                    format++;
                                }
                            }
                        }
                        break;

                default:
                        _printfch(lcd_pr, *format);
                        format++;
                        break;
            }  //end check format
        }
        else if(*format < 0x80)  //字符输出
        {
            _printfch(lcd_pr, *format);
            lcd_pr->cursorx += ASCII_WIDTH;  //下一个字符位置--暂时使用16
            format++;
        }
        //由于没有SD卡字库，暂时不支持中文显示
    }//end while
    va_end(ap);

    return (int)lcd_pr->charcnt;
}
