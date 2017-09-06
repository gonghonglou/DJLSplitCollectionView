//
//  DJLFolderCoverView.h
//  DJLSplitCollectionView
//
//  Created by gonghonglou on 2017/8/28.
//  Copyright © 2017年 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJLFolderCoverView : UIControl

@property (nonatomic, strong) UIView *cover;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) CALayer *highlight;


- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)delta;
- (void)djl_setIsTopView:(BOOL)isTop;

@end
