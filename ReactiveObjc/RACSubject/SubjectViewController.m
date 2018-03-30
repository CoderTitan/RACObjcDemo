//
//  SubjectViewController.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/3/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubjectView.h"
#import <ReactiveObjC.h>

@interface SubjectViewController () //<SubjectDelegate>

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RACSubject";
    
    //先订阅, 在发送信号
//    [self setRacSubject1];
    
    //先发送, 在订阅信号
    [self setReplaySubject];
    
    //代替代理
//    [self setupSubjectView];
}

#pragma 先发送, 在订阅信号
- (void)setReplaySubject {
    //创建信号
    RACReplaySubject *replySub = [RACReplaySubject subject];
    
    //发送信号
    [replySub sendNext:@23];
    [replySub sendNext:@34];
    
    //订阅信号
    // 遍历值，让一个订阅者去发送多个值
    // 只要订阅一次，之前所有发送的值都能获取到.
    [replySub subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    /**
     2018-03-19 12:01:14.112253+0800 ReactiveObjc[5130:446958] 23
     2018-03-19 12:01:14.112511+0800 ReactiveObjc[5130:446958] 34
     */
}


#pragma 先订阅, 在发送信号
- (void)setRacSubject1 {
    //先订阅, 在发送信号
    //1. 创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2. 订阅
    //内部创建RACSubscriber
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者--%@", x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者---%@", x);
    }];
    
    //3. 发送信号
    //遍历所有的订阅者, 执行nextBlock
    [subject sendNext:@2];
    
    /** 打印结果
     2018-03-17 20:18:19.782119+0800 ReactiveObjc[23883:1420936] 第一个订阅者--2
     2018-03-17 20:18:19.784715+0800 ReactiveObjc[23883:1420936] 第二个订阅者---2
     */
}



#pragma 代替代理
- (void)setupSubjectView {
    SubjectView *subV = [[SubjectView alloc]init];
    subV.backgroundColor = [UIColor redColor];
    subV.frame = CGRectMake(100, 100, 100, 100);
//    subV.delegate = self;
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"完成代理, 点击了view");
        
        UIColor *color = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1.0];
        self.view.backgroundColor = color;
    }];
    subV.subject = subject;
    [self.view addSubview:subV];
}

/*
/// 代理方法
-(void)viewWithTap:(SubjectView *)subView{
    NSLog(@"完成代理, 点击了view");
    
    UIColor *color = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1.0];
    self.view.backgroundColor = color;
}
 */

@end
