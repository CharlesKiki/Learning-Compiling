/**************************************************************************************
*		              ����ͨ��ʵ��												  *
ʵ������After Donload the  code,open serial communication softwar��set the baud rate as 4800��and then you will see message return from chip.
ע�����
1.You need serial communication software to seend message.
2.When you set value of Timer Low,you need to know what is the crystal oscillator frequency(mhz), and baud rate, timer woring method ,SMOD .
***************************************************************************************/

#include "reg52.h"			 //���ļ��ж����˵�Ƭ����һЩ���⹦�ܼĴ���

typedef unsigned int u16;	  //���������ͽ�����������
typedef unsigned char u8;


/*******************************************************************************
* ������         :UsartInit()
* ��������		 :���ô���
* ����           : ��
* ���         	 : �ޣ���������������������Ӳ��
*******************************************************************************/
void UsartInit()
{
	//����������
	//TCON ��ʱ�����ƼĴ���
		//Set TR1 as 1 to open
	//TMOD ��ʱ��ģʽ�Ĵ���
	//TL0 Timer Low 0
	//TL1 Timer Low 1
	//TH0 Timer High 0 
	//TH1 Timer High 1
	SCON=0X50;		//����Ϊ������ʽ1������λΪ0101
	TMOD=0X20;		//���ü�����������ʽ2������λ��ֵΪ0010
	PCON=0X80;		//�����ʼӱ�����,binary as 10000000
	TH1=0XF3;		//��������ʼֵ����
	TL1=0XF3;
	ES=1;			//�򿪽����ж�
	/*If ES is not 1 as open , the result is even the TI is 1, the function woun't start.*/
	EA=1;			//�����ж�
	/*EA is the switch of all interrupt, if EA is 0, even ES set as 1, the function woun't start.*/
	TR1=1;			//�򿪼�����
}

/*******************************************************************************
* �� �� ��       : main
* ��������		 : ������
* ��    ��       : ��
* ��    ��    	 : ��
*******************************************************************************/
void main()
{	
	UsartInit();  //	���ڳ�ʼ��
	while(1){
		
	};		
}

/*******************************************************************************
* ������         : Usart() interrupt 4
* ��������		 : ����ͨ���жϺ���
* ����           : ��
* ���         	 : ��
* Commit		 : Even main() didn't call this function,it can work,because it's interrupt function and called by timer interrupt.
*******************************************************************************/
void Usart() interrupt 4
/*
�ж�0 �ⲿ�ж�0
�ж�1 ��ʱ��1�ж�
�ж�2 �ⲿ�ж�1
�ж�3 ��ʱ��2�ж�
�ж�4 �����ж�
*/
{
	//��PC���͵���Ƭ��
	//SBUF���գ����ͻ�����
	u8 receiveData;
	receiveData=SBUF;	//���յ�������
	//֮ǰ��Ӳ����1��֮����Ҫ���������λ���ȴ��´ν���
	RI = 0;				//��������жϱ�־λ
	/*RI : After receiving finished ,set 1*/
	
	/*Here you can write a function used to check specific word to enable some hardware like sounds.*/
	
	SBUF=receiveData;	//�����յ������ݷ��뵽���ͼĴ���
	while(!TI);			//�ȴ������������
	/*TI : After sending finished ,set 1*/
	
	//����Ӳ����1����ʱ�Ѿ��������
	TI=0;				//���������ɱ�־λ
}