//
//  FYWaterFlowView.m
//  FYCollectionView
//
//  Created by feish on 2018/10/29.
//  Copyright © 2018年 feish. All rights reserved.
//

#import "FYWaterflowView.h"
#import "FYWaterflowViewCell.h"

@interface FYWaterflowView()
/**
 * 存放所有的cell的frame
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 * 存放所有展示在瀑布流上的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 * 缓存池
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;

@end


@implementation FYWaterflowView

- (NSMutableDictionary *)displayingCells {
    if (_displayingCells == nil) {
        _displayingCells = [[NSMutableDictionary alloc]init];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells {
    if (_reusableCells == nil) {
        _reusableCells = [[NSMutableSet alloc]init];
    }
    return _reusableCells;
}

- (NSMutableArray *)cellFrames {
    if (_cellFrames == nil) {
        _cellFrames = [[NSMutableArray alloc]init];
    }
    return _cellFrames;
}

@synthesize delegate = _delegate;

//滚动时会调用
- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger numberOfcells = self.cellFrames.count;
    for (int i = 0; i < numberOfcells; i++) {
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        FYWaterflowViewCell *cell = self.displayingCells[@(i)];
        if ([self isVisible:cellFrame]) {
            if (cell == nil) {
                cell = [self.dataSource waterFlowView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                self.displayingCells[@(i)] = cell;
            }
        } else {
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                [self.reusableCells addObject:cell];
            }
        }
    }
}

/**
 * 判断cell是否正在显示
 */
- (BOOL)isVisible:(CGRect)cellFrame {
   return  (CGRectGetMaxY(cellFrame) > self.contentOffset.y) && (CGRectGetMinY(cellFrame) < self.contentOffset.y + self.frame.size.height);
}
//根据identifier在缓存池中查找cell
- (FYWaterflowViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    __block FYWaterflowViewCell *reusablecell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(FYWaterflowViewCell* cell, BOOL * _Nonnull stop) {
        
        if ([cell.identifier isEqualToString:identifier]) {
            reusablecell = cell;
            [self.reusableCells removeObject:cell];
            *stop = YES;
        }
        
    }];
    return reusablecell;
    
}

#pragma mark - 公共接口
/**
 * 刷新数据，计算每一个cell的frame
 */
- (void)reloadData {
    //cell总数
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflowView:self];
    //总列数
    NSUInteger numberOfColumns = [self numberOfColumns];
    //间距
    CGFloat topMargin = [self marginWithType:FYWaterflowViewMarginTypeTop];
    CGFloat bottomMargin = [self marginWithType:FYWaterflowViewMarginTypeBottom];
    CGFloat leftMargin = [self marginWithType:FYWaterflowViewMarginTypeLeft];
    CGFloat rightMargin = [self marginWithType:FYWaterflowViewMarginTypeRight];
    CGFloat rowMargin = [self marginWithType:FYWaterflowViewMarginTypeRow];
    CGFloat columnMargin = [self marginWithType:FYWaterflowViewMarginTypeCol];
    CGFloat cellW = (self.frame.size.width - leftMargin - rightMargin - (numberOfColumns - 1) * columnMargin) / numberOfColumns;
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) {
        maxYOfColumns[i] = 0.0;
    }
    //计算cell的宽度
    for (int i = 0; i < numberOfCells; i++) {
        CGFloat cellH = 0;
        if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
            cellH = [self.delegate waterflowView:self heightAtIndex:i];
        } else {
            cellH = FYWaterflowViewDefaultCellH;
        }
        
        NSUInteger cellColumns = 0;
        //存放所有列的最大Y值
        CGFloat maxYOfCellColumn = maxYOfColumns[cellColumns];
        for (int j = 1; j < numberOfColumns; j++) {
            if (maxYOfColumns[j] < maxYOfCellColumn) {
                cellColumns = j;
                maxYOfCellColumn = maxYOfColumns[j];
                
            }
        }
        CGFloat cellX = leftMargin + cellColumns * (cellW + columnMargin);
        CGFloat cellY = 0.0;
        if (maxYOfCellColumn == 0.0) {
            cellY = topMargin;
        } else {
            cellY = maxYOfCellColumn + rowMargin;
        }
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        //将cell的frame存放在cellframe中
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        maxYOfColumns[cellColumns] = CGRectGetMaxY(cellFrame);
        
        CGFloat contentH = maxYOfColumns[0];
        for (int j = 1; j < numberOfColumns; j++) {
            if (maxYOfColumns[j] > contentH) {
                contentH = maxYOfColumns[j];
                
            }
        }
        self.contentSize = CGSizeMake(0, contentH + bottomMargin);
    }
}

- (CGFloat)marginWithType:(FYWaterflowViewMarginType)type {
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginWithType:)]) {
        return [self.delegate waterflowView:self marginWithType:type];
    } else {
        return FYWaterflowViewDefaultMargin;
    }
}

- (NSUInteger)numberOfColumns {
    if ([self.dataSource respondsToSelector:@selector(numberOfcolsInWaterFlowView:)]) {
       return  [self.dataSource numberOfcolsInWaterFlowView:self];
    }
    return FYWaterflowViewDefaultCols;
}
//处理点击事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectCellAtIndex:)]) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, FYWaterflowViewCell *cell, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
        
        if (selectIndex) {
            [self.delegate waterflowView:self didSelectCellAtIndex:selectIndex.unsignedIntegerValue];
        }
    }];
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

@end
