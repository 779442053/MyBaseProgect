//
//  set&get方法.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//

 /*
  使用@property声明了成员变量，没有自己去写它的set方法和get方法，系统会自动给你生成。同时生成一个下划线成员变量
  如果你自己写了set方法，却没有在里面做任何操作，会默认调用_age。所有的成员变量初始值都是0.所以即便你在调用set方法的时候赋值，打印出来也是0
  @property (nonatomic, assign) NSInteger age;
  Dog *aDog = [Dog new];
  aDog.age= 5;
  NSLog(@"%zd",aDog.age);//打印得5
  自己实现set之后
  //Dog.m文件 实现部分。set方法不做操作
  -(void)setAge:(NSInteger)age {
  
  }
  Dog *aDog = [Dog new];
  aDog.age= 5;
  NSLog(@"%zd",aDog.age);//打印得0
  如果你自己写了get方法，在里面return 10。你在调用get方法的时候赋值，打印出来也是就是你get方法里面返回的值10
  //Dog.m文件 实现部分。get方法 return 10
  - (NSInteger)age {
  return 10;
  }
  Dog *aDog = [Dog new];
  aDog.age= 5;
  NSLog(@"%zd",aDog.age);//打印得10
  
  如果你自己同时生成了set和get方法，那系统就不会生成下划线成员变量
  
  
  建议查看这篇博客
  https://blog.csdn.net/u014358913/article/details/45627021
  
  
  
  
  
  
  
  
  
  
  
  
  
  */
