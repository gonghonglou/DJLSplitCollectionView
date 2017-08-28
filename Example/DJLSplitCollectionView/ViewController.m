//
//  ViewController.m
//  DJLSplitCollectionView
//
//  Created by gonghonglou on 2017/8/28.
//  Copyright © 2017年 Troy. All rights reserved.
//

#import "ViewController.h"
#import "DJLSplitCollectionView.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) DJLSplitCollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionView *childCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UICollectionViewFlowLayout *mainFlowLayout = [UICollectionViewFlowLayout new];
    mainFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.mainCollectionView = [[DJLSplitCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:mainFlowLayout];
    [self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollectionView];
    
    UICollectionViewFlowLayout *childFlowLayout = [UICollectionViewFlowLayout new];
    childFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.childCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:childFlowLayout];
    [self.childCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.childCollectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    self.childCollectionView.frame = CGRectMake(0, 0, self.mainCollectionView.frame.size.width, 80);

    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.childCollectionView.delegate = self;
    self.childCollectionView.dataSource = self;
}


#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.mainCollectionView) {
        return 100;
    } else {
        return 10;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.layer.cornerRadius = 4.0;
    if (collectionView == self.mainCollectionView) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/3, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.mainCollectionView) {
        return UIEdgeInsetsMake(50, 10, 50, 10);
    } else {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.childCollectionView) {
        NSLog(@"didSelectItemAtIndexPath:%ld", (long)indexPath.row);
        return;
    }
    
    [self.mainCollectionView openFolderAtIndexPath:indexPath
                                   withContentView:self.childCollectionView
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
                                             
                                             self.mainCollectionView.scrollEnabled = NO;
                                             NSLog(@"open childCollectionView");
                                         } closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
                                             
                                             self.mainCollectionView.scrollEnabled = YES;
                                             NSLog(@"close childCollectionView");
                                         } completionBlock:^{
                                             
                                             self.mainCollectionView.scrollEnabled = YES;
                                             NSLog(@"completion childCollectionView");
                                         }];
}



@end
