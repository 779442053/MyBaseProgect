//
//  代理使用.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//
 /*
  iOS中消息传递方式
  在iOS中有很多种消息传递方式，这里先简单介绍一下各种消息传递方式。
  通知：在iOS中由通知中心进行消息接收和消息广播，是一种一对多的消息传递方式。
  代理：是一种通用的设计模式，iOS中对代理支持的很好，由代理对象、委托者、协议三部分组成。
  block：iOS4.0中引入的一种回调方法，可以将回调处理代码直接写在block代码块中，看起来逻辑清晰代码整齐。
  target action：通过将对象传递到另一个类中，在另一个类中将该对象当做target的方式，来调用该对象方法，从内存角度来说和代理类似。
  KVO：NSObject的Category－NSKeyValueObserving，通过属性监听的方式来监测某个值的变化，当值发生变化时调用KVO的回调方法
  
  
  
  
  代理是一种通用的设计模式，在iOS中对代理设计模式支持的很好，有特定的语法来实现代理模式，OC语言可以通过@Protocol实现协议。
  
  代理主要由三部分组成：
  
  协议：用来指定代理双方可以做什么，必须做什么。
  代理：根据指定的协议，完成委托方需要实现的功能。
  委托：根据指定的协议，指定代理去完成什么功能。
  ====================*********************=================***********************
  下面自定义cell的里面按钮的点击
  #import <UIKit/UIKit.h>
  #import "NewsModel.h"
  
  @protocol NewsCellDelegate <NSObject>
  
  @optional
  - (void)menuButtonClickedWithID:(NSString *)articleID;
  - (void)swipeLeft;
  
  @end
  @interface NewsCell : UITableViewCell
  
  @property (nonatomic, strong) NewsModel *model;
  @property (nonatomic, weak) id<NewsCellDelegate> delegate;
  
  + (instancetype)cellWithTableView:(UITableView *)tableview NewsModel:(NewsModel *)model;
  
  @end
  
  #import "NewsCell.h"
  #import <SDWebImage/UIImageView+WebCache.h>
  #import <UIImageView+YYWebImage.h>
  #import <CALayer+YYWebImage.h>
  #import <UIImage+YYWebImage.h>
  
  @interface NewsCell()
  
  @property (nonatomic, weak) CALayer *avator;
  @property (nonatomic, weak) UILabel *nickname;
  @property (nonatomic, weak) UIButton *menu;
  @property (nonatomic, weak) CALayer *banner;
  @property (nonatomic, weak) UILabel *articleTitle;
  @property (nonatomic, weak) UILabel *rmdDescription;
  @property (nonatomic, weak) UIImageView *likeIcon;
  @property (nonatomic, weak) UILabel *likeAndComment;
  @property (nonatomic, weak) UILabel *postTime;
  
  @end
  
  @implementation NewsCell
  
  + (instancetype)cellWithTableView:(UITableView *)tableview NewsModel:(NewsModel *)model
  {
  static NSString *identifier = @"newsCell";
  NewsCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
  {
  cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  [cell setupUI];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.model = model;
  return cell;
  }
  
  - (void)setupUI
  {
  self.contentView.backgroundColor = [UIColor whiteColor];
  CALayer *avator = [[CALayer alloc] init];
  [self.contentView.layer addSublayer:avator];
  avator.frame = CGRectMake(25, 15, 30, 30);
  self.avator = avator;
  
  UILabel *nickname = [[UILabel alloc] init];
  [self.contentView addSubview:nickname];
  nickname.frame = CGRectMake(65, 22.5, 150, 15);
  
  nickname.textAlignment = NSTextAlignmentLeft;
  nickname.font = [UIFont systemFontOfSize:14.0];
  nickname.textColor = UIColor(102, 102, 102);
  self.nickname = nickname;
  
  UIButton *menu = [[UIButton alloc] init];
  [self.contentView addSubview:menu];
  [menu setImage:[UIImage imageNamed:@"more_18x4_"] forState:UIControlStateNormal];
  #pragma mark -  ===========这是masary第三方布局============
  [menu mas_makeConstraints:^(MASConstraintMaker *make) {
  make.top.mas_equalTo(self.contentView.mas_top).with.offset(17.5);
  make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25.0);
  make.width.mas_equalTo(25.0);
  make.height.mas_equalTo(25.0);
  }];
  [menu addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
  self.menu = menu;
  
  CALayer *banner = [[CALayer alloc] init];
  [self.contentView.layer addSublayer:banner];
  banner.frame = CGRectMake(25, 55, LYScreenWidth - 50, (LYScreenWidth - 50) * 0.3331);
  self.banner = banner;
  
  UILabel *title = [[UILabel alloc] init];
  [self.contentView addSubview:title];
  title.textAlignment = NSTextAlignmentLeft;
  title.font = [UIFont boldSystemFontOfSize:20.0];
  title.textColor = [UIColor blackColor];
  //    设置行数自适应，无需写masonry中的高度
  title.preferredMaxLayoutWidth = (LYScreenWidth - 50.0);
  [title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  title.numberOfLines = 0;
  [title mas_makeConstraints:^(MASConstraintMaker *make) {
  make.left.mas_equalTo(self.contentView.mas_left).with.offset(25.0);
  make.top.mas_equalTo(self.contentView.mas_top).with.offset(70 + (LYScreenWidth - 50) * 0.3331);
  make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25.0);
  }];
  self.articleTitle = title;
  
  UILabel *articleDes = [[UILabel alloc] init];
  [self.contentView addSubview:articleDes];
  articleDes.preferredMaxLayoutWidth = (LYScreenWidth - 50.0);
  [articleDes setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  articleDes.numberOfLines = 0;
  [articleDes mas_makeConstraints:^(MASConstraintMaker *make) {
  make.left.mas_equalTo(self.contentView.mas_left).with.offset(25.0);
  make.top.mas_equalTo(self.articleTitle.mas_bottom).with.offset(10.0);
  make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25.0);
  }];
  articleDes.textAlignment = NSTextAlignmentLeft;
  articleDes.font = [UIFont systemFontOfSize:14.0];
  articleDes.textColor = UIColor(170, 170, 170);
  self.rmdDescription = articleDes;
  
  UIImageView *like = [[UIImageView alloc] init];
  [self.contentView addSubview:like];
  [like setImage:[UIImage imageNamed:@"like_20x17_"]];
  [like mas_makeConstraints:^(MASConstraintMaker *make) {
  make.left.mas_equalTo(self.contentView.mas_left).with.offset(25.0);
  make.top.mas_equalTo(self.rmdDescription.mas_bottom).with.offset(12.0);
  make.width.mas_equalTo(14.0);
  make.height.mas_equalTo(11.9);
  }];
  self.likeIcon = like;
  
  UILabel *comments = [[UILabel alloc] init];
  [self.contentView addSubview:comments];
  [comments mas_makeConstraints:^(MASConstraintMaker *make) {
  make.left.mas_equalTo(self.likeIcon.mas_right).with.offset(8.0);
  make.top.mas_equalTo(self.rmdDescription.mas_bottom).with.offset(10.0);
  make.width.mas_equalTo(150.0);
  make.height.mas_equalTo(14.0);
  }];
  comments.textAlignment = NSTextAlignmentLeft;
  comments.font = [UIFont systemFontOfSize:12.0];
  comments.textColor = UIColor(107, 107, 107);
  self.likeAndComment = comments;
  
  UILabel *timeLabel = [[UILabel alloc] init];
  [self.contentView addSubview:timeLabel];
  [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
  make.top.mas_equalTo(self.rmdDescription.mas_bottom).with.offset(10.0);
  make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25.0);
  make.width.mas_equalTo(100);
  make.height.mas_equalTo(14.0);
  }];
  timeLabel.textAlignment = NSTextAlignmentRight;
  timeLabel.font = [UIFont systemFontOfSize:12.0];
  timeLabel.textColor = UIColor(208, 208, 208);
  self.postTime = timeLabel;
  
  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
  swipe.delaysTouchesBegan = YES;
  swipe.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.contentView addGestureRecognizer:swipe];
  }
  #pragma mark -  ===========重写模型的setget方法============
  - (void)setModel:(NewsModel *)model
  {
  _model = model;
  [self.avator yy_setImageWithURL:[NSURL URLWithString:model.avator] placeholder:nil options:kNilOptions progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
  image = [image yy_imageByRoundCornerRadius:60.0];
  return image;
  } completion:nil];
  self.nickname.text = model.nickname;
  self.articleTitle.text = model.title;
  [self.banner yy_setImageWithURL:[NSURL URLWithString:model.banner] placeholder:nil options:kNilOptions progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
  image = [image yy_imageByRoundCornerRadius:5.0];
  return image;
  } completion:nil];
  
  //    NSLog(@"screen width %f", LYScreenWidth);
  //    NSLog(@"length::: %ld", model.summary.length);
  if((float)model.summary.length/LYScreenWidth > 0.11)
  {
  NSString *temStr = [model.summary substringToIndex:(int)(LYScreenWidth * 0.11)];
  model.summary = [temStr stringByAppendingString:@"…"];
  }
  self.rmdDescription.text = model.summary;
  self.likeAndComment.text = [NSString stringWithFormat:@"%@  · %@ 评论", model.like_total, model.comment_total];
  self.postTime.text = @"18 小时前";
  }
  
  - (void)menuClicked
  {
  if([self.delegate respondsToSelector:@selector(menuButtonClickedWithID:)])
  {
  [self.delegate menuButtonClickedWithID:self.model.articleID];
  }
  }
  
  - (void)swipeLeft
  {
  NSLog(@"swipe left");
  if([self.delegate respondsToSelector:@selector(swipeLeft)])
  {
  [self.delegate swipeLeft];
  }
  }
  
  @end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  */
