//
//  FYWaterFlowViewCell.h
//  FYCollectionView
//
//  Created by feish on 2018/10/29.
//  Copyright © 2018年 feish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYWaterflowViewCell : UIView
/**
 * 标识符
 */
@property (nonatomic, strong) NSString *identifier;
/**
 * 默认cell底部的title
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 默认显示图片的控件
 */
@property (nonatomic, strong) UIImageView *photoView;

@end

NS_ASSUME_NONNULL_END
