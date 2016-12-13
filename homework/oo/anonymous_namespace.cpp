struct _GLOBAL__N_1
{
    _GLOBAL__N_1& operator()(int)
    {
        return *this;
    }
};

int main()
{
    _GLOBAL__N_1 t;
    t(23333);
/*
 * objdump -DSC xxx.o | less 可以看到下面结果，objdump认为该类的方法属于匿名命名空间
 *
    Disassembly of section .text._ZN12_GLOBAL__N_1clEi:

0000000000000000 <(anonymous namespace)::operator()(int)>:
   0:   55                      push   %rbp
   1:   48 89 e5                mov    %rsp,%rbp
   4:   48 89 7d f8             mov    %rdi,-0x8(%rbp)
   8:   89 75 f4                mov    %esi,-0xc(%rbp)
   b:   48 8b 45 f8             mov    -0x8(%rbp),%rax
   f:   5d                      pop    %rbp
  10:   c3                      retq   
*/    
}
