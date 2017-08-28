//
//  UIView+DJLScreenshot.m
//  DJLSplitCollectionView
//
//  Created by gonghonglou on 2017/8/28.
//  Copyright © 2017年 Troy. All rights reserved.
//

#import "UIView+DJLScreenshot.h"

@implementation UIView (DJLScreenshot)

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (UIImage *)screenshotWithOffset:(CGFloat)deltaY {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, deltaY);
    [self.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end
