//
//  ViewController.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/2/7.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

- (void)test2 {
    //创建信号
    RACSignal *single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送消息
        [subscriber sendNext:@"a"];
        [subscriber sendNext:@"b"];
        //发送完成
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

- (void)test1 {
    //创建信号 --> 订阅信号 (响应式变成思想: 只要信号一变化, 马上就会通知你)
    
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号变化
        NSLog(@"RACSignal的block");
        
        //处理网络请求
        
        
        //发送消息
        [subscriber sendNext:@10];
        //发送完成
        [subscriber sendCompleted];
        
        //清空数据
        return [RACDisposable disposableWithBlock:^{
            //当订阅者被消耗的时候就会执行
            //当订阅者发送完成,或者error的时候也会执行
            NSLog(@"RACDisposable的block");
        }];
    }];
    
    
    //订阅信号
    /*
     [signal subscribeNext:^(id  _Nullable x) {
     //处理订阅的事件
     }];
     
     [signal subscribeNext:^(id  _Nullable x) {
     //处理订阅的事件
     
     } error:^(NSError * _Nullable error) {
     //处理error的事件
     
     }];
     */
    
    [signal subscribeNext:^(id  _Nullable x) {
        //处理订阅的事件
    } error:^(NSError * _Nullable error) {
        //处理error的事件
    } completed:^{
        //处理订阅事件完成的操作
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
