//
//  FYWaterFlowViewCell.m
//  FYCollectionView
//
//  Created by feish on 2018/10/29.
//  Copyright © 2018年 feish. All rights reserved.
//

#import "FYWaterflowViewCell.h"
#define TitleLableH 22

@implementation FYWaterflowViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self addSubview:self.photoView];
//        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_photoView) {
        CGFloat photoViewX = 0;
        CGFloat photoViewY = 0;
        CGFloat photoViewW = self.frame.size.width;
        CGFloat photoViewH = self.frame.size.height - TitleLableH;
        _photoView.frame = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
    }
    
    if (_titleLabel) {
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = CGRectGetMaxY(self.photoView.frame);
        CGFloat titleLabelW = self.frame.size.width;
        CGFloat titleLabelH = TitleLableH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}
//外界调用再初始化
- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
        _photoView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_photoView];
    }
    return _photoView;
}
//外界调用再初始化
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

