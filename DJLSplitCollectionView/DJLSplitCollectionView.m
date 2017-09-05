//
//  DJLSplitCollectionView.m
//  DJLSplitCollectionView
//
//  Created by gonghonglou on 2017/8/28.
//  Copyright © 2017年 Troy. All rights reserved.
//

#import "DJLSplitCollectionView.h"
#import "UIView+DJLScreenshot.h"
#import "DJLFolderCoverView.h"
#define COVERALPHA 0

@interface DJLSplitCollectionView () <CAAnimationDelegate>

@end

@implementation DJLSplitCollectionView

- (void)djl_openFolderAtIndexPath:(NSIndexPath *)indexPath
                  withContentView:(UIView *)subClassContentView
                        openBlock:(DJLFolderOpenBlock)openBlock
                       closeBlock:(DJLFolderCloseBlock)closeBlock
                  completionBlock:(DJLFolderCompletionBlock)completionBlock {
    self.subClassContentView = subClassContentView;
    self.openBlock = openBlock;
    self.completionBlock = completionBlock;
    self.closing = NO;
    
    // 位置和高度参数
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    CGFloat deltaY = self.contentOffset.y;
    
    CGPoint position = CGPointMake(cell.center.x, cell.frame.origin.y + cell.frame.size.height + 2);
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (position.y - deltaY > height) {
        self.offsetY = position.y - height - deltaY;
    } else if (position.y - deltaY < cell.frame.size.height) {
        self.offsetY = position.y - deltaY - cell.frame.size.height + 1;
    } else {
        self.offsetY = 0.0f;
    }
    
    // 重置contentoffset  这里要动画吗？
    self.oldContentOffset = self.contentOffset;
    self.contentOffset = CGPointMake(0, self.offsetY + deltaY);
    
    deltaY = self.contentOffset.y;
    
    UIImage *screenshot = [self djl_screenshotWithOffset:-deltaY];
    
    // 配置上下遮罩
    CGRect upperRect = CGRectMake(0, deltaY, width, position.y - deltaY);
    CGRect lowerRect = CGRectMake(0, position.y, width, height + deltaY - position.y);
    
    self.top = [self buttonForRect:upperRect
                            screen:screenshot
                          position:position
                               top:YES
                       transparent:NO];
    self.bottom = [self buttonForRect:lowerRect
                               screen:screenshot
                             position:position
                                  top:NO
                          transparent:NO];
    // 绑定关闭动作
    [self.top addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.top.cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    [self.bottom.cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    
    [self addSubview:subClassContentView];
    [self addSubview:self.top];
    [self addSubview:self.bottom];
    
    CGRect viewFrame = subClassContentView.frame;
    if (position.y - deltaY + viewFrame.size.height > height) {
        viewFrame.origin.y = height + deltaY - viewFrame.size.height;
    } else {
        viewFrame.origin.y = position.y;
    }
    subClassContentView.frame = viewFrame;
    
    // 配置打开动画
    CGFloat contentHeight = subClassContentView.frame.size.height;
    CFTimeInterval duration = 0.4f;
    CGPoint toTopPoint;
    CABasicAnimation *moveTop = [CABasicAnimation animationWithKeyPath:@"position"];
    moveTop.duration = duration;
    moveTop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.oldTopPoint = self.top.layer.position;
    CGFloat newTopY;
    if (self.top.frame.origin.y + self.top.frame.size.height > subClassContentView.frame.origin.y) {
        newTopY = self.oldTopPoint.y + subClassContentView.frame.origin.y - (self.top.frame.origin.y + self.top.frame.size.height);
    } else {
        newTopY = self.oldTopPoint.y;
    }
    toTopPoint = (CGPoint){self.oldTopPoint.x, newTopY};
    moveTop.fromValue = [NSValue valueWithCGPoint:self.oldTopPoint];
    moveTop.toValue = [NSValue valueWithCGPoint:toTopPoint];
    
    // add triangle mask
    self.triangleMaskPath = [UIBezierPath bezierPath];
    [self.triangleMaskPath moveToPoint:CGPointMake(13, 0)];
    [self.triangleMaskPath addLineToPoint:CGPointMake(0, 12)];
    [self.triangleMaskPath addLineToPoint:CGPointMake(26, 12)];
    [self.triangleMaskPath addLineToPoint:CGPointMake(13, 0)];
    [self.triangleMaskPath closePath];
    
    // 箭头着色
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.fillColor = subClassContentView.backgroundColor.CGColor;
    self.maskLayer.path = self.triangleMaskPath.CGPath;
    self.maskLayer.frame = CGRectMake(position.x - 13, self.top.frame.size.height - 12, 30, 30);
    [self.top.layer addSublayer:self.maskLayer];
    
    CGPoint toBottomPoint;
    CABasicAnimation *moveBottom = [CABasicAnimation animationWithKeyPath:@"position"];
    moveBottom.duration = duration;
    moveBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.oldBottomPoint = self.bottom.layer.position;
    CGFloat newBottomY;
    if (subClassContentView.frame.origin.y + subClassContentView.frame.size.height > height + deltaY) {
        newBottomY = self.oldBottomPoint.y + (subClassContentView.frame.origin.y + contentHeight) - deltaY - height;
    } else {
        newBottomY = self.oldBottomPoint.y + contentHeight;
    }
    toBottomPoint = (CGPoint){self.oldBottomPoint.x, newBottomY};
    moveBottom.fromValue = [NSValue valueWithCGPoint:self.oldBottomPoint];
    moveBottom.toValue = [NSValue valueWithCGPoint:toBottomPoint];
    
    // 打开动画
    [self.top.layer addAnimation:moveTop forKey:@"t1"];
    [self.bottom.layer addAnimation:moveBottom forKey:@"t2"];
    
    // 透明变半透明
    [UIView animateWithDuration:duration animations:^{
        self.top.cover.alpha = COVERALPHA;
        self.bottom.cover.alpha = COVERALPHA;
    }];
    
    if (openBlock) {
        openBlock(self.subClassContentView, duration, [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]);
    }
    
    [self.top.layer setPosition:toTopPoint];
    [self.bottom.layer setPosition:toBottomPoint];
}

- (void)djl_closeSplitView {
    [self performClose:nil];
}

-(void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.numberOfTapsRequired > 0) {
            [self performClose:gesture];
        }
    }
}

- (void)performClose:(id)sender {
    // 响应关闭手势回调
    [self.splitDelegate closeSplitView:sender];

    if (self.closing) {
        return;
    } else {
        self.closing = YES;
    }
    // 配置关闭动画
    CFTimeInterval duration = 0.4f;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *moveTop = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveTop setValue:@"closeTop" forKey:@"animationType"];
    [moveTop setDelegate:self];
    [moveTop setTimingFunction:timingFunction];
    moveTop.fromValue = [NSValue valueWithCGPoint:[[self.top.layer presentationLayer] position]];
    moveTop.toValue = [NSValue valueWithCGPoint:self.oldTopPoint];
    moveTop.duration = duration;
    
    CABasicAnimation *moveBottom = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveBottom setValue:@"closeBottom" forKey:@"animationType"];
    [moveBottom setDelegate:self];
    [moveBottom setTimingFunction:timingFunction];
    moveBottom.fromValue = [NSValue valueWithCGPoint:[[self.bottom.layer presentationLayer] position]];
    moveBottom.toValue = [NSValue valueWithCGPoint:self.oldBottomPoint];
    moveBottom.duration = duration;
    
    // 关闭动画
    [self.top.layer addAnimation:moveTop forKey:@"b1"];
    [self.bottom.layer addAnimation:moveBottom forKey:@"b2"];
    
    // 半透明变透明
    [UIView animateWithDuration:duration animations:^{
        self.contentOffset = self.oldContentOffset;
        self.top.cover.alpha = 0;
        self.bottom.cover.alpha = 0;
        self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    }];
    if (self.closeBlock) {
        self.closeBlock(self.subClassContentView, duration, timingFunction);
    }
    [self.top.layer setPosition:self.oldTopPoint];
    [self.bottom.layer setPosition:self.oldBottomPoint];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationType"] isEqualToString:@"closeTop"]) {
        [self.top removeFromSuperview];
        [self.bottom removeFromSuperview];
        [self.subClassContentView removeFromSuperview];
        [self.triangleMaskPath removeAllPoints];
        [self.maskLayer removeFromSuperlayer];
        
        self.top = nil;
        self.bottom = nil;
        self.subClassContentView = nil;
        self.triangleMaskPath = nil;
        self.maskLayer = nil;
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
}

- (DJLFolderCoverView *)buttonForRect:(CGRect)aRect
                               screen:(UIImage *)screen
                             position:(CGPoint)position
                                  top:(BOOL)isTop
                          transparent:(BOOL)isTransparent {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = aRect.size.width;
    CGFloat height = aRect.size.height;
    CGPoint origin = aRect.origin;
    CGFloat deltaY = self.contentOffset.y;
    
    CGRect scaledRect = CGRectMake(origin.x * scale, origin.y * scale - deltaY*scale, width * scale, height * scale);
    CGImageRef ref1 = CGImageCreateWithImageInRect([screen CGImage], scaledRect);
    
    DJLFolderCoverView *button;
    if (isTop) {
        button = [[DJLFolderCoverView alloc] initWithFrame:aRect offset:0];
    } else {
        button = [[DJLFolderCoverView alloc] initWithFrame:aRect offset:0];
    }
    
    [button djl_setIsTopView:isTop];
    
    button.position = position;
    button.layer.contentsScale = scale;
    button.layer.contents = isTransparent ? nil : (__bridge id)(ref1);
    button.layer.contentsGravity = kCAGravityCenter;
    CGImageRelease(ref1);
    
    return button;
}

@end
