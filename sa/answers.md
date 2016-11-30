### 3.1
```bash
# 绘制ast图
clang -cc1 -ast-view test.c
dot -Tsvg /tmp/AST*.dot -o AST.svg
# 绘制cfg图
clang -cc1 -analyze -analyzer-checker=debug.ViewCFG test.c
dot -Tsvg /tmp/CFG*.dot -o CFG.svg
# 绘制exploded graph图
clang -cc1 -analyze -analyzer-checker=debug.ViewExplodedGraph test.c
dot -Tsvg /tmp/Expr*.dot -o ExplodedGraph.svg
```

### 3.2
1. Checker 对于程序的分析主要在 AST 上还是在 CFG 上进行?
   - `CFG`，因为`Checker`对于程序的分析是路径敏感的，而`AST`上并不能很好的体现控制流/路径
2. Checker 在分析程序时需要记录程序状态,这些状态一般保存在哪里?
   - `GenericDataMap`，是`ExplodedNode`的`ProgramState`的一部分，`Checker`用来构建`ProgramState`，保存了对`symbolic value`的限制
   - `Environment`，保存了源代码中表达式到`symbolic value`的映射关系
   - `Store`，保存了内存位置到`symbolic value`的映射关系

3. 简要解释分析器在分析下面程序片段时的过程,在过程中产生了哪些symbolic values? 它们的关系是什么?
   - 左值x，y，p，z的MemRegion的SVal
   - 3和4的SVal，然后3、4的SVal分别与左值x、y的MemRegion绑定
   - 右值x，p的MenRegion的SVal，1的SVal
   - &x，*(p + 1)产生符号表达式，属于符号值的SVal，分别绑定到左值p、z的MemRegion

### 3.3
1. LLVM 大量使用了 C++11/14 的智能指针，请简要描述几种智能指针的特点、使用场合，如有疑问也可以记录在报告中
   + 主要有三种智能指针
      - `weak_ptr`: 不控制所指向对象生存期，可以指向`shared_ptr`管理的对象，但不增加引用计数
      - `shared_ptr`: 可以使不同`shared_ptr`指向同一对象，使用引用计数，记录指向对象的`shared_ptr`个数。当指向一个对象最后一个`shared_ptr`被销毁时，`shared_ptr`会自动销毁该对象
      - `unique_ptr`: 对象为该指针独享，拷贝构造和拷贝赋值运算符被定义为delete，只能移动。能使用`unique_ptr`，尽量不要用`shared_ptr`，因为`shared_ptr`开销太大
2. LLVM 不使用 C++ 的运行时类型推断(RTTI),理由是什么？ LLVM 提供了怎样的机制来代替它？
   + 根据manual的说法，为了减小代码和可执行文件的大小，`LLVM`不使用`RTTI`和异常处理。
   + 使用模板`isa<>`，`cast<>`，`dyn_cast<>`，`cast_or_null<>`，`dyn_cast_or_null<>`，对象的类不需要有虚表就可以使用
      - `isa`: 根据引用和指针是否指向特定类的实例返回true或false
      - `cast`: 把对基类的指针或引用改为对派生类的指针或引用，如果类型不对会导致断言错误
      - `dyn_cast`: 检查操作数是否是特定类型，如果是则返回指向该类型的指针，否则返回nullptr
      - `cast_or_null`: `cast`的基础上可以传递nullptr作为参数
      - `dyn_cast_or_null`: `dyn_cast`的基础上可以传递nullptr作为参数
3. 如果你想写一个函数,它的参数既可以是数组,也可以是std::vector,那么你可以声明该参数为什么类型?如果你希望同时接受 C 风格字符串和 std::string 呢?
   + 数组/std::vector: `ArrayRef`
   + 字符串: `StringRef`
4. 你有时会在cpp文件中看到匿名命名空间的使用,这是出于什么考虑？
   + 匿名命名空间可以起到原来`static`可以起到的一个功能，即保证了命名空间内定义的变量和类只能在当前文件中使用

### 3.4
1. 这个 checker 对于什么对象保存了哪些状态?保存在哪里?
   + `checker`的状态保存在`ProgramState`中的一个从被追踪的流符号到它们的状态间的映射`StreamMap`
   
2. 状态在哪些时候会发生变化？
   + `checkPostCall`中如果检测到`Call`对应的文件被打开(调用fopen)，则会将`FileDesc`的状态设为`Opened`
   + `checkPreCall`中若检测到`Call`对应的文件描述符被关闭(调用fclose)，则会将`FileDesc`的状态设为`Closed`
   + `checkDeadSymbol`中若检测到文件描述符变为`dead symbol`，则会清除对应的`dead symbol`
   + `checkPointerEscape`中若检测到文件描述符变得无法追踪，则会清除对应的无法追踪的符号

3. 在哪些地方有对状态的检查？
   + `checkDeadSymbols`中得到追踪的流符号，逐个检查是否变为`dead symbol`
   + `isLeaked`中检查是否文件被打开后变为`dead symbol`
   + `CheckPreCall`中会检测`Call`对应的文件描述符是否被重复关闭

4. 函数`SimpleStreamChecker::checkPointerEscape`的逻辑是怎样的?实现了什么功能？用在什么地方？
   + 逻辑
      + 先判断指针是不是直接被传递给了函数调用且保证不会被释放掉，如果满足，则什么都不做，直接返回状态
      + 否则认为分析器不再能追踪它们，并假定相关的文件会在其他地方被关闭，清除状态中的无法追踪的符号，返回状态
   + 功能
      + 清除无法追踪(escaped)的符号，因为再也无法知道它的状态
   + 用在什么地方
      + 用于处理出现无法追踪的符号的情况
      
5. 根据以上认识,你认为这个简单的checker能够识别出怎样的bug？又有哪些局限性？请给出测试程序及相关的说明。
   + 可以识别的情况
      - 文件未被关闭的bug
      ```c
      #include <stdio.h>
      int main()
      {
            FILE *fp;
            fp =fopen("csa.md", "r");
      }
      ```
      - 文件被多次关闭的bug
      ```c
      #include <stdio.h>
      int main()
      {
            FILE *fp;
            fp =fopen("csa.md", "r");
            fclose(fp);
            fclose(fp);
      }
      ```
   + 局限性: 如下面的程序，就无法检查出fp未被关闭
      ```c
            #include <stdio.h>
            int main()
            {
                  FILE *fp;
                  fp =fopen("csa.md", "r");
                  for(int i = 0; i < 4; ++i)
                      if (i > 10)
                          fclose(fp);
            }
      ```

### 3.5
1. 增加一个checker需要增加哪些文件?需要对哪些文件进行修改？
   + 一个新的`Checker`的实现文件
   + 在实现文件中加入注册代码
   + 在`lib/StaticAnalyzer/Checkers/Checkers.td`中按分类加入该`Checker`的描述，如说明、实现文件的文件名等
   + 为了让源代码文件让CMake可见，需要把它加到`lib/StaticAnalyzer/Checkers/CMakeLists.txt`里(其实可以直接把它加到`lib/StaticAnalyzer`下的`Checkers`，`Core`，`Frontend`文件夹中)
2. 阅读`clang/include/clang/StaticAnalyzer/Checkers/CMakeLists.txt`，解释其中的`clang_tablegen`函数的作用。
   + 利用`Checkers.td`文件，生成`checker`表。
   + `clang_tablegen`会调用`tablegen`，在一般描述的基础上为每个项添加特定描述
   + 通过`tablegen`可以减少重复代码，同时减少一般化流程中出错的概率，并简化特定信息的记录。
   + `clang_tablegen`可以帮助`checker`补充类的定义，并完成`checker`的注册，减少重复性的工作。
   
3. `.td`的文件在clang中出现多次,比如这里`clang/include/clang/StaticAnalyzer/Checkers/Checkers.td`。这类文件的作用是什么？它是怎样生成C++头文件或源文件的?这个机制有什么好处？
   + 作用: 描述目标架构的信息，使用TableGen来生成目标架构的描述
   + 怎样生成C++头文件: TableGen的核心部分对文件进行分析，把声明实例化，并把结果交给特定领域的后端，由后端负责生成Cpp代码
   + 好处: 共享不同目标架构间可以共用的大量代码，抽象出架构上的特性，尽可能地减少重复代码，在减少工作量的同时减低出错几率。