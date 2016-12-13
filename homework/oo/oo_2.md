## 系统、编译器等信息
- 操作系统: Linux kali 4.8.0-kali1-amd64 #1 SMP Debian 4.8.5-1kali1 (2016-11-04) x86_64 GNU/Linux
- 编译器: clang version 3.7.1 (tags/RELEASE_371/final)
- objdump: GNU objdump (GNU Binutils for Debian) 2.27.51.20161127

## 类/非匿名命名空间(见t.cpp)
- 假设类名/非匿名命名空间名为Test，res = ""
- 类名/非匿名命名空间名中有4(n)个字母，就会变为res += _ZN + (K)(this是const) + 4(n) + Test(类名)，即Base = _ZN4Test | _ZNK4Test
- 成员函数分为普通的成员函数、构造函数与析构函数、operator函数
    - C2对应构造函数，D2对应析构函数，所以是_ZN + (K)(this是const) + 4TestC2 | _ZN + (K)(this是const) + 4TestD2
    - 成员函数，假定成员函数名为test，res += 4(m) + test(成员函数名)，所以是_ZN4Test4test
    - operator(即重载运算符)，会一一对应，加在类名后面
        - '+' : pl
        - '-' : mi
        - '*' : ml
        - '/' : dv
        - '%' : rm
        - '==' : eq
        - '!=' : ne
        - '<' : lt
        - '<=' : le
        - '>' : gt
        - '>=' : ge
        - '++'(前置/后置) : pp
        - '--'(前置/后置) : mm
        - '()' : cl
        - '[]' : ix
        - '*'(解引用) : de
        - '->' : pt
        - '<<' : ls
        - '>>' : rs
        - '&' : an
        - '|' : or
        - '^' : eo
        - '!' : nt
        - '~' : co
        - '+=' : pL
        - '-=' : mI
        - '*=' : mL
        - '/=' : dV
        - '%=' : rM
        - '^=' : eO
        - '&=' : aN
        - '|=' : oR
        - '>>=' : rS
        - '<<=' : lS
        - '=' : aS        
- 接下来就是返回值，在上一步基础加上'E'再加上形参
    - 'R' : 左值引用&
    - 'O' : 右值引用&&
    - 'K' : 底层const
    - 'S_' : 类本身
    - 'P' : 指针
    - 'v' : void
    - 'i' : int
    - 'f' : float
    - 'd' : double
    - 'b' : bool
    - 'c' : char
    - 's' : short
    - 'l' : long
    - 'x' : long long
- 所以也可以明白上面的前置/后置的++/--是通过形参int即可区分
- 举个例子
```cpp
class Test
{
    void operator()(const Test&, int, bool, char*, Test&&, const short**) { }
    // _ZN4TestclERKS_ibPcOS_PPKs
    Test() { }
    // _ZN4TestC2Ev
    void test() { }
    // _ZN4Test4testEv
}
```
- 看起来返回值没加进函数名，因此返回值不同形参一致并不能算重载，会报错
- 看起来顶层const也没加进函数名，因此下面两个函数不被视为重载
```cpp
void hello(const char);
void hello(char);
```
- 此外static、noexcept等貌似也没有加入函数名
- 目前发现一种可能导致冲突的情况是非匿名命名空间与类名一样，这样会导致冲突。原因的话也可以理解，在使用类静态成员的时候，和命名空间使用方式类似，都是名+作用与运算符+成员，这样可能会导致冲突。

## 匿名命名空间(见t.cpp与anonymous_namespace.cpp)
- _ZN12_GLOBAL__N_1 + 函数名长度 + 函数名 + 'E' + 形参
- 可以看为一个名为`_GLOBAL__N_1`的类
   - 结果发现调用`_GLOBAL__N_1`类里面的成员函数会被`objdump`误认为匿名命名空间的函数。见`anonymous_namespace.cpp`
   - 虽然骗过了`objdump`，但是不利用`_GLOBAL__N_1`类的对象调用成员函数还是没能骗过编译器

## 一般的函数(见t.cpp)
- _Z + 函数名长度 + 函数名 + 形参
```cpp
void hi(int)
//_Z2hii
```

## 变量
- 变量貌似看不到

## printf && cout(见s.c)
- 动态链接
```
    printf("12345\n");
  40087d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400881:	b0 00                	mov    $0x0,%al
  400883:	e8 e8 fd ff ff       	callq  400670 <printf@plt>
  400888:	31 c9                	xor    %ecx,%ecx
```
- 静态链接
```
    printf("12345\n");
  400f2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400f31:	b0 00                	mov    $0x0,%al
  400f33:	e8 58 76 0a 00       	callq  4a8590 <_IO_printf>
  400f38:	31 c9                	xor    %ecx,%ecx
```
- 区别
   - 静态链接和动态链接的区别主要就在于`@plt`。
   - PLT(Procedure Linkage Table)可以用来存放调用在链接时地址未知的过程/函数，地址由动态链接器在运行时处理。
       - 初次调用前，对应表项(0x2009a2)存放着下一条指令地址即(0x400676)。可以看到是GOT(global offset table) + 0x8。
    ```
    0000000000400660 <.plt>:
    400660:	ff 35 a2 09 20 00    	pushq  0x2009a2(%rip)        # 601008 <_GLOBAL_OFFSET_TABLE_+0x8>
    400666:	ff 25 a4 09 20 00    	jmpq   *0x2009a4(%rip)        # 601010 <_GLOBAL_OFFSET_TABLE_+0x10>
    40066c:	0f 1f 40 00          	nopl   0x0(%rax)

    0000000000400670 <printf@plt>:
    400670:	ff 25 a2 09 20 00    	jmpq   *0x2009a2(%rip)        # 601018 <printf@GLIBC_2.2.5>
    400676:	68 00 00 00 00       	pushq  $0x0
    40067b:	e9 e0 ff ff ff       	jmpq   400660 <.plt>
    ```
   - 初次调用时，动态链接器找到这些函数地址，存放在GOT(Global Offsets Table)中。这样以后每次调用，`jmp *0x2009a2`都会跳转到`printf`真实的地址。
   - 静态链接时候直接把静态库链接到可执行文件，调用时就相当于模块内调用，直接`call`偏移地址即可，不需要经由PLT、GOT中转。

## 参考资料
1. https://www.technovelty.org/linux/plt-and-got-the-key-to-code-sharing-and-dynamic-libraries.html
2. 甲子, 爱民. 程序员的自我修养: 链接, 装载与库[M]. 电子工业出版社, 2009.