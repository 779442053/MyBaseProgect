//
//  FMDB使用.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/15.
//  Copyright © 2018年 张威威. All rights reserved.
//

 /* F
  //1.创建database路径
  NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  NSString *dbPath = [docuPath stringByAppendingPathComponent:@"test.db"];
  NSLog(@"!!!dbPath = %@",dbPath);
  //2.创建对应路径下数据库
  db = [FMDatabase databaseWithPath:dbPath];
  //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
  [db open];
  if (![db open]) {
  NSLog(@"db open fail");
  return;
  }
  //4.数据库中创建表（可创建多张）
  NSString *sql = @"create table if not exists t_student ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'phone' TEXT NOT NULL,'score' INTEGER NOT NULL)";
  //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
  BOOL result = [db executeUpdate:sql];
  if (result) {
  NSLog(@"create table success");
  
  }
  [db close];
  
  
  
  数据存储
  XML属性列表（plist）归档
  
  Preference(偏好设置)
  
  NSKeyedArchiver归档(NSCoding)
  
  SQLite3
  
  Core Data
  
  沙盒下面的文件夹
  Documents：保存应用运行时生成的需要持久化的数据，iTunes同步设备时会备份该目录。例如，游戏应用可将游戏存档保存在该目录
  tmp：保存应用运行时所需的临时数据，使用完毕后再将相应的文件从该目录删除。应用没有运行时，系统也可能会清除该目录下的文件。iTunes同步设备时不会备份该目录
  Library/Caches：保存应用运行时生成的需要持久化的数据，iTunes同步设备时不会备份该目录。一般存储体积大、不需要备份的非重要数据
  Library/Preference：保存应用的所有偏好设置，iOS的Settings(设置)应用会在该目录中查找应用的设置信息。iTunes同步设备时会备份该目录
  
  1.plist存储,生成一个plist文件.
  
  2.plist不是数组就是字典,plist存储就是用来存储字典或者数组.
  
  注意:Plist不能存储自定义对象
  
  
  6、属性列表
  
  属性列表是一种XML格式的文件，拓展名为plist
  
  如果对象是NSString、NSDictionary、NSArray、NSData、NSNumber等类型，就可以使用writeToFile:atomically:方法直接将对象写到属性列表文件中
  
  
  
  
  
  
  
  
  
  */
