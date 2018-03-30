//
//  SubjectView.h
//  ReactiveObjc
//
//  Created by quanjunt on 2018/3/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

/*
@class SubjectView;
@protocol SubjectDelegate <NSObject>

@optional
- (void)viewWithTap:(SubjectView *)subView;

@end

 */


@interface SubjectView : UIView

//@property (nonatomic, weak) id<SubjectDelegate> delegate;

@property (nonatomic, strong) RACSubject *subject;

@end
