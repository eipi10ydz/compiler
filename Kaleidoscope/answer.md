## 1
- 解释函数```gettok()```如何向调用者传递```token```类别、```token```语义值(数字值、变量名)
	- 定义枚举类型，则可以根据gettok的返回值得到token的类别
	```cpp
    enum Token {
  		tok_eof = -1,
  		// commands
  		tok_def = -2, tok_extern = -3,
  		// primary
  		tok_identifier = -4, tok_number = -5
	};
    ```
    - 全局变量IdentifierStr用来保存变量名，NumVal用来保存数字值
    ```cpp
    static std::string IdentifierStr;  // Filled in if tok_identifier
	static double NumVal;              // Filled in if tok_number
    ```

## 2
- 解释```ExprAST```里的```virtual```的作用,在继承时的原理(解释vtable).```virtual```在MP1的support code里面也出现了.这个问题是希望大家理解C++的继承.
	- 基类的虚函数是希望派生类声明自己的版本以覆盖基类的虚函数版本。析构函数一般会被设定为虚函数。原因主要是:
		- 根据对象的动态类型调用对应的虚函数。像下例中，```Base```类的析构函数没有被声明为虚函数，在```delete pb```调用析构函数时就会根据pb的静态类型```Base```调用```Base```的析构函数。这样```Inherit```的```data```的内存就没有被释放。如果把```Base```的析构函数改为虚函数，在```delete pb```调用析构函数时就会根据pb的动态类型```Inherit```调用```Inherit```的析构函数，把```data```的内存释放掉。
		```cpp
	    #include <iostream>
		class Base
		{
		public:
    		  ~Base() { std::cout << "Base" << std::endl; };
		};
		class Inherit : public Base
		{
		public:
			  int *data = new int(2333);
    		  ~Inherit() { delete data; }
		};
		int main()
		{
    	      Base *pb;
    		  Inherit *pin = new Inherit();
    		  pb = pin;
    		  int *test = pin -> data;
    		  std::cout << *test << std::endl;
    		  delete pb;
    		  std::cout << *test << std::endl;
		}
        输出:
        2333
		Base
		2333
    	```
	- 继承时的原理
		- 单继承
			- 虚函数表的布局: 每个虚函数都被指派一个固定的索引值，相同的虚函数对应的相对虚函数表指针的偏移量相同。因此不管对象的动态类型是什么，只要对应指定的偏移就能成功调用指定的虚函数
		- 多继承
			- 虚函数表的布局: 派生类的虚函数接在第一个父类的虚函数表后，然后是另外几个基类的虚函数表。
- 解释代码里的```<std::unique_ptr>```和为什么要使用它?
	- ```std::unique_ptr```独自拥有它指向的对象。因此其拷贝构造函数和拷贝赋值运算符都被定义为删除的(或private的)，导致AST组分的对象不能被拷贝。这正符合一个AST组分对象是独有的。
	- C++智能指针的优越性，会自动在离开作用域后调用析构函数
- 阅读```src/toy.cpp```中的```MainLoop```及其调用的函数.阅读```HandleDefinition```和```HandleTopLevelExpression```,忽略```Codegen```部分,说明两者对应的```AST```结构.
	- ```HandleDefinition```是专门用来处理函数结构的，通过调```ParseDefinition```再调```ParsePrototype```得到参数列表，最后```ParseExpression```得到函数内的表达式，生成```FunctionAST```对象
	- ```HandleTopLevelExpression```调```ParseTopLevelExpr```再调```ParseExpression```得到Expression，相当于是一个```Prototype```为空的```FunctionAST```对象
<pre>
 |
 └──HandleDefinition
    	 └── FunctionAST
         	├── ExprAST
         	└── PrototypeAST
             	├── ArgNames
             	└── FnName
|
└── HandleTopLevelExpression
          └─── FunctionAST
               ├── ExprAST
               └── AnonymousADT(空的ArgNames与FnName)
</pre>
- &nbsp;```Kaleidoscope```如何在```Lexer```和```Parser```间传递信息?(token、语义值、用什么函数和变量)
	- token: 用```CurTok```来表示当前的token，用```getNextToken```获取下一个token，```getNextToken```里面调用了```Lexer```的```gettok```
	- 语义值: 全局变量IdentifierStr用来保存变量名，NumVal用来保存数字值
    ```cpp
    static std::string IdentifierStr;  // Filled in if tok_identifier
	static double NumVal;              // Filled in if tok_number
	```
- &nbsp;```Kaleidoscope```如何处理算符优先级(重点解释```ParseBinOpRHS```)?解释```a*b*c、a*b+c、a+b*c```分别是如何被分析处理的?
	- 先调用```ParseExpression```，用```ParsePrimary```得到LHS(left hand side)，然后由```ParseBinOpRHS```处理后半部分
    <pre>
    expression ::= primary binoprhs
    binoprhs ::= binop primary
    			 | binoprhs binop primary
    binop ::= '&lt;' | '+' | '-' | '*'
    </pre>
    - **注: 下面用到的LHS里面的括号并不实际存在，只是表明AST结构**
    - ```a * b * c```
    	- ```ParsePrimary```走```tok_identifier```分支，得到```a```。然后调```ParseBinOpRHS(0, LHS)```，```LHS```此时为```a```
    	- 得到```*```，优先级大于0，接着```ParsePrimary```走```tok_identifier```分支，得到```b```。发现下个仍然是```*```，优先级一样，```LHS```变为```a * b```，可见为左结合。然后```ParsePrimary```走```tok_identifier```分支，得到```c```。然后下一个不是运算符，```LHS```变为```(a * b) * c```，```TokPrec```为0， 返回```LHS```
    - ```a * b + c```
    	- ```ParsePrimary```走```tok_identifier```分支，得到```a```。然后调```ParseBinOpRHS(0, LHS)```，```LHS```此时为```a```
    	- 得到```*```，优先级大于0，接着```ParsePrimary```走```tok_identifier```分支，得到```b```。发现下个是```+```，优先级低于```TokPrec```，因此```LHS```变为```a * b```，可见```*```优先级高于```+```。然后```ParsePrimary```走```tok_identifier```分支，得到```c```。然后下一个不是运算符，```LHS```变为```(a * b) + c```，```TokPrec```为0， 返回```LHS```
    - ```a + b * c```
    	- ```ParsePrimary```走```tok_identifier```分支，得到```a```。然后调```ParseBinOpRHS(0, LHS)```，```LHS```此时为```a```
    	- 得到```+```，优先级大于0，接着```ParsePrimary```走```tok_identifier```分支，得到```b```。发现下个是```*```，优先级高于```TokPrec```，因此```RHS```为递归调用```ParseBinOpRHS```的结果。进入递归后，```TokPrec```为```*```，```ParsePrimary```走```tok_identifier```分支，得到```c```。然后下一个不是运算符，```LHS```变为```b * c```，```TokPrec```为0， 返回```LHS```，退出递归。然后```LHS```变为```a + (b * c)```。然后下一个不是运算符，```TokPrec```为0， 返回```LHS```
- 解释```Error、ErrorP、ErrorF```的作用,举例说明它们在语法分析中的应用。
	- ```Error```: 用于输出表达式错误信息，如二元运算符出现了除```+```, ```-```, ```*```, ```<```外的，或者使用了函数参数列表中不存在的变量，或者调用的函数还未定义，或者调用函数时参数数量不对，或者在需要```primary```时得到的不是```(```、```tok_identifier```、```tok_number```，或者有左括号但没有右括号，参数列表中```tok_identifier```或```tok_number```后既不是')'也不是','
	- ```ErrorP```: 用于输出prototype(函数名+参数列表)错误信息，例如缺少函数名，缺少左、右括号
	- ```ErrorF```: 用于输出函数错误信息，例如函数重定义，或重定义同名但参数列表不同的函数
- ```Kaleidoscope```不支持声明变量和给变量赋值,那么变量的作用是什么?
	- 变量可以作为函数的形式参数

## 3

- 解释教程3.2节中```Module```、```IRBuilder<>```的作用
	- ```Module```包含函数和全局变量，是```LLVM```的结构组分。这也是```LLVM IR```用来存放代码的顶层结构，它负责```IR```的内存，因此```codegen```返回的是```Value*```，而不是```unique_ptr```
	- ```IRBuilder<>```是模板类，它提供了统一的接口用于创建指令并把它们插入一个基本语句块，或者是在基本语句块的末尾，或者是在迭代器指向的特定位置
- 为何使用常量时用的函数名都是```get```而不是```create```?
	- 因为在```LLVM IR```中，常量都是共享的，且每个常量仅有一个
- 简要说明声明和定义一个函数的过程
	- 
- 文中提到了visitor pattern,虽然这里没有用到,但是是一个很重要的设计模式,请调研后给出解释(字数不作限制)
	- 

# 参考资料
1. Lippman S B, 侯捷. 深度探索 C++ 对象模型[J]. M]. 北京: 华中科技大学出版社, 2001.
2. Gamma E, Helm R, Johnson R, et al. 设计模式: 可复用面向对象软件的基础[J]. 2000.