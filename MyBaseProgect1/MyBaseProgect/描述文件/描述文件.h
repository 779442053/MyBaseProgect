//
//  描述文件.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//
 /*
  #pragma mark - 关闭键盘
  - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.view endEditing:YES];
  }
  #pragma mark - 打印系统所有已注册的字体名称
  void enumerateFonts()
  {
  for(NSString *familyName in [UIFont familyNames])
  {
  NSLog(@"%@",familyName);
  NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
  for(NSString *fontName in fontNames)
  {
  NSLog(@"\t|- %@",fontName);
  }
  }
  }
  //评价我们appstor
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APPID"]];
  //更改状态栏颜色
  - (void)setStatusBarBackgroundColor:(UIColor *)color
  {
  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
  {
  statusBar.backgroundColor = color;
  }
  }
  
  //判断是push还是present进来的
  NSArray *viewcontrollers=self.navigationController.viewControllers;
  
  if (viewcontrollers.count > 1)
  {
  if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self)
  {
  //push方式
  [self.navigationController popViewControllerAnimated:YES];
  }
  }
  else
  {
  //present方式
  [self dismissViewControllerAnimated:YES completion:nil];
  }
  日期格式化
  G: 公元时代，例如AD公元
  yy: 年的后2位
  yyyy: 完整年
  MM: 月，显示为1-12
  MMM: 月，显示为英文月份简写,如 Jan
  MMMM: 月，显示为英文月份全称，如 Janualy
  dd: 日，2位数表示，如02
  d: 日，1-2位显示，如 2
  EEE: 简写星期几，如Sun
  EEEE: 全写星期几，如Sunday
  aa: 上下午，AM/PM
  H: 时，24小时制，0-23
  K：时，12小时制，0-11
  m: 分，1-2位
  mm: 分，2位
  s: 秒，1-2位
  ss: 秒，2位
  S: 毫秒
  
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
  dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
  dispatch_source_set_event_handler(timer, ^{
  //@"倒计时结束，关闭"
  dispatch_source_cancel(timer);
  dispatch_async(dispatch_get_main_queue(), ^{
  
  });
  });
  dispatch_resume(timer);
  
  UITextField每四位加一个空格,实现代理========
  
  - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
  {
  // 四位加一个空格
  if ([string isEqualToString:@""])
  {
  // 删除字符
  if ((textField.text.length - 2) % 5 == 0)
  {
  textField.text = [textField.text substringToIndex:textField.text.length - 1];
  }
  return YES;
  }
  else
  {
  if (textField.text.length % 5 == 0)
  {
  textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
  }
  }
  return YES;
  }
  
  金钱数字展示格式
  //通过NSNumberFormatter，同样可以设置NSNumber输出的格式。例如如下代码：
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterDecimalStyle;
  NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:123456789]];
  NSLog(@"Formatted number string:%@",string);
  //输出结果为：[1223:403] Formatted number string:123,456,789
  
  //其中NSNumberFormatter类有个属性numberStyle，它是一个枚举型，设置不同的值可以输出不同的数字格式。该枚举包括：
  typedef NS_ENUM(NSUInteger, NSNumberFormatterStyle) {
  NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,
  NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,
  NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,
  NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,
  NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,
  NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
  };
  //各个枚举对应输出数字格式的效果如下：其中第三项和最后一项的输出会根据系统设置的语言区域的不同而不同。
  [1243:403] Formatted number string:123456789
  [1243:403] Formatted number string:123,456,789
  [1243:403] Formatted number string:￥123,456,789.00
  [1243:403] Formatted number string:-539,222,988%
  [1243:403] Formatted number string:1.23456789E8
  [1243:403] Formatted number string:一亿二千三百四十五万六千七百八十九
  
  
  分享的时候,跳转到应用市场上面下载我们的应用.再有中文的时候需要将应用地址进行编码处理
  NSString *string = @"http://abc.com?aaa=你好&bbb=tttee";
  //编码 打印：http://abc.com?aaa=%E4%BD%A0%E5%A5%BD&bbb=tttee
  string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  //解码 打印：http://abc.com?aaa=你好&bbb=tttee
  string = [string stringByRemovingPercentEncoding];
  
  #pragma mark - UITextFieldDelegate===============银行卡号的输入
  - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if (textField == _cardTextField) {
  // 四位加一个空格
  if ([string isEqualToString:@""]) { // 删除字符
  if ((textField.text.length - 2) % 5 == 0) {
  textField.text = [textField.text substringToIndex:textField.text.length - 1];
  }
  return YES;
  } else {
  if (textField.text.length % 5 == 0) {
  textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
  }
  }
  return YES;
  }
  return YES;
  }
  + (NSString *)formateBankNum:(NSString *)cardId {
  NSUInteger lenth = cardId.length;
  NSString *str1 = [cardId substringToIndex:4];
  NSString *str2 = [cardId substringFromIndex:lenth - 4];
  NSMutableString *str3 = [[NSMutableString alloc]init];
  for (int i = 0; i < lenth - 8; i++) {
  [str3 appendString:@"*"];
  }
  NSString *str = [NSString stringWithFormat:@"%@%@%@",str1,str3,str2];
  return str;
  }
  
  
  
  iOS最完美的UITextField中输入金额，只能输入数字和小数点，保留两位小数点且0放在首位
  @property (nonatomic, assign) BOOL isHaveDian;
  @property (nonatomic, assign) BOOL isFirstZero;
  
  
  - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if (textField == self.amountTextField) {
  
  if ([textField.text rangeOfString:@"."].location==NSNotFound) {
  _isHaveDian = NO;
  }
  if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
  _isFirstZero = NO;
  }
  
  if ([string length]>0)
  {
  unichar single=[string characterAtIndex:0];//当前输入的字符
  if ((single >='0' && single<='9') || single=='.')//数据格式正确
  {
  
  if([textField.text length]==0){
  if(single == '.'){
  //首字母不能为小数点
  return NO;
  }
  if (single == '0') {
  _isFirstZero = YES;
  return YES;
  }
  }
  
  if (single=='.'){
  if(!_isHaveDian)//text中还没有小数点
  {
  _isHaveDian=YES;
  return YES;
  }else{
  return NO;
  }
  }else if(single=='0'){
  if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
  //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
  if([textField.text isEqualToString:@"0.0"]){
  return NO;
  }
  NSRange ran=[textField.text rangeOfString:@"."];
  int tt=(int)(range.location-ran.location);
  if (tt <= 2){
  return YES;
  }else{
  return NO;
  }
  }else if (_isFirstZero&&!_isHaveDian){
  //首位有0没.不能再输入0
  return NO;
  }else{
  return YES;
  }
  }else{
  if (_isHaveDian){
  //存在小数点，保留两位小数
  NSRange ran=[textField.text rangeOfString:@"."];
  int tt= (int)(range.location-ran.location);
  if (tt <= 2){
  return YES;
  }else{
  return NO;
  }
  }else if(_isFirstZero&&!_isHaveDian){
  //首位有0没点
  return NO;
  }else{
  return YES;
  }
  }
  }else{
  //输入的数据格式不正确
  return NO;
  }
  }else{
  return YES;
  }
  }
  return YES;
  }
  三种情况下需要自己手动创建自动释放吃
  自动释放池被置于一个堆栈中，虽然它们通常被称为被“嵌套”的。当您创建一个新的自动释放池时，它被添加到堆栈的顶部。当自动释放池被回收时，它们从堆栈中被删除。当一个对象收到送autorelease消息时，它被添加到当前线程的目前处于栈顶的自动释放池中。你不能向自动释放池发送autorelease或retain消息。Application Kit会在一个事件周期（或事件循环迭代）的开端—比如鼠标按下事件—自动创建一个自动释放池，并且在事件周期的结尾释放它，因此您的代码通常不必关心。 有三种情况您应该使用您自己的自动释放池：
  
  如果您正在编写一个不是基于Application Kit的程序，比如命令行工具，则没有对自动释放池的内置支持；您必须自己创建它们。
  
  如果您生成了一个从属线程，则一旦该线程开始执行，您必须立即创建您自己的自动释放池；否则，您将会泄漏对象。
  
  如果您编写了一个循环，其中创建了许多临时对象，您可以在循环内部创建一个自动释放池，以便在下次迭代之前销毁这些
  对象。这可以帮助减少应用程序的最大内存占用量。
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  */
