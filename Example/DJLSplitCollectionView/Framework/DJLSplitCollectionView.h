//
//  DJLSplitCollectionView.h
//  DJLSplitCollectionView
//
//  Created by gonghonglou on 2017/8/28.
//  Copyright © 2017年 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJLFolderCoverView;

typedef void (^DJLFolderCompletionBlock)(void);
typedef void (^DJLFolderCloseBlock)(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);
typedef void (^DJLFolderOpenBlock)(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);

@interface DJLSplitCollectionView : UICollectionView

@property (nonatomic, strong) UIBezierPath *triangleMaskPath;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIView *subClassContentView;

@property (nonatomic, assign) CGPoint oldTopPoint, oldBottomPoint, oldTrianglePoint;
@property (nonatomic, assign) CGPoint oldContentOffset;
@property (nonatomic, assign) BOOL closing;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, copy) DJLFolderOpenBlock openBlock;
@property (nonatomic, copy) DJLFolderCloseBlock closeBlock;
@property (nonatomic, copy) DJLFolderCompletionBlock completionBlock;
@property (nonatomic, strong) DJLFolderCoverView *top, *bottom;

- (void)openFolderAtIndexPath:(NSIndexPath *)indexPath
              withContentView:(UIView *)subClassContentView
                    openBlock:(DJLFolderOpenBlock)openBlock
                   closeBlock:(DJLFolderCloseBlock)closeBlock
              completionBlock:(DJLFolderCompletionBlock)completionBlock;

- (void)closeSplitView;

@end
