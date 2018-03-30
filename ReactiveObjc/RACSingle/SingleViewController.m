//
//  SingleViewController.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/3/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "SingleViewController.h"
#import <ReactiveObjC.h>

@interface SingleViewController ()

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RACSignal";
    
    [self setRacSingle];
}

- (void)setRacSingle {
    //创建信号
    RACSignal *single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送消息
        [subscriber sendNext:@"a"];
        [subscriber sendNext:@"b"];
        //发送完成
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号
        [subscriber sendCompleted];
        
        //清空数据
        return [RACDisposable disposableWithBlock:^{
            //当订阅者被消耗的时候就会执行
            //当订阅者发送完成,或者error的时候也会执行
            NSLog(@"RACDisposable的block");
        }];
    }];
    
    //订阅信号
    RACDisposable *disposable = [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"value = %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    
    //释放
    [disposable dispose];
}

@end
