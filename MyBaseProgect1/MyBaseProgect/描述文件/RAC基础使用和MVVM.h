//
//  RAC基础使用和MVVM.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//
 /*
  RAC 使用
   假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
   方式一:在返回结果后，拼接。
  [_textField.rac_textSignal subscribeNext:^(id x) {
  NSLog(@"输出:%@",x);
  }];
  
  方式二:在返回结果前，拼接，使用RAC中bind方法做处理。
  bind方法参数:需要传入一个返回值是RACStreamBindBlock的block参数
  RACStreamBindBlock是一个block的类型，返回值是信号，参数（value,stop），因此参数的block返回值也是一个block。
  
  RACStreamBindBlock:
  参数一(value):表示接收到信号的原始值，还没做处理
  参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
  返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
  
  bind方法使用步骤:
  1.传入一个返回值RACStreamBindBlock的block。
  2.描述一个RACStreamBindBlock类型的bindBlock作为block的返回值。
  3.描述一个返回结果的信号，作为bindBlock的返回值。
  注意：在bindBlock中做信号结果的处理。
  
  底层实现:
  1.源信号调用bind,会重新创建一个绑定信号。
  2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
  3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
  4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
  5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
  
  注意:不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
  这里需要手动导入#import <ReactiveCocoa/RACReturnSignal.h>，才能使用RACReturnSignal。
  [[_textField.rac_textSignal bind:^RACStreamBindBlock{
  
  // 什么时候调用:
  // block作用:表示绑定了一个信号.
  
  return ^RACStream *(id value, BOOL *stop){
  
  // 什么时候调用block:当信号有新的值发出，就会来到这个block。
  
  // block作用:做返回值的处理
  
  // 做好处理，通过信号返回出去.
  return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
  };
  
  }] subscribeNext:^(id x) {
  
  NSLog(@"%@",x);
  
  }];
  
  监听文本框的内容改变，把结构重新映射成一个新值.
  
  flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
  
  flattenMap使用步骤:
  1.传入一个block，block类型是返回值RACStream，参数value
  2.参数value就是源信号的内容，拿到源信号的内容做处理
  3.包装成RACReturnSignal信号，返回出去。
  
  flattenMap底层实现:
  0.flattenMap内部调用bind方法实现的,flattenMap中block的返回值，会作为bind中bindBlock的返回值。
  1.当订阅绑定信号，就会生成bindBlock。
  2.当源信号发送内容，就会调用bindBlock(value, *stop)
  3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
  4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
  5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
  [[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
  
  // block什么时候 : 源信号发出的时候，就会调用这个block。
  
  // block作用 : 改变源信号的内容。
  
  // 返回值：绑定信号的内容.
  return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
  
  }] subscribeNext:^(id x) {
  
  // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
  
  NSLog(@"%@",x);
  
  }];
  
  Map作用:把源信号的值映射成一个新的值
  
  Map使用步骤:
  1.传入一个block,类型是返回对象，参数是value
  2.value就是源信号的内容，直接拿到源信号的内容做处理
  3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
  
  Map底层实现:
  0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
  1.当订阅绑定信号，就会生成bindBlock。
  3.当源信号发送内容，就会调用bindBlock(value, *stop)
  4.调用bindBlock，内部就会调用flattenMap的block
  5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
  5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
  6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
  
  [[_textField.rac_textSignal map:^id(id value) {
  当源信号发出，就会调用这个block，修改源信号的内容
  返回值：就是处理完源信号的内容。
  return [NSString stringWithFormat:@"输出:%@",value];
  }] subscribeNext:^(id x) {
  
  NSLog(@"%@",x);
  }];
  
  FlatternMap和Map的区别
  
  1.FlatternMap中的Block返回信号。
  2.Map中的Block返回对象。
  3.开发中，如果信号发出的值不是信号，映射一般使用Map
  4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
  
  
  // 创建信号中的信号
  RACSubject *signalOfsignals = [RACSubject subject];
  RACSubject *signal = [RACSubject subject];
  
  [[signalOfsignals flattenMap:^RACStream *(id value) {
  
  // 当signalOfsignals的signals发出信号才会调用
  
  return value;
  
  }] subscribeNext:^(id x) {
  
  //只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
  也就是flattenMap返回的信号发出内容，才会调用。
  
  NSLog(@"%@aaa",x);
  }];
  
  //信号的信号发送信号
  [signalOfsignals sendNext:signal];
  
  //信号发送内容
  [signal sendNext:@1];
  
  
  //////concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
  RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
  
  [subscriber sendNext:@1];
  
  [subscriber sendCompleted];
  
  return nil;
  }];
  RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
  
  [subscriber sendNext:@2];
  
  return nil;
  }];
  
  
  // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
  RACSignal *concatSignal = [signalA concat:signalB];
  
  // 以后只需要面对拼接信号开发。
  // 订阅拼接的信号，不需要单独订阅signalA，signalB
  // 内部会自动订阅。
  // 注意：第一个信号必须发送完成，第二个信号才会被激活
  [concatSignal subscribeNext:^(id x) {
  
  NSLog(@"%@",x);
  
  }];
  
  concat底层实现:
  1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
  2.didSubscribe中，会先订阅第一个源信号（signalA）
  3.会执行第一个源信号（signalA）的didSubscribe
  4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
  5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
  6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
  7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
  
  
  3.ReactiveCocoa + MVVM 实战一：登录界面
  
  需求：1.监听两个文本框的内容，有内容才允许按钮点击
  2.默认登录请求.
  
  用MVVM：实现，之前界面的所有业务逻辑
  分析：1.之前界面的所有业务逻辑都交给控制器做处理
  2.在MVVM架构中把控制器的业务全部搬去VM模型，也就是每个控制器对应一个VM模型.
  
  步骤：1.创建LoginViewModel类，处理登录界面业务逻辑.
  2.这个类里面应该保存着账号的信息，创建一个账号Account模型
  3.LoginViewModel应该保存着账号信息Account模型。
  4.需要时刻监听Account模型中的账号和密码的改变，怎么监听？
  5.在非RAC开发中，都是习惯赋值，在RAC开发中，需要改变开发思维，由赋值转变为绑定，可以在一开始初始化的时候，就给Account模型中的属性绑定，并不需要重写set方法。
  6.每次Account模型的值改变，就需要判断按钮能否点击，在VM模型中做处理，给外界提供一个能否点击按钮的信号.
  7.这个登录信号需要判断Account中账号和密码是否有值，用KVO监听这两个值的改变，把他们聚合成登录信号.
  8.监听按钮的点击，由VM处理，应该给VM声明一个RACCommand，专门处理登录业务逻辑.
  9.执行命令，把数据包装成信号传递出去
  10.监听命令中信号的数据传递
  11.监听命令的执行时刻
  ==============上面的全是废话.是为了忽悠面试官的.下面的才是实际运用的=========
  
  
  
  
  
  
  
  
  */
