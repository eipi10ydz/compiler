- 手工编写的时候考虑写了一个求阶乘的程序，然后可以生成`LLVM IR`，可以模仿着写
```cpp
int factorial(int n)
{
    return n == 0 ? 1 :
    n == 1 ? : 
    n * factorial(n - 1);
}
```
- 遇到的问题
   1. 以为变量可以重复用，比如下面的`LLVM IR`中就出现了两个`%n_val`，这样会报错`error: multiple definition of local value named 'n_val'`
    ```
    test:
        %n.addr = alloca i32, align 4
        store i32 %n, i32* %n.addr, align 4
        %n_val = load i32, i32* %n.addr, align 4
    test1:
        %n_val = load i32, i32* %n.addr, align 4
    ```
    - 处理对策就是改变量名，甚至后来改为`-O3`后发现没有必要这样写，直接用传入的形参就好
    2. 在开始没加`-O3`时，发现生成的可执行文件执行时间我写的`fib-m.ll`要比`clang`编译`fib.c`的短，想了下原因应该是他生成的比较模式化，`fib`函数中多了一些没有必要的跳转，而我写的是针对这个例子的，可以简化那些多余的东西
    - 然后发现加了`-O3`优化后竟然它比我快，fib函数和我也差不多了，少了那些多余的跳转，然后决定吸取一些经验教训，发现把调用改成`tail call`，加上了`tail call optimation`，还有就是把一些没有必要的`load`和`store`去掉
    - 发现他加了`-O3`会把`atoi`转为`strtol`，但是试了下并没有什么改变。
    - 最后的情况是如果我也加`-O3`后就和它一样快，如果不加还是比它慢一些(实际上它如果不加`-O3`会慢很多)，我觉得应该是在其它部分也有优化，比如硬件优化等