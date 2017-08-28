//
//  UIView+DJLScreenshot.h
//  DJLSplitCollectionView
//
//  Created by gonghonglou on 2017/8/28.
//  Copyright © 2017年 Troy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DJLScreenshot)

- (UIImage *)screenshot;
- (UIImage *)screenshotWithOffset:(CGFloat)deltaY;

@end
