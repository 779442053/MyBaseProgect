//
//  block使用.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//
 /*
https://blog.csdn.net/u014536527/article/details/50378586
  
  使用Block的三个步骤：1.定义Block变量；2.定义Block（即创建block代码块）3.调用block匿名函数
  无参数无返回值
  void (^hellowBlock)() = ^{  nslog(@"你好")
  }
  hellowBlock()//调用block
  hellowBlock block变量的定义 ^{}:返回类型可以省略,没有参数时候省略.有参数时不可以省略
 有参数有返回值
  void (^getsum)(int ,int) = ^(int num1, int num2){
    return num1 + num2
  }
  getsum(1,2)//调用block   ===3
  
  2>定义Block变量的时候一般大家都是用typedef重定义，应用起来既方便看起来又很直观
  typedef void(^hellowBlock)();    typedef int(^hellowBlock)(int,int);
  
  //1.分析，ARC如果在块对象中使用了__block指定的变量，那么这个变量将会被copy到堆内存中，并且原变量也会指向这个堆内存中的空间
  //2.如果有两个块对象引用了同一个__block指定的变量，那么他们共享这个变量，共享同一个内存
  
  //1.函数内被__block修饰的变量可以被块对象读写，多个块对象之间可以共享__block变量的值
  //2.__block变量不是静态变量，在块句法每次用到这种变量的时候会去相应的内存空间获取值，就是说不同块对象分享的__block变量的值是执行时动态生成
  //3.访问__block变量的块对象被复制后，新生成的块对象也能共享__block变量的值
  //4.多个块对象访问同一个__block变量的时候，只要有一个块对象存在，__block变量就会存在；如果访问__block变量的对象都不存在了，__block对象随之消失
  
  //总结：
  //注意：因为__block变量的内存位置可能会发生变化，所以，写程序时候不要写用指针访问__block变量的代码,那样可能会得不到预期的结果(这是在项目中尤为重要的一点)
  
  
  二、iOS开发中，项目中使用Block
  1.Block作为属性
  //block作为属性传给下一个界面
  runVC.testBlock = testBlock;   在runVC中  @property(nonatomic,strong)testBlock testBlock;
  2.Block作为方法参数
  https://blog.csdn.net/u014536527/article/details/50378586
  
  
  参考
  int b = 0;
  void (^blo)() = ^{
  NSLog(@"Input:b=%d",b);
  };
  b = 3;
  blo();
  /**
  *    Input:b=0
  
  虽然我们在调用blo之前改变了b的值，但是输出的还是Block编译时候b的值，所以截获瞬间自动变量就是：在Block中会保存变量的值，而不会随变量的值的改变而改变。
  
  void(^myBlock)(NSString *str1,NSString *str2);
  
  void:返回值
  myBlock：名字
  str1，str2 ： 参数（可以是很多个）
  
  //最好用copy修饰
  @property (copy, nonatomic) void (^tfBlock)(UITextField *textField);
  
  typedef 的时候
  typedef void(^success) (NSString *states);
  
  @interface LQSecondBlockViewController ()
  
  @property (nonatomic,copy) success networkingSuccess;
  
  @end
  
  局部变量时
  int(^myBlock)(int i )= ^(int i){
  return i + 1;
  };
  int j = myBlock(1);
  作为方法的参数时
  - (void)lwqNetWorkingsuccess:(void(^)(NSString * states)) success{
  
  }
  作为方法的参数时 不需要在“^‘的后面加block的名字。
  其余的情况都需要加。
  
  
  
  
  
  */
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
*/

