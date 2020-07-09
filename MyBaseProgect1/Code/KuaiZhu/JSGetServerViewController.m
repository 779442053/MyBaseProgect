/*
 1）本地写死15个链接服务器，随机取一个来链接，如果这个死掉了，就随机取下一个。
 （2）只要有一个没有被打死，就从服务器更新所有的备用地址（譬如更新了5个），保存到本地，但是并不马上启用！
 （3）如果这15个都死光了，就12个小时之后，从更新的主控地址列表中随机选择一个来链接。
 （4）下一次启动APP的时候，继续优先选择前面15个来试探是否可以链接；
 （5）如果这15个还是无法链接，就从这后面的5个地址里随机取一个来链接。


 */
#import "JSGetServerViewController.h"

#import <CommonCrypto/CommonCryptor.h>

@interface JSGetServerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *serverBg;

@property (nonatomic, strong) NSMutableArray *urlDatas;//可选的15个URL
@property (nonatomic, strong) NSString *UploadURL;//上传录音附近的地址,将来需要从后端获取的
@property (nonatomic, assign) NSInteger currentIndex;//当前随机选用的下标
@property (nonatomic, strong) NSString *UmKey;

@end

@implementation JSGetServerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _currentIndex = -1;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getBaseUrl];
}

#pragma mark - Private

- (void)getBaseUrl
{
    
    //当前下标不是 -1 则把不可用的地址从备用地址库移除
    if (_currentIndex != -1) {
        
        [self.urlDatas removeObjectAtIndex:_currentIndex];
        
        if (!self.urlDatas.count) {
            
            [YJProgressHUD hideHUD];
            
            //1.从本地取出预存的时间点
            //eg.2019-10-29 14:05:42
            NSString *startDateStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"K_AVAILABLE_SERVERS_CURRENTTIME"] length] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"K_AVAILABLE_SERVERS_CURRENTTIME"]  : @"";
            NSLog(@"已存本地时间日期:%@",startDateStr);
            //2.如果没有预存的时间则返回
            if (!startDateStr.length) {
                [self showInfo];
                return;
            }
            //3.取到当前时间点
            //eg.2019-10-29 14:06:52
            NSString *endDateStr = [self getNowTime];
            NSLog(@"备用可用地址时日期:%@",endDateStr);
            //4.比较两个时间点的差
            NSInteger min = [self compareWithStartDate:startDateStr andEndDate:endDateStr];
            //5.如果两个时间差小于12小时则返回
            if (min < 12) {
                [self showInfo];
                return;
            }
            
            //6.从本地得到服务器获取到的地址
            NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:K_APP_CONFIG_KEY];
            //7.通过分隔符 | 生成数组
            NSArray *urls = [urlStr componentsSeparatedByString:@"|"];
            
            // 如果本地存在保存过的URL
            // 那么就从这几个服务器中随机选一个
            if (urls.count) {
                NSInteger index = arc4random()%urls.count;
                NSString *url = urls[index];
                if (self.HasAvailableServerBlock) {
                    NSString *htmlUrl = [NSString stringWithFormat:@"%@yj.htm",url];
                    [[NSUserDefaults standardUserDefaults] setObject:htmlUrl forKey:@"html"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    self.HasAvailableServerBlock(url,self.UploadURL,self.UmKey);
                }
            }else{
                [self showInfo];
            }
            
            return;
        }
    }
    
    //生成一个随机的下标
    _currentIndex = arc4random()%self.urlDatas.count;
    
    [YJProgressHUD showLoading:@"努力联网中..."];
    
    //利用得到url请求备用服务器
    [self getStandbyUrl:self.urlDatas[_currentIndex]];
    
}
/// 比较两个时间差
- (NSInteger)compareWithStartDate:(NSString *)startDateStr andEndDate:(NSString *)endDateStr
{
    NSDate *startDate = [NSDate dateWithString:startDateStr format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate dateWithString:endDateStr format:@"yyyy-MM-dd HH:mm:ss"];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //比较小时差异
    NSCalendarUnit unit = NSCalendarUnitHour;
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];

    return delta.hour;
}

- (void)getStandbyUrl:(NSString *)urlStr
{

    //请求备用服务器
    NSString *url = [NSString stringWithFormat:@"%@Servers",urlStr];
    ZWWLog(@"当前取到的URL:%@",url);///get   获取 服务器列表
    [Utils getRequestForServerData:url withParameters:@{} AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
        [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    } AndSuccessBack:^(id  _Nullable _responseData) {
       ZWWLog(@"%@",_responseData);
        [YJProgressHUD hideHUD];
        self.serverBg.image = [UIImage imageNamed:@"servers"];//

        if ([[_responseData allKeys] containsObject:@"servers"]) {

            NSString *servers = _responseData[@"servers"];

            //BASE64 解码
            NSString *hexStr = [self decodeBase64ToHexString:servers];
            //DES解码
            NSString *enCodeDES =  [self decryptUseDES:hexStr key:@"fast!cat"];
            //UTF-8解码
            NSString *utf8Str = [enCodeDES stringByRemovingPercentEncoding];

            //获取当前时间
            NSString *dateStr = [self getNowTime];
            NSLog(@"获取可用地址时间日期:%@",dateStr);

            [[NSUserDefaults standardUserDefaults] setObject:utf8Str forKey:K_APP_CONFIG_KEY];//存到本地
            [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"K_AVAILABLE_SERVERS_CURRENTTIME"];
            [[NSUserDefaults standardUserDefaults] setObject:self.UploadURL forKey:AppUrlUploadFile];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 如果存在可用服务器
            if (self.HasAvailableServerBlock) {
                NSString *htmlUrl = [NSString stringWithFormat:@"%@yj.htm",urlStr];
                [[NSUserDefaults standardUserDefaults] setObject:htmlUrl forKey:@"html"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.HasAvailableServerBlock(urlStr,self.UploadURL, self.UmKey);
            }
        }

    } AndFailureBack:^(NSString * _Nullable _strError) {
        [self getBaseUrl];
    } WithisLoading:NO];
}

- (NSString *)getNowTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *dateStr = [fomatter stringFromDate:date];

    return dateStr;
}

- (void)showInfo
{
    [YJProgressHUD showMessage:@"无可用服务器"];
    [self performSelector:@selector(exitAction) afterDelay:2.0];
}

- (void)exitAction
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow*window = app.window;//动画
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    }completion:^(BOOL finished) {
        exit(0);
    }];
}

//Base64 字符串解码成 字符串
- (NSString *)decodeBase64ToHexString:(NSString *)input
{
    //1.将base64编码后的字符串『解码』为二进制数据
    //这是苹果已经给我们提供的方法
    NSData *myD = [[NSData alloc]initWithBase64EncodedString:input options:0];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
    
}

//解密
- (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    
    NSData* cipherData = [self convertHexStrToData:[cipherText lowercaseString]];
    ZWWLog(@"++++++++///%@",cipherData);
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    NSString *testString = key;
    NSData *testData = [testString dataUsingEncoding: NSUTF8StringEncoding];
    Byte *iv = (Byte *)[testData bytes];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return plainText;
}

- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

#pragma mark - Getter

- (NSMutableArray *)urlDatas
{
#warning 15个预选服务器请自行填写
    if (!_urlDatas) {
        _urlDatas = @[
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
            @"http://154.8.172.16:5001/API/",
        ].mutableCopy;
    }
    return _urlDatas;
}
-(NSString *)UploadURL{
    if (_UploadURL == nil) {
        _UploadURL = @"http://154.8.172.16:5600/UploadLite";
    }
    return _UploadURL;
}
-(NSString *)UmKey{
    if (_UmKey == nil) {
        _UmKey = @"5dd2900e0cafb2689d000eff";
    }
    return _UmKey;
}

@end
