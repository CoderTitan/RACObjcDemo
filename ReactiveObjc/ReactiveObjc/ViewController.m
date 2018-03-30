//
//  ViewController.m
//  ReactiveObjc
//
//  Created by quanjunt on 2018/2/7.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "SingleViewController.h"
#import "SubjectViewController.h"
#import "SequenceViewController.h"
#import "RACHighViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation ViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithObjects:
                    @"RACSingle",
                    @"RACSubject",
                    @"RACSequence",
                    @"RAC的高级用法",
                    nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列表";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *vcs = [NSArray arrayWithObjects:
                    [[SingleViewController alloc]init],
                    [[SubjectViewController alloc]init],
                    [[SequenceViewController alloc]init],
                    [[RACHighViewController alloc]init],
                    nil];
    [self.navigationController pushViewController:vcs[indexPath.row] animated:true];
}

@end
