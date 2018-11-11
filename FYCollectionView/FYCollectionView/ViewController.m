//
//  ViewController.m
//  FYCollectionView
//
//  Created by feish on 2018/10/29.
//  Copyright © 2018年 feish. All rights reserved.
//

#import "ViewController.h"
#import "FYWaterflowView.h"
#import "FYWaterflowViewCell.h"

@interface ViewController ()<FYWaterFlowViewDelegate,FYWaterFlowViewDataSource>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化瀑布流
    FYWaterflowView *waterflowView = [[FYWaterflowView alloc]init];
    waterflowView.delegate = self;
    waterflowView.dataSource = self;
    waterflowView.frame = self.view.bounds;
    [self.view addSubview:waterflowView];
 
}

#pragma mark - dataSource

- (NSUInteger)numberOfcolsInWaterFlowView:(FYWaterflowView *)waterFlowView {
    return 3;
}

- (NSUInteger)numberOfCellsInWaterflowView:(FYWaterflowView *)waterFlowView {
    return 100;
}

- (FYWaterflowViewCell *)waterFlowView:(FYWaterflowView *)waterFlowView cellAtIndex:(NSUInteger)index {
    NSString * cellid = @"cellid";
    FYWaterflowViewCell * cell = [waterFlowView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[FYWaterflowViewCell alloc]init];
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.identifier = cellid;
        cell.titleLabel.text = @"123";
        cell.photoView.image = [UIImage imageNamed:@"pic"];
    }
    return cell;
}
#pragma mark - delegate
- (CGFloat)waterflowView:(FYWaterflowView *)waterflowview heightAtIndex:(NSUInteger)index {
    switch (index % 3) {
        case 0:
            return 70;
            break;
        case 1:
            return 100;
            break;
        case 2:
            return 86;
            break;
            
        default:
            return 100;
            break;
    }
}

- (CGFloat)waterflowView:(FYWaterflowView *)waterflowview marginWithType:(FYWaterflowViewMarginType)type {
    switch (type) {
        case FYWaterflowViewMarginTypeTop:
        case FYWaterflowViewMarginTypeLeft:
        case FYWaterflowViewMarginTypeRight:
        case FYWaterflowViewMarginTypeBottom:
            return 5;
            
        default:
            return 5;
    }
}
//点击事件处理
- (void)waterflowView:(FYWaterflowView *)waterflowview didSelectCellAtIndex:(NSUInteger)index {
    NSLog(@"%lu",(unsigned long)index);
}


@end
