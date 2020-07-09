//
//  KVO&KVC.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//
 /*
  KVC 就是键值编码
  1）通过键值路径为对象的属性赋值。主要是可以为私有的属性赋值。
  AppleViewController *appleVC = [[AppleViewController alloc]init];
  [appleVC setValue:@"橘子" forKey:@"name"];
  如果对象A的属性是一个对象B，要设置对象B的属性
  [person setValue:@"旺财" forKeyPath:@"dog.name"];dog就是person对象的的一个属性
  
  2）通过键值路径获取属性的值。主要是可以通过key获得私有属性的值。
   NSString *nameStr = [appleVC valueForKey:@"name"];
  也可以通过keypath获得值
  NSString *dName = [person valueForKeyPath:@"dog.name"];
  3）将字典转型成Model，方法：setValuesForKeysWithDictionary:
  // 定义一个字典
  NSDictionary *dict = @{
  @"name"  : @"jack",
  @"money" : @"20.7",
  };
  // 创建模型
  Person *p = [[Person alloc] init];
  
  // 字典转模型
  [p setValuesForKeysWithDictionary:dict];
  NSLog(@"person's name is the %@",p.name);
  注意：字典的key和Model的属性一定要一一对应。否则会出现错误。比如person里没有name的属性，系统报错如下：
  '[<Person 0x60000001d0b0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key name.'
  
  
  KVO 是键值观察者（key-value-observing）。KVO提供了一种观察者的机制，通过对某个对象的某个属性添加观察者，当该属性改变，就会调用"observeValueForKeyPath:"方法，为我们提供一个“对象值改变了！”的时机进行一些操作
  KVO原理 当某个类的对象第一次被观察时，系统在运行时会创建该类的派生类，改派生类中重写了该对象的setter方法，并且在setter方法中实现了通知的机制。派生类重写了class方法，以“欺骗”外部调用者他就是原先那个类。系统将这个类的isa指针指向新的派生类，因此改对象也就是新的派生类的对象了。因而改对象调用setter就会调用重写的setter，从而激活键值通知机制。此外派生类还重写了delloc方法来释放资源
  KVO的使用
  1）给对象的属性添加观察者
  
  [appleVC addObserver:self forKeyPath:@"name" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
  注： options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 返回未改变之前的值和改变之后的值    context可以为空
  ======如果值发生了改变,那么会调用下面的方法
  -(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
  {
  //拿到新值/旧值,进行操作
  NSLog(@"newValue----%@",change[@"new"]);
  NSLog(@"oldValue----%@",change[@"old"]);
  
  }
  //不要忘记移除
  -(void)dealloc
  {
  [person removeObserver:self forKeyPath:@"test"];
  }
  4.KVO的使用场景
  KVO用于监听对象属性的改变。
  　　（1）下拉刷新、下拉加载监听UIScrollView的contentoffsize；
  　　（2）webview混排监听contentsize；
  　　（3）监听模型属性实时更新UI；
  　　（4）监听控制器frame改变，实现抽屉效果。
  
  
  
  
*/
