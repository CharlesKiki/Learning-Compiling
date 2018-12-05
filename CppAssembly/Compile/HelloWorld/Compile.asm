#include <iostream>
int main() 
{
00DA2550  push        ebp  
;扩展基址指针寄存器(extended base pointer) 其内存放一个指针，该指针指向系统栈最上面一个栈帧的底部
;13.63411MB
;为什么这个地址的位置在这里？在内存中的相对地址还是说下次会改变？
;静态反汇编的地址
;动态反汇编的地址
;偏移地址，经过链接后映射到运行地址
00DA2551  mov         ebp,esp  
;ESP（Extended stack pointer）是指针寄存器的一种（另一种为EBP）。用于堆栈指针。
00DA2553  sub         esp,0C0h  
00DA2559  push        ebx  
00DA255A  push        esi  
00DA255B  push        edi  
00DA255C  lea         edi,[ebp-0C0h]  
00DA2562  mov         ecx,30h  
00DA2567  mov         eax,0CCCCCCCCh  
00DA256C  rep stos    dword ptr es:[edi]  
00DA256E  mov         ecx,offset _DB241A14_main.cpp (0DAE027h)  
00DA2573  call        @__CheckForDebuggerJustMyCode@4 (0DA1271h)  
	using namespace std; 
	cout << "HelloWorld\n"; 
00DA2578  push        offset string "HelloWorld\n" (0DA9B30h)  
00DA257D  mov         eax,dword ptr [_imp_?cout@std@@3V?$basic_ostream@DU?$char_traits@D@std@@@1@A (0DAD0D4h)]  
00DA2582  push        eax  
00DA2583  call        std::operator<<<std::char_traits<char> > (0DA1208h)  
00DA2588  add         esp,8  
	return 0;
00DA258B  xor         eax,eax  
}
00DA258D  pop         edi  
00DA258E  pop         esi  
00DA258F  pop         ebx  
00DA2590  add         esp,0C0h  
00DA2596  cmp         ebp,esp  
00DA2598  call        __RTC_CheckEsp (0DA127Bh)  
00DA259D  mov         esp,ebp  
00DA259F  pop         ebp  
00DA25A0  ret  