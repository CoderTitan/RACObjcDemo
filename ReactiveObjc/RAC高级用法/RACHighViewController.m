//
//  RACHighViewController.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/3/22.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "RACHighViewController.h"
#import <ReactiveObjC.h>
#import <RACReturnSignal.h>

@interface RACHighViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation RACHighViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RAC的高级用法";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //RAC的高级用法
    //bind用法
//    [self setBindHighAction];
    
    //map-flatMap
//    [self setMapAndFlatMapAction];
    
    //信号中信号
//    [self singleAndSingle];
    
    //concat
//    [self setConcatAction];
    
    //then
//    [self setThenAction];
    
    //merge
//    [self setMergeAction];
    
    //zipWith
//    [self setZipwithAction];
    
    //CombineLatest
//    [self setCombineLatest];
    
    //reduce
//    [self setReduceAction];
    
    //过滤
//    [self setFilterAndMoreAction];
    
    //定时器
//    [self setSchedulerAction];
    
    //重复操作
    [self setResertAction];
}

#pragma bind用法
- (void)setBindHighAction {
     //方式一: 在返回结果后添加
    @weakify(self)
    [_accountText.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.passwordText.text = [NSString stringWithFormat:@"%@+%@", x, @"jun"];
    }];
     
     //方式二:
    [[_accountText.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id value, BOOL *stop){
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出: %@", value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma map-flatMap
- (void)setMapAndFlatMapAction {
    //flatMap
    @weakify(self)
    [[_accountText.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        //源信号发出的时候，就会调用这个block。
        //返回值：绑定信号的内容.
        return [RACReturnSignal return:[NSString stringWithFormat:@"flat输出: %@", value]];
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //订阅绑定信号, 每当原信号发送内容, 处理后, 就会调用这个black
        self.passwordText.text = x;
        NSLog(@"%@", x);
    }];

    
    //Map
    [[_accountText.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"map输出: %@", value];
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.passwordText.text = x;
        NSLog(@"%@", x);
    }];
    
    
    //对数组的处理
    NSArray *arr = @[@"2", @"3", @"a", @"g"];
    RACSequence *sequence = [arr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        
        return [NSString stringWithFormat:@"-%@-", value];
    }];
    
    NSLog(@"%@", [sequence array]);
}

#pragma 信号中信号
- (void)singleAndSingle {
    //创建信号中信号
    RACSubject *sonSingle = [RACSubject subject];
    RACSubject *single = [RACSubject subject];
    
    [[sonSingle flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        //sonSingle发送信号时, 才会调用
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        //只有sonSingle的子信号, 大宋消息时, 才会调用
        NSLog(@"输出: %@", x);
    }];
    
    //信号中信号发送子信号
    [sonSingle sendNext:single];
    //子信号发送内容
    [single sendNext:@123];
}

#pragma concat
- (void)setConcatAction {
    //当需要按顺序执行的时候: 先执行A, 在执行B
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACReplaySubject subject];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //订阅信号
    [subjectA subscribeNext:^(id  _Nullable x) {
        [array addObject:x];
    }];
    [subjectB subscribeNext:^(id  _Nullable x) {
        [array addObject:x];
    }];
    
    //发送信号
    [subjectB sendNext:@"B"];
    [subjectA sendNext:@"A"];
    [subjectA sendCompleted];
    
    //输出: [B, A]
    NSLog(@"%@", array);
    
    
    RACSubject *subC = [RACSubject subject];
    RACSubject *subD = [RACReplaySubject subject];
    
    NSMutableArray *array2 = [NSMutableArray array];
    
    //订阅信号
    [[subC concat:subD] subscribeNext:^(id  _Nullable x) {
        [array2 addObject:x];
    }];
    
    //发送信号
    [subD sendNext:@"D"];
    [subC sendNext:@"C"];
    [subC sendCompleted];
    
    //输出:
    NSLog(@"%@", array2);
}

#pragma then
- (void)setThenAction {
    RACSubject *subjectA = [RACReplaySubject subject];
    RACSubject *subjectB = [RACReplaySubject subject];
    
    //发送信号
    [subjectA sendNext:@"A"];
    [subjectA sendCompleted];
    [subjectB sendNext:@"B"];
    
    //订阅信号
    [[subjectA then:^RACSignal * _Nonnull{
        return subjectB;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma merge
- (void)setMergeAction {
    // 只要想无序的整合信号数据
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSubject *subjectC = [RACSubject subject];

    //合并信号
    RACSignal *single = [[subjectA merge:subjectB] merge:subjectC];
    
    //订阅信号
    [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //发出消息
    [subjectA sendNext:@"A"];
    [subjectC sendNext:@"C"];
    [subjectB sendNext:@"B"];
}

#pragma zipWith
- (void)setZipwithAction {
    // 只要想无序的整合信号数据
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    
    //合并信号
    RACSignal *single = [subjectA zipWith:subjectB];
    
    //订阅信号
    [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //发出消息
    [subjectA sendNext:@"A"];
    [subjectB sendNext:@"B"];
    
    /* 输出:
     (A, B)
     */
}


#pragma combineLatest
- (void)setCombineLatest {
    RACSignal *single = [_accountText.rac_textSignal combineLatestWith:_passwordText.rac_textSignal];
    
    [single subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *account, NSString *password) = x;
        
        _loginButton.enabled = account.length > 0 && password.length > 0;
    }];
}

- (IBAction)loginAction:(id)sender {
    NSLog(@"开始登陆");
}

#pragma reduce
- (void)setReduceAction {
    // reduce:把多个信号的值,聚合为一个值
    
    /*
    RACSignal *single = [RACSignal combineLatest:@[_accountText.rac_textSignal, _passwordText.rac_textSignal] reduce:^id (NSString *account, NSString *password){
        return @(account.length > 0 && password.length > 0);
    }];
    
    [single subscribeNext:^(id  _Nullable x) {
        _loginButton.enabled = [x boolValue];
    }];
    
    */
    
    //简化操作
    RAC(_loginButton, enabled) = [RACSignal combineLatest:@[_accountText.rac_textSignal, _passwordText.rac_textSignal] reduce:^id (NSString *account, NSString *password){
        return @(account.length > 0 && password.length > 0);
    }];
}


#pragma 过滤
- (void) setFilterAndMoreAction {
    
//    [self filterAction];
//    [self setIgnoreAction];
//    [self setdistinctUntilChanged];
//    [self setTakeAndTakeLast];
//    [self setswitchToLatest];
    [self setSkipAction];
}

//filter
- (void) filterAction{
    //filter
    //截取等于11位的字符
    [[_accountText.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        //类似手机号的输入, 只有等于11位的时候才返回true
        return value.length == 11;
    }]subscribeNext:^(NSString * _Nullable x) {
        //这里只会返回等于11位的字符
        NSLog(@"filter = %@", x);
    }];
}

//ignore
- (void)setIgnoreAction {
    ///ignore
    //这里的测试只有第一个字符位: m的时候能看到效果
    [[_accountText.rac_textSignal ignore:@"m"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore = %@", x);
    }];
    
    //ignoreValues: 忽略所有信号
    [[_passwordText.rac_textSignal ignoreValues] subscribeNext:^(id  _Nullable x) {
        NSLog(@"allIgnore = %@", x);
    }];
}

//distinctUntilChanged
- (void)setdistinctUntilChanged {
    //创建信号
    RACSubject *subject = [RACSubject subject];

    //订阅
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"distinctUntilChanged = %@", x);
    }];
    
    [subject sendNext:@12];
    [subject sendNext:@12];
    [subject sendNext:@23];
    
    /*输出结果:只会输出两次
     distinctUntilChanged = 12
     distinctUntilChanged = 23
     */
}

//take和takeLast
- (void)setTakeAndTakeLast {
    //take
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
//    [[subject1 takeLast:2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];

    [[subject1 takeUntil:subject2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [subject1 sendNext:@11];
    [subject1 sendNext:@12];
//    [subject1 sendCompleted];
    [subject1 sendNext:@13];
    [subject2 sendNext:@"21"];
    [subject2 sendNext:@"22"];
}

//switchToLatest
- (void)setswitchToLatest {
    //信号的信号
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];

    //获取信号中信号最近发出信号，订阅最近发出的信号
    [[subject1 switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //发送信号
    [subject1 sendNext:subject2];
    [subject2 sendNext:@"信号中信号"];
    
    //最终结果输出: "信号中信号"
}

//skip
- (void)setSkipAction {
    //创建信号
    RACSubject *subject = [RACSubject subject];
    
    //订阅信号
    //要求跳过2个信号
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendNext:@4];
    
    //因为上面跳过了两个信号, 所以这里只会输出: 3, 4
}


#pragma 定时器
- (void)setSchedulerAction {
    //RAC定时器, 每隔一段时间执行一次
    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"定时器");
    }];
    
    //delay: 延迟执行
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"delay"];
        return nil;
    }] delay:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    //timeout: 超时, 可以让一个信号在一定时间后自动报错
    RACSignal *single = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return nil;
    }] timeout:2 onScheduler:[RACScheduler currentScheduler]];
    
    [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        //2秒后自动调用
        NSLog(@"%@", error);
    }];
}

#pragma 重复操作
- (void)setResertAction {
    /*
    //retry
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (i == 5) {
            [subscriber sendNext:@12];
        } else {
            NSLog(@"发生错误");
            [subscriber sendError:nil];
        }
        i++;
        
        return nil;
    }] retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
     */
    
    /*输出结果
     2018-03-30 15:44:08.412860+0800 ReactiveObjc[4125:341376] 发生错误
     2018-03-30 15:44:08.461105+0800 ReactiveObjc[4125:341376] 发生错误
     2018-03-30 15:44:08.461897+0800 ReactiveObjc[4125:341376] 发生错误
     2018-03-30 15:44:08.462478+0800 ReactiveObjc[4125:341376] 发生错误
     2018-03-30 15:44:08.462913+0800 ReactiveObjc[4125:341376] 发生错误
     2018-03-30 15:44:08.463351+0800 ReactiveObjc[4125:341376] 12
     */
    /*
    //replay
    RACSignal *single = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@23];
        [subscriber sendNext:@34];
        
        return nil;
    }] replay];
    
    [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一次订阅-%@", x);
    }];
    
    [single subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二次订阅-%@", x);
    }];
    */
    /*输出结果:
     2018-03-30 15:51:20.115052+0800 ReactiveObjc[4269:361568] 第一次订阅-23
     2018-03-30 15:51:20.115195+0800 ReactiveObjc[4269:361568] 第一次订阅-34
     2018-03-30 15:51:20.115278+0800 ReactiveObjc[4269:361568] 第二次订阅-23
     2018-03-30 15:51:20.115352+0800 ReactiveObjc[4269:361568] 第二次订阅-34
     */
    
    
    RACSubject *subject = [RACSubject subject];
    
    [[subject throttle:0.001] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [subject sendNext:@10];
    [subject sendNext:@11];
    [subject sendNext:@12];
    [subject sendNext:@13];
    [subject sendNext:@14];
    [subject sendNext:@15];
    [subject sendNext:@16];
    [subject sendNext:@17];
    [subject sendNext:@18];

    
}
@end
