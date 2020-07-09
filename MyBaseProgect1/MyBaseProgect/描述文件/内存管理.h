//
//  内存管理.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//
 /*
  
  1）计时器NSTimer
  一方面，NSTimer经常会被作为某个类的成员变量，而NSTimer初始化时要指定self为target，容易造成循环引用。 另一方面，若timer一直处于validate的状态，则其引用计数将始终大于0。先看一段NSTimer使用的例子(ARC模式)：
  2）block
  block在copy时都会对block内部用到的对象进行强引用(ARC)或者retainCount增1(非ARC)。在ARC与非ARC环境下对block使用不当都会引起循环引用问题，一般表现为，某个类将block作为自己的属性变量，然后该类在block的方法体里面又使用了该类本身，简单说就是self.someBlock = ^(Type var){[self dosomething];或者self.otherVar = XXX;或者_otherVar = ...};block的这种循环引用会被编译器捕捉到并及时提醒
  - (id)init
  {
  if (self = [super init]) {
  self.arr = @[@111, @222, @333];
  self.block = ^(NSString *name){
  NSLog(@"arr:%@", self.arr);
  };
  }
  return  self;
  }
  我们看到，在block的实现内部又使用了Friend类的arr属性，xcode给出了warning， 运行程序之后也证明了Friend对象无法被析构
  由此我们知道了，即使在你的block代码中没有显式地出现"self"，也会出现循环引用！只要你在block里用到了self所拥有的东西！但对于这种情况，我们无法通过加__weak声明或者__block声明去禁止block对self进行强引用或者强制增加引用计数。但我们可以通过其他指针来避免循环引用(多谢xq_120的提醒)
  ================具体做法=================
  __weak typeof(self) weakSelf = self;
  self.blkA = ^{
  __strong typeof(weakSelf) strongSelf = weakSelf;//加一下强引用，避免weakSelf被释放掉
  NSLog(@"%@", strongSelf->_xxView); //不会导致循环引用.
  };
  
  原因:ARC环境下：ARC环境下可以通过使用_weak声明一个代替self的新变量代替原先的self，我们可以命名为weakSelf。通过这种方式告诉block，不要在block内部对self进行强制strong引用
  
  3）委托delegate
  在委托问题上出现循环引用问题已经是老生常谈了，本文也不再细讲，规避该问题的杀手锏也是简单到哭，一字诀：声明delegate时请用assign(MRC)或者weak(ARC)，千万别手贱玩一下retain或者strong
  
  
  ================__weak & __block  assign & weak=================
  
  
  __weak 本身是可以避免循环引用的问题的，但是其会导致外部对象释放了之后，block 内部也访问不到这个对象的问题，我们可以通过在 block 内部声明一个 __strong 的变量来指向 weakObj，使外部对象既能在 block 内部保持住，又能避免循环引用的问题。
  __block 本身无法避免循环引用的问题，但是我们可以通过在 block 内部手动把 blockObj 赋值为 nil 的方式来避免循环引用的问题。另外一点就是 __block 修饰的变量在 block 内外都是唯一的，要注意这个特性可能带来的隐患。
  但是__block有一点：这只是限制在ARC环境下。在非arc下，__block是可以避免引用循环的
  
  
  assign与weak，它们都是弱引用声明类型，最大的区别在那呢？
  如果用weak声明的变量在栈中就会自动清空，赋值为nil。
  如果用assign声明的变量在栈中可能不会自动赋值为nil，就会造成野指针错误
  
  1.修饰变量类型的区别
  weak 只可以修饰对象。如果修饰基本数据类型，编译器会报错-“Property with ‘weak’ attribute must be of object type”。
  assign 可修饰对象，和基本数据类型。当需要修饰对象类型时，MRC时代使用unsafe_unretained。当然，unsafe_unretained也可能产生野指针，所以它名字是"unsafe_”。
  
  2.是否产生野指针的区别
  weak 不会产生野指针问题。因为weak修饰的对象释放后（引用计数器值为0），指针会自动被置nil，之后再向该对象发消息也不会崩溃。 weak是安全的。
  assign 如果修饰对象，会产生野指针问题；如果修饰基本数据类型则是安全的。修饰的对象释放后，指针不会自动被置空，此时向对象发消息会崩溃。
  
  
  assign 适用于基本数据类型如int,float,struct等值类型，不适用于引用类型。因为值类型会被放入栈中，遵循先进后出原则，由系统负责管理栈内存。而引用类型会被放入堆中，需要我们自己手动管理内存或通过ARC管理。
  weak 适用于delegate和block等引用类型，不会导致野指针问题，也不会循环引用，非常安全。
  

  作者：sxtra
  链接：https://www.jianshu.com/p/a8a43ae15dcd
  來源：简书
  著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
  
  
  
  
  
  
  
  
  
  
  */
