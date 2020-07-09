//
//  runtime使用描述.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//

 /*
  
  获取私有属性和成员变量 #import <objc/runtime.h>
  //获取私有属性 比如设置UIDatePicker的字体颜色
  - (void)setTextColor
  {
  //获取所有的属性，去查看有没有对应的属性
  unsigned int count = 0;
  objc_property_t *propertys = class_copyPropertyList([UIDatePicker class], &count);
  for(int i = 0;i < count;i ++)
  {
  //获得每一个属性
  objc_property_t property = propertys[i];
  //获得属性对应的nsstring
  NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
  //输出打印看对应的属性
  NSLog(@"propertyname = %@",propertyName);
  if ([propertyName isEqualToString:@"textColor"])
  {
  [datePicker setValue:[UIColor whiteColor] forKey:propertyName];
  }
  }
  }
  
  //获得成员变量 比如修改UIAlertAction的按钮字体颜色
  unsigned int count = 0;
  Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
  for(int i =0;i < count;i ++)
  {
  Ivar ivar = ivars[i];
  NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
  NSLog(@"uialertion.ivarName = %@",ivarName);
  if ([ivarName isEqualToString:@"_titleTextColor"])
  {
  [alertOk setValue:[UIColor blueColor] forKey:@"titleTextColor"];
  [alertCancel setValue:[UIColor purpleColor] forKey:@"titleTextColor"];
  }
  }
  ===============================存储User类的时候======================
  runtime从入门到精通（七）—— 自动归档和解档
  如果你实现过自定义模型数据持久化的过程，那么你也肯定明白，如果一个模型有许多个属性，那么我们需要对每个属性都实现一遍encodeObject 和decodeObjectForKey方法，如果这样的模型又有很多个，这还真的是一个十分麻烦的事情。下面来看看简单的实现方式
  例如工程中move例子
  
  //1. 如果想要当前类可以实现归档与反归档，需要遵守一个协议NSCoding
  @interface Movie : NSObject<NSCoding>
  
  @property (nonatomic, copy) NSString *movieId;
  @property (nonatomic, copy) NSString *movieName;
  @property (nonatomic, copy) NSString *pic_url;
  
  @end
  
  #import <objc/runtime.h>
  
  - (void)encodeWithCoder:(NSCoder *)encoder
  
  {
  unsigned int count = 0;
  Ivar *ivars = class_copyIvarList([Movie class], &count);
  
  for (int i = 0; i<count; i++) {
  // 取出i位置对应的成员变量
  Ivar ivar = ivars[i];
  // 查看成员变量
  const char *name = ivar_getName(ivar);
  // 归档
  NSString *key = [NSString stringWithUTF8String:name];
  id value = [self valueForKey:key];
  [encoder encodeObject:value forKey:key];
  }
  free(ivars);
  }
  
  - (id)initWithCoder:(NSCoder *)decoder
  {
  if (self = [super init]) {
  unsigned int count = 0;
  Ivar *ivars = class_copyIvarList([Movie class], &count);
  for (int i = 0; i<count; i++) {
  // 取出i位置对应的成员变量
  Ivar ivar = ivars[i];
  // 查看成员变量
  const char *name = ivar_getName(ivar);
  // 归档
  NSString *key = [NSString stringWithUTF8String:name];
  id value = [decoder decodeObjectForKey:key];
  // 设置到成员变量身上
  [self setValue:value forKey:key];
  
  }
  free(ivars);
  }
  return self;
  }
  @end
  
  利用Runtime来字典转模型
  思路：利用运行时，遍历模型中所有属性，根据模型的属性名，去字典中查找key，取出对应的值，给模型的属性赋值。
  步骤：提供一个NSObject分类，专门字典转模型，以后所有模型都可以通过这个分类转
  
  + (instancetype)modelWithDict:(NSDictionary *)dict
  {
  // 思路：遍历模型中所有属性-》使用运行时
  
  // 0.创建对应的对象
  id objc = [[self alloc] init];
  
  // 1.利用runtime给对象中的成员属性赋值
  
  // class_copyIvarList:获取类中的所有成员属性
  // Ivar：成员属性的意思
  // 第一个参数：表示获取哪个类中的成员属性
  // 第二个参数：表示这个类有多少成员属性，传入一个Int变量地址，会自动给这个变量赋值
  // 返回值Ivar *：指的是一个ivar数组，会把所有成员属性放在一个数组中，通过返回的数组就能全部获取到。
  /* 类似下面这种写法
  
  Ivar ivar;
  Ivar ivar1;
  Ivar ivar2;
  // 定义一个ivar的数组a
  Ivar a[] = {ivar,ivar1,ivar2};
  
  // 用一个Ivar *指针指向数组第一个元素
  Ivar *ivarList = a;
  
  // 根据指针访问数组第一个元素
  ivarList[0];
  
  
unsigned int count;

// 获取类中的所有成员属性
Ivar *ivarList = class_copyIvarList(self, &count);

for (int i = 0; i < count; i++) {
    // 根据角标，从数组取出对应的成员属性
    Ivar ivar = ivarList[i];
    
    // 获取成员属性名
    NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 处理成员属性名->字典中的key
    // 从第一个角标开始截取
    NSString *key = [name substringFromIndex:1];
    
    // 根据成员属性名去字典中查找对应的value
    id value = dict[key];
    
    // 二级转换:如果字典中还有字典，也需要把对应的字典转换成模型
    // 判断下value是否是字典
    if ([value isKindOfClass:[NSDictionary class]]) {
        // 字典转模型
        // 获取模型的类对象，调用modelWithDict
        // 模型的类名已知，就是成员属性的类型
        
        // 获取成员属性类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 生成的是这种@"@\"User\"" 类型 -》 @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
        // 裁剪类型字符串
        NSRange range = [type rangeOfString:@"\""];
        
        type = [type substringFromIndex:range.location + range.length];
        
        range = [type rangeOfString:@"\""];
        
        // 裁剪到哪个角标，不包括当前角标
        type = [type substringToIndex:range.location];
        
        
        // 根据字符串类名生成类对象
        Class modelClass = NSClassFromString(type);
        
        
        if (modelClass) { // 有对应的模型才需要转
            
            // 把字典转模型
            value  =  [modelClass modelWithDict:value];
        }
        
        
    }
    
    // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
    // 判断值是否是数组
    if ([value isKindOfClass:[NSArray class]]) {
        // 判断对应类有没有实现字典数组转模型数组的协议
        if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
            
            // 转换成id类型，就能调用任何对象的方法
            id idSelf = self;
            
            // 获取数组中字典对应的模型
            NSString *type =  [idSelf arrayContainModelClass][key];
            
            // 生成模型
            Class classModel = NSClassFromString(type);
            NSMutableArray *arrM = [NSMutableArray array];
            // 遍历字典数组，生成模型数组
            for (NSDictionary *dict in value) {
                // 字典转模型
                id model =  [classModel modelWithDict:dict];
                [arrM addObject:model];
            }
            
            // 把模型数组赋值给value
            value = arrM;
            
        }
    }
    
    
    if (value) { // 有值，才需要给模型的属性赋值
        // 利用KVC给模型中的属性赋值
        [objc setValue:value forKey:key];
    }
    
}

return objc;
}
  
  
  */
