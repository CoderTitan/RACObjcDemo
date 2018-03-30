//
//  SequenceViewController.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/3/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "SequenceViewController.h"
#import <ReactiveObjC.h>

@interface SequenceViewController ()

@end

@implementation SequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RACSequence和RACTuple";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //RACTuple介绍
//    [self setDataArr];
    
    //RACTupleUnpackingTrampoline介绍
//    [self setUnpackingTrampoline];
    
    //RACSequence介绍
//    [self setSequence];
    [self setSequenceAction];
}

#pragma RACTuple介绍
- (void)setDataArr{
    RACTuple *tuple = RACTuplePack(@1, @2, @"32", @23, @"jun", @2.3, @4.56, @100);
    NSLog(@"%lu", (unsigned long)tuple.count);
//    NSLog(@"%@--%@--%@", tuple.first, tuple.last, tuple[6]);
    
    NSArray *arr = [NSArray arrayWithObjects:@1, NSNull.null, @2, @"jun", nil];
    RACTuple *tuple1 = [RACTuple tupleWithObjectsFromArray:arr];
    RACTuple *tuple2 = [RACTuple tupleWithObjectsFromArray:arr convertNullsToNils:YES];
    NSLog(@"%@", tuple1.second);
    NSLog(@"%@", tuple2.second);
    
    
    //宏的使用
    RACTuple *tuple4 = RACTuplePack(@"tian", @23);
    RACTupleUnpack(NSString *str1, NSNumber *num1) = tuple4;
    NSLog(@"%@--%d", str1, num1.intValue);
    ///输出: tian--23
    
    RACTuple *tuple3 = [RACTuple tupleWithObjects:@"jun", @3.4, nil];
    RACTupleUnpack(NSString *str2, NSNumber *num2) = tuple3;
    NSLog(@"%@--%.2f", str2, num2.floatValue);
    ///输出: jun--3.40

    /// 上面的两种做法等同于下面这种做法
    NSString *str3 = tuple3[0];
    NSNumber *num3 = tuple3[1];
    NSLog(@"%@--%.2f", str3, num3.floatValue);
    ///输出: jun--3.40
}

#pragma RACTupleUnpackingTrampoline介绍
- (void)setUnpackingTrampoline {
    RACTupleUnpackingTrampoline *line = [RACTupleUnpackingTrampoline trampoline];
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithPointer:&str1], [NSValue valueWithPointer:&str2], [NSValue valueWithPointer:&str3], nil];
    
    NSLog(@"处理之前: str1 = %@, str2 = %@, str3 = %@", str1, str2, str3);
    [line setObject:RACTuplePack(@"tian", @23, @3.45) forKeyedSubscript:arr];
    NSLog(@"处理之后: str1 = %@, str2 = %@, str3 = %@", str1, str2, str3);
    
    /*输出结果:
     2018-03-20 15:43:28.785571+0800 ReactiveObjc[7074:641560] 处理之前: str1 = (null), str2 = (null), str3 = (null)
     2018-03-20 15:43:28.786078+0800 ReactiveObjc[7074:641560] 处理之后: str1 = tian, str2 = 23, str3 = 3.45
     */
}

#pragma RACSequence介绍
- (void)setSequence {
    RACSequence *sequence = [RACSequence sequenceWithHeadBlock:^id _Nullable{
        return @12;
    } tailBlock:^RACSequence * _Nonnull{
        return @[@23, @"jun"].rac_sequence;
    }];
    NSLog(@"sequence.head = %@ , sequence.tail =  %@", sequence.head, sequence.tail);
    NSLog(@"sequence.tail.array = %@", sequence.tail.array);
    
    NSArray *arr = @[@1, @3, @4];
    RACSequence *sequence1 = [arr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"sequence");
        return @10;
    }];
    
    RACSequence *lazySequence = [arr.rac_sequence.lazySequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"lazySequence");
        return @20;
    }];
    
    RACSequence *eagerSequence = [arr.rac_sequence.eagerSequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"eagerSequence");
        return @30;
    }];
    
    
    [sequence1 array];
    [lazySequence array];
    [eagerSequence array];
}

- (void)setSequenceAction {
    NSArray *array = @[@5, @3, @9, @4];
    RACSequence *sequence = [array rac_sequence];
    id leftData = [sequence foldLeftWithStart:@"-" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return [accumulator stringByAppendingString:[value stringValue]];
    }];
    
    id rightData = [sequence foldRightWithStart:@":" reduce:^id _Nullable(id  _Nullable first, RACSequence * _Nonnull rest) {
        return [NSString stringWithFormat:@"%@-%@", rest.head, first];
    }];
    
    NSLog(@"leftData = %@, rightData = %@", leftData, rightData);
    
    //输出: leftData = -5394, rightData = :-4-9-3-5
    
    id anyData = [sequence objectPassingTest:^BOOL(id  _Nullable value) {
        NSLog(@"%@", value);
        return true;
    }];
    NSLog(@"%@", anyData);
    
    
    //all
    BOOL anyBool = [sequence any:^BOOL(id  _Nullable value) {
        return true;
    }];
    BOOL allBool = [sequence all:^BOOL(id  _Nullable value) {
        return true;
    }];
    
    NSLog(@"any = %d, all = %d", anyBool, allBool);
    //输出: any = 1, all = 1
    
    
}
@end
