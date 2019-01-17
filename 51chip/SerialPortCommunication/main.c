/**************************************************************************************
*		              串口通信实验												  *
实现现象：After Donload the  code,open serial communication softwar，set the baud rate as 4800，and then you will see message return from chip.
注意事项：
1.You need serial communication software to seend message.
2.When you set value of Timer Low,you need to know what is the crystal oscillator frequency(mhz), and baud rate, timer woring method ,SMOD .
***************************************************************************************/

#include "reg52.h"			 //此文件中定义了单片机的一些特殊功能寄存器

typedef unsigned int u16;	  //对数据类型进行声明定义
typedef unsigned char u8;


/*******************************************************************************
* 函数名         :UsartInit()
* 函数功能		 :设置串口
* 输入           : 无
* 输出         	 : 无，可以用来控制其他部分硬件
*******************************************************************************/
void UsartInit()
{
	//变量命名：
	//TCON 定时器控制寄存器
		//Set TR1 as 1 to open
	//TMOD 定时器模式寄存器
	//TL0 Timer Low 0
	//TL1 Timer Low 1
	//TH0 Timer High 0 
	//TH1 Timer High 1
	SCON=0X50;		//设置为工作方式1，高四位为0101
	TMOD=0X20;		//设置计数器工作方式2，高四位的值为0010
	PCON=0X80;		//波特率加倍设置,binary as 10000000
	TH1=0XF3;		//计数器初始值设置
	TL1=0XF3;
	ES=1;			//打开接收中断
	/*If ES is not 1 as open , the result is even the TI is 1, the function woun't start.*/
	EA=1;			//打开总中断
	/*EA is the switch of all interrupt, if EA is 0, even ES set as 1, the function woun't start.*/
	TR1=1;			//打开计数器
}

/*******************************************************************************
* 函 数 名       : main
* 函数功能		 : 主函数
* 输    入       : 无
* 输    出    	 : 无
*******************************************************************************/
void main()
{	
	UsartInit();  //	串口初始化
	while(1){
		
	};		
}

/*******************************************************************************
* 函数名         : Usart() interrupt 4
* 函数功能		 : 串口通信中断函数
* 输入           : 无
* 输出         	 : 无
* Commit		 : Even main() didn't call this function,it can work,because it's interrupt function and called by timer interrupt.
*******************************************************************************/
void Usart() interrupt 4
/*
中断0 外部中断0
中断1 定时器1中断
中断2 外部中断1
中断3 定时器2中断
中断4 串口中断
*/
{
	//从PC发送到单片机
	//SBUF接收，发送缓冲器
	u8 receiveData;
	receiveData=SBUF;	//接收到的数据
	//之前会硬件置1，之后需要进行软件复位，等待下次接收
	RI = 0;				//清除接收中断标志位
	/*RI : After receiving finished ,set 1*/
	
	/*Here you can write a function used to check specific word to enable some hardware like sounds.*/
	
	SBUF=receiveData;	//将接收到的数据放入到发送寄存器
	while(!TI);			//等待发送数据完成
	/*TI : After sending finished ,set 1*/
	
	//存在硬件置1，此时已经发送完成
	TI=0;				//清除发送完成标志位
}