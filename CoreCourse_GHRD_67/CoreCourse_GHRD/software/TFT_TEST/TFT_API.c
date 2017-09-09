#include "TFT_API.h"
#include "stdarg.h"
#include "stdlib.h"
#include "unistd.h"
#include "system.h"

#include "font.h"

/***************************************************************************
*                              ��ʾ����ʾ��ͼ                        O____________\
*                      X(0~479)                  ��λ��  |            /  X(0~271)
*	 O _______________________\                        |
*	  |                                                |     ����
*	  |      ����(Ĭ��)                                 |   LCD_VERTICAL
*     |    LCD_HORIZONTAL                              |
*��λ \|/                                               |
* ��      Y (0~271)                                       |
*                                                      | Y(0~479)
*   ����֧��QQȺ��472607506                             \|/
*
*******************************************************************************/

//������ɫ,������ɫ
alt_u16 POINT_COLOR = BLACK,BACK_COLOR = WHITE;

//������Ļ��Ҫ������Ĭ��Ϊ����
_lcd_dev lcddev;

/*******************************************************
 *@��������:����LCD��ʾ����
 *@�������:alt_u16 dir: LCD_HORIZONTAL ������ʾ
 *						 LCD_VERTICAL	������ʾ
 *@����ֵ  :void
*******************************************************/
void LCD_Dir(alt_u16 dir)
{
	if(dir == LCD_HORIZONTAL)
	{

		lcddev.dir   = LCD_HORIZONTAL;//������ʾ
		lcddev.x_len= 480; //x���ܳ���
		lcddev.y_len= 272; //y���ܳ���
	}
	else if(dir == LCD_VERTICAL)
	{
		lcddev.dir   = LCD_VERTICAL;//������ʾ
		lcddev.x_len = 272; //x���ܳ���
		lcddev.y_len = 480; //y���ܳ���

}
}

/*******************************************************
 *@��������:��ʼ��LCD,�ð�ɫ����
 *@�������:void
 *@����ֵ  :void
*******************************************************/
void LCD_Init(void)
{
	LCD_Dir(LCD_HORIZONTAL);//������ʾ
	LCD_Clear(WHITE);
}

/*******************************************************
 *@��������:��POINT_COLOR��ɫ����LCD(x,y)������
 *@�������:alt_u16 x    : x����
 *		   alt_u16 y    : y����
 *		   alt_u16 color: �����ɫ
 *@����ֵ  :0:����, 1:����Խ��
*******************************************************/
alt_u8 LCD_DrawPoint(alt_u16 x,alt_u16 y,alt_u16 color)
{
//��������˴��Ĵ����飬���ڴ��ǰ��������Ƿ�Խ�硣���ں��溯�����Ѿ����˼�飬��������һ�㲻��Ҫ
#ifdef DRAWPointCHECK
	if(x>=lcddev.x_len || y>=lcddev.y_len )
	{
			return 1;
	}
#endif

	if(lcddev.dir == LCD_HORIZONTAL)//������ʾ
		TFT_WR_XY(x,y, color);

	else //����
		TFT_WR_XY((lcddev.x_len-1-x)<<9,y,color);

	return 0;
}

/*******************************************************
 *@��������:��ָ����ɫ����
 *@�������:alt_u16 Color: ��������ɫ
 *@����ֵ  :void
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
 *@��������:��ָ�����������colorָ������ɫ
 *@�������:alt_u16 sx   : start x,x��ʼ����
 *			alt_u16 sy   : start y,y��ʼ����
 *			alt_u16 ex   : end y  ,x��������
 *			alt_u16 ey   : end y  ,y��������
 *			alt_u16 color: ������ɫ
 *@����ֵ  :0:����, 1:���ʧ��
*******************************************************/
alt_u8 LCD_Fill(alt_u16 sx,alt_u16 sy,alt_u16 ex,alt_u16 ey,alt_u16 color)
{
	alt_u16 i=0,j=0;

	//���곬����ʾ���򣬻��߽������������ʼ���꣬��ֱ�ӷ���
	if(sx>=lcddev.x_len || sy>=lcddev.y_len || ex>=lcddev.x_len || ey>=lcddev.y_len || sx>ex || sy>ey)
		return 1;

	//������ͼ
	for(i=sx;i<=ex;i++)
	  for(j=sy;j<=ey;j++)
	      LCD_DrawPoint(i,j,color);

	return 0;
}


/*******************************************************
 *@��������:��POINT_COLORָ������ɫ��ֱ��
 *@�������:alt_u16 x1   : ��һ�����x����
 *			alt_u16 y1   : ��һ�����y����
 *			alt_u16 x2   : �ڶ������x����
 *			alt_u16 y2   : �ڶ������y����
 *			alt_u16 color: �ߵ���ɫ
 *ʹ��˵�� :ʹ���������ֻҪ�������㶼��LCD��ʾ��Χ�ڣ���Ҫ�������λ��
 *@����ֵ  :0:����, 1:����ʧ��
*******************************************************/
alt_u8 LCD_DrawLine(alt_u16 x1, alt_u16 y1, alt_u16 x2, alt_u16 y2)
{
	alt_u16 t;
	int xerr=0,yerr=0,delta_x,delta_y,distance;
	int incx,incy,uRow,uCol;

	//���곬����ʾ������ֱ�ӷ���
	if(x1>=lcddev.x_len || y1>=lcddev.y_len || x2>=lcddev.x_len || y2>=lcddev.y_len)
	{
		return 1;
	}

	delta_x=x2-x1; //������������
	delta_y=y2-y1;
	uRow=x1;
	uCol=y1;
	if(delta_x>0)
		incx=1; //x����Ϊ-1
	else if(delta_x==0)
		incx=0;//��ֱ��
	else {
		incx=-1;//x����Ϊ1
	}

	if(delta_y>0)
		incy=1;
	else if(delta_y==0)
		incy=0;//ˮƽ��
	else {
		incy=-1;delta_y=-delta_y;
	}

	if( delta_x>delta_y)
		distance=delta_x; //ѡȡ��������������
	else
		distance=delta_y;

	for(t=0;t<=distance+1;t++ )//�������
	{
		LCD_DrawPoint(uRow,uCol,POINT_COLOR);//����
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
 *@��������:��������Ϊ�Խǵ㻭����
 *@�������: alt_u16 xs   : ��һ�����x����
 			alt_u16 ys   : ��һ�����y����
 			alt_u16 xe   : �ڶ������x����
 			alt_u16 ye   : �ڶ������y����
 *@����ֵ  :0:����, 1:������ʧ��
*******************************************************/
alt_u8 LCD_DrawRectangle(alt_u16 xs, alt_u16 ys, alt_u16 xe, alt_u16 ye)
{
	//���곬����ʾ������ֱ�ӷ���
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
 *@��������:��Բ
 *@�������:alt_u16 x0   : Բ�ĵ�x����
 *			alt_u16 y0   : Բ�ĵ�y����
 *			alt_u8  r    : Բ�İ뾶
 *@����ֵ  :0:����, 1:��Բʧ��
*******************************************************/
alt_u8 Draw_Circle(alt_u16 x0,alt_u16 y0,alt_u8 r)
{
	int a,b;
	int di;
	alt_u16 color_tmp=POINT_COLOR;
	a=0;b=r;

    //���곬����ʾ������ֱ�ӷ���
	if(r>x0 || r>y0  || (x0+r)>=lcddev.x_len || (y0+r)>=lcddev.y_len)
	{
		return 1;
	}

	di=3-(r<<1);             //�ж��¸���λ�õı�־

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
		//ʹ��Bresenham�㷨��Բ
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
 *@��������:��ָ��λ����ʾһ���ַ�
 *@�������:alt_u16 x        : ��ʾ���Ͻǵ�x����
 *			alt_u16 y        : ��ʾ���Ͻǵ�y����
 *			alt_u8  show     : Ҫ��ʾ��ASCII�ַ�,��:'a','8'
 *			alt_u8  size     : �����С 12:1206  16:1608.
 *			alt_u8  overlay  : 1:���� 0������
 *                           ������ʾ�ʺ���ͼƬ����ʾ�̶������ݡ��������ʺ���ʾ�¶ȡ���ѹ�Ⱦ����仯��ֵ��
 *@����ֵ  :0:����, 1:��ʾ�ַ�ʧ��
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

	num=num-' ';//�õ�ƫ�ƺ��ֵ
	if(!overlay) //�ǵ��ӷ�ʽ
	{
		for(pos=0;pos<size;pos++)
		{
			if(size==12)temp=asc2_1206[num][pos];//����1206����
			else temp=asc2_1608[num][pos];		 //����1608����
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
	}else//���ӷ�ʽ
	{
		for(pos=0;pos<size;pos++)
		{
			if(size==12)temp=asc2_1206[num][pos];//����1206����
			else temp=asc2_1608[num][pos];		 //����1608����
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

//m^n����
alt_u32 mypow(alt_u8 m,alt_u8 n)
{
	alt_u32 result=1;
	while(n--)result*=m;
	return result;
}

/*******************************************************
 *@��������:��ʾ����Ϊlen����
 *@�������:alt_u16 x        : ��ʾ���Ͻǵ�x����
 *			alt_u16 y        : ��ʾ���Ͻǵ�y����
 *			alt_u32 num      : Ҫ��ʾ��(0~4294967295);
 *			alt_u8  len      : ����
 *			alt_u8  size     : �����С 12:1206  16:1608.
 *@����ֵ  :0:����, 1:��ʾ����ʧ��
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
 *@��������:��size��С��������ʾ�ַ���
 *@�������:alt_u16 x         : ��ʾ���Ͻǵ�x����
 *			alt_u16 y        : ��ʾ���Ͻǵ�y����
 *			alt_u8 size      : �����С 12:1206  16:1608.
 *			alt_u8 *p  : �ַ���ָ��
 *@����ֵ  :0:����, 1:��ʾ�ַ���ʧ��
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
 *@��������:��size��С��������ʾ����
 *@�������: alt_u16 x         : ��ʾ���Ͻǵ�x����
 *			alt_u16 y         : ��ʾ���Ͻǵ�y����
 *			alt_u16 size      : �����С ����24��Ϊ24*24,48��Ϊ48*48����һ��Ҫ����12��������
 *			alt_u8 overlay    : �Ƿ������ʾ
 *			char    *p        : ��ģ����ָ��
 *			alt_u8  num       �� ��ʾ�ڼ�����
 *@����ֵ  :0:����, 1:������ʧ��
*******************************************************/
alt_u8 LCD_ShowChinese(alt_u16 x,alt_u16 y,alt_u16 size,alt_u8 overlay,alt_u8 num,const unsigned char *p)
{
	alt_u8 temp;
	alt_u16 i,j,line_byte,line_bit; //line_byte��ʾһ������һ���������м����ֽ�,line_bit��ʾռ����λ
	unsigned char * show ;

	line_byte= (alt_u16)((size+7)/8);//����ȡģ���1�ֽڶ��룬����8λ��8λ��
	line_bit = line_byte*8;
	show = (unsigned char*)p;
	show = show+ num*size*line_byte;
	if( x>(lcddev.x_len - size) || y >(lcddev.y_len - size) )
		return 1;

	//Ϊ�������ʾЧ�ʣ���ʾʱ��ȡģ��������һ�ֽ��Զ�����0�����ǣ�ֻ��ʾ�м�ֵ�ĵ�
	for(i=0;i<size;i++)
	{
		for(j=0;j<line_bit;j++)
		{
			if(j%8 == 0)
				temp = *show;
			else if( ((j+1)%8)== 0 )
				show++;

			if(j<size)//Ϊ�������ʾЧ�ʣ���ʾʱ��ȡģ��������һ�ֽ��Զ�����0�����ǣ�ֻ��ʾ�м�ֵ�ĵ�
			{
				if( temp&0x80 )
					LCD_DrawPoint(x+i,y+j,POINT_COLOR);//����ȡģ�ȼ�y
				else if(overlay == 0)
					LCD_DrawPoint(x+i,y+j,BACK_COLOR);//��������ʾ���ñ���ɫ���

				temp = temp<<1;
			}
		}
	}
	return 0;
}

/*******************************************************
 *@��������: ������ʾ����
 *@�������: alt_u16 x         : ��ʾ���Ͻǵ�x����
 *			alt_u16 y         : ��ʾ���Ͻǵ�y����
 *			alt_u16 size      : �����С ����24��Ϊ24*24,48��Ϊ48*48����һ��Ҫ����12��������
 *			alt_u16 total     : ȫ��Ҫ��ʾ������
 *			alt_u16 num       �� ��������ʼ��ַ��ԭ���ڼ���
 *			char    *p        : ��ģ����ָ��
 *
 *@����ֵ  :0:����, 1:������ʧ��
*******************************************************/
alt_u8 LCD_MoveChinese(alt_u16 x,alt_u16 y,alt_u16 size,alt_u16 total,alt_u16 num,const unsigned char *p)
{
	alt_u8 temp;
	alt_u16 i,j,line_byte,line_bit; //v_byte��ʾһ������һ���������м����ֽ�

	unsigned char * show ;

	line_byte= (alt_u16)((size+7)/8);//��ֱ���򼸸�Byte������һ���ֽڰ�һ���ֽڼ���
	line_bit = line_byte*8;//��ֱ���򼸸�bit,����һ���ֽڰ�һ���ֽڼ���
	show = (unsigned char*)p;
	num = (num % (total*size));
	show = show+ num*line_byte;

	if( x>(lcddev.x_len - size) || y >(lcddev.y_len - size) )
		return 1;

	//Ϊ�������ʾЧ�ʣ���ʾʱ��ȡģ��������һ�ֽ��Զ�����0�����ǣ�ֻ��ʾ�м�ֵ�ĵ�
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

			if(j<size)//Ϊ�������ʾЧ�ʣ���ʾʱ��ȡģ��������һ�ֽ��Զ�����0�����ǣ�ֻ��ʾ�м�ֵ�ĵ�
			{
				if( temp&0x80 )
					LCD_DrawPoint(x+i,y+j,POINT_COLOR);//����ȡģ�ȼ�y
				else
					LCD_DrawPoint(x+i,y+j,BACK_COLOR);//��������ʾ���ñ���ɫ���

				temp = temp<<1;
			}
		}
	}
	return 0;
}

/***********printf��ʽ�������Һ����غ���***********/
_Typedef_lcdprintf lcd_printf =
{
	0,  //��굱ǰλ��
	0,
	0,  //������ʾ��ʼλ��
	0,
	7,  //��С��ȣ�Ĭ����С7λ���
	3,  //���ȣ�Ĭ��3λС������
	0,  //��ʾģʽ����������ʾ
	0,  //����ַ�����
};

alt_u32 Equation_Calculate(alt_u8 x, alt_u8 n)
{
	alt_u32 dat=1;
	while(n--)	dat *= x;  //n��x���
	return dat;
}

/**
  *****************************************************************************
  * @��������: ������ת�����ַ���
  *
  * @�������: arr:    Ҫת��������
  * 		  strout: �ַ����������
  * @����ֵ   : �ַ������ָ��
  *****************************************************************************
**/
alt_u8 *Array_To_String(alt_u32 arr, alt_u8* strout)
{
	alt_u8 tmp=0,i=0;
	alt_u8 rec=0;

	for(i = 0;i < 10;i++)
	{
		tmp = (arr / (Equation_Calculate(10, 10-i-1))) % 10;    //ȡ�����ֵ����λ
		if(rec==0 && i<9)  //���һλ�����ǲ���0��ת��
		{
			if(tmp == 0)	continue;  //��λΪ0��ת��
			else  rec = 1;  //����Ҫת����
		}
		*strout = tmp + 0x30;
		strout++;
	}
	*strout = '\0';	//���������

	return strout;
}

/**
  *****************************************************************************
  * @��������: ��ȡ��ֵ����
  *			: ����0���ص�λ��Ϊ0�����������ֵΪ0����λΪ0�Ĳ��������ڣ�Ĭ�ϴӸ�λ��ʼ����
  *
  * @�������: Num: Ҫ������ֵ����ֵ��Χ: 0 ~ 4294967295
  * @����ֵ   : ��ֵ���ȣ�Ĭ����󷵻�10λ
  *****************************************************************************
**/
#define MAX_NUM_LEN          10    //��󷵻�λ��
alt_u8 Get_NumLen(alt_u32 Num)
{
	alt_u8 i=0;
	alt_u8 tmp=0;

	i = MAX_NUM_LEN - 1;    //�õ�����λ��
	while(1)
	{
		tmp = (Num/Equation_Calculate(10, i)) % 10;    //�õ�λ��
		if(tmp || i==0)
			break;    //���
		i--;
	}
	     if(i)    return i+1;    //������ֵλ��
	else if(tmp)  return 1;    //�������ֵֻ��һλ
	else          return 0;    //�������0
}


#define ASCII_HEIGHT 16		//��ʾ�ַ��߶�
#define ASCII_WIDTH   8		//��ʾ�ַ����
/**
  *****************************************************************************
  * @��������: printf����ַ�
  *			:
  *
  * @�������: lcd_ch: printf�ṹ��ָ��
  * 		  ch:     Ҫ������ַ�
  *
  * @����ֵ   : none
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
		lcd_ch->cursorx += (ASCII_WIDTH * 3);  //Ĭ��4���ַ����
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
  * @��������: printf����ַ�
  *			:
  *
  * @�������: lcd_st: printf�ṹ��ָ��
  * 		  *str:   Ҫ������ַ���
  *
  * @����ֵ   : none
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
  * @Name   : printf�������
  *
  * @Brief  : none
  *
  * @Input  : lcd_st: printf�ṹ��ָ��
  *           dec:    Ҫ���������
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
	else if(tmp < 0)  //����
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
  * @Name   : printf���������
  *
  * @Brief  : none
  *
  * @Input  : lcd_st: printf�ṹ��ָ��
  *           flt:    Ҫ����ĸ�����
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

	pre = (int)Equation_Calculate(10, lcd_dec->precision);  //�õ�С������
	flt_int = (int)(tmp);  //����
	flt_flo = (int)((tmp - flt_int) * pre);  //С��

	pre = (int)Equation_Calculate(10, (lcd_dec->min_width - lcd_dec->precision - 1));

	_printfint(lcd_dec, flt_int%pre);  //��ʾ����λ
	_printfch(lcd_dec, '.');
	lcd_dec->cursorx += ASCII_WIDTH;
	_printfint(lcd_dec, flt_flo);  //��ʾС��λ
}

/**
  *****************************************************************************
  * @Name   : printf���ʮ��������
  *
  * @Brief  : none
  *
  * @Input  : lcd_st: printf�ṹ��ָ��
  *           Hex:    Ҫ�����ʮ��������
  *           index:  Ҫת���Ľ�������16: ʮ�����ƣ�8: �˽���
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

	//�ַ�������
	for(j = 0;j <(i-1)/2;j++)
	{
		tmp = str[j];
		str[j] = str[i-1-j];
		str[i-1-j] = tmp;
	}

	if(index == 16)  //ʮ������
	{
		_printfch(lcd_hex, '0');lcd_hex->cursorx += ASCII_WIDTH;
		_printfch(lcd_hex, 'x');lcd_hex->cursorx += ASCII_WIDTH;
	}
	else if(index == 8)  //�˽���
	{
		_printfch(lcd_hex, '0');lcd_hex->cursorx += ASCII_WIDTH;
	}
	_printfstr(lcd_hex, (const char *)str);
}


/**
  *****************************************************************************
  * @�������� : printf��ʽ�������Һ��
  *
  * @������� : lcd_ch: printf�ṹ��ָ��
  *           format: ��ʽ���ַ���
  *           ...:    ������
  *
  *
  * @����ֵ   : none
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

    while(*format != '\0')  //ֱ������������
    {
        if(*format == 0x5c)  //����'\'
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
        else if(*format == '%')  //����ʽ���
        {
            format++;
            index = 0;
            lcd_pr->min_width = 0;
            while((*format <= '9') && (*format >= '0'))  //���
            {
                lcd_pr->min_width = (lcd_pr->min_width * index * 10) + (*format - '0');
                index++;
                format++;
            }
            if(*format == '.')  //��⵽��
            {
                format++;
                index = 0;
                lcd_pr->precision = 0;
                while((*format <= '9') && (*format >= '0'))  //����
                {
                    lcd_pr->precision = (lcd_pr->precision * index * 10) + (*format - '0');
                    index++;
                    format++;
                }
            }
            switch(*format)  //����ʽ��
            {
                case '%':  //���%����
                        _printfch(lcd_pr, '%');
                        lcd_pr->cursorx += ASCII_WIDTH;
                        format++;
                        break;

                case 'c':  //����ַ�
                        c = va_arg(ap, int);
                        _printfch(lcd_pr, c);
                        format++;
                        break;

                case 'S':
                case 's':  //����ַ���
                        str = va_arg(ap, const char *);
                        _printfstr(lcd_pr, (char*)str);
                        format++;
                        break;

                case 'd':  //���ʮ������
                        dec = va_arg(ap, int);
                        _printfint(lcd_pr, dec);
                        format++;
                        break;

                case 'f':  //���������
                        valflt = va_arg(ap, double);
                        _printfflt(lcd_pr, valflt);
                        format++;
                        break;

                case 'X':
                case 'x':  //���ʮ��������
                        dec = va_arg(ap, int);
                        _printfhex(lcd_pr, dec, 16);
                        format++;
                        break;

                case 'o':  //����˽�����
                        dec = va_arg(ap, int);
                        _printfhex(lcd_pr, dec, 8);
                        format++;
                        break;

                case 'm':
                        dec = va_arg(ap, int);
                        if(dec > 21)  dec = 21;  //�������������21������С����
                        lcd_pr->min_width = (alt_u16)dec;
                        format++;
                        if(*format == '.')
                        {
                            format++;
                            if(*format == 'n')
                            {
                                dec = va_arg(ap, int);
                                if(dec > 8)  dec = 8;  //������С��С�������ǣ�0.00000001
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
        else if(*format < 0x80)  //�ַ����
        {
            _printfch(lcd_pr, *format);
            lcd_pr->cursorx += ASCII_WIDTH;  //��һ���ַ�λ��--��ʱʹ��16
            format++;
        }
        //����û��SD���ֿ⣬��ʱ��֧��������ʾ
    }//end while
    va_end(ap);

    return (int)lcd_pr->charcnt;
}
