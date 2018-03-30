//
//  SubjectView.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/3/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "SubjectView.h"

@implementation SubjectView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /*
    if ([_delegate respondsToSelector:@selector(viewWithTap:)]) {
        [_delegate viewWithTap:self];
    }
     */
    
    [_subject sendNext:self];
}


@end
