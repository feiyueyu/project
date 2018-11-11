//
//  FYWaterFlowView.h
//  FYCollectionView
//
//  Created by feish on 2018/10/29.
//  Copyright © 2018年 feish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define FYWaterflowViewDefaultCellH 60 //默认单元格宽度
#define FYWaterflowViewDefaultCols  3 //默认列数
#define FYWaterflowViewDefaultMargin 10 //默认间距
/**
 * 间距类型
 */
typedef NS_ENUM(NSUInteger, FYWaterflowViewMarginType) {
    FYWaterflowViewMarginTypeTop,
    FYWaterflowViewMarginTypeBottom,
    FYWaterflowViewMarginTypeLeft,
    FYWaterflowViewMarginTypeRight,
    FYWaterflowViewMarginTypeCol,
    FYWaterflowViewMarginTypeRow
};
@class FYWaterflowView,FYWaterflowViewCell;


/**
 * 代理方法
 */
@protocol FYWaterFlowViewDelegate <UIScrollViewDelegate>

@optional
/**
 * index位置的高度
 */
- (CGFloat)waterflowView:(FYWaterflowView*)waterflowview heightAtIndex:(NSUInteger)index;
/**
 * 选中了index位置的单元格
 */
- (void)waterflowView:(FYWaterflowView*)waterflowview didSelectCellAtIndex:(NSUInteger)index;
/**
 * 返回对应的间距
 */
- (CGFloat)waterflowView:(FYWaterflowView*)waterflowview marginWithType:(FYWaterflowViewMarginType)type;

@end
/**
 * 数据源方法
 */
@protocol  FYWaterFlowViewDataSource<NSObject>

@required
/**
 * index位置的单元格控件
 */
- (FYWaterflowViewCell*)waterFlowView:(FYWaterflowView*)waterFlowView cellAtIndex:(NSUInteger)index;
/**
 * 单元格数量
 */
- (NSUInteger)numberOfCellsInWaterflowView:(FYWaterflowView*)waterFlowView;

@optional
/**
 * 一共多少列
 */
- (NSUInteger)numberOfcolsInWaterFlowView:(FYWaterflowView*)waterFlowView;

@end


@interface FYWaterflowView : UIScrollView
/**
 * 刷新数据
 */
- (void)reloadData;
/**
 * 数据源
 */
@property (nonatomic, weak) id<FYWaterFlowViewDataSource>dataSource;
/**
 * 代理
 */
@property (nonatomic, weak) id<FYWaterFlowViewDelegate>delegate;
/**
 * 根据标识在缓存池中找cell
 */
- (FYWaterflowViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
