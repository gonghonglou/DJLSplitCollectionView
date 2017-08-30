# DJLSplitCollectionView

A lightweight extension control for UICollectionView

[![Packagist](https://img.shields.io/badge/license-MIT-green.svg)](https://raw.githubusercontent.com/gonghonglou/DJLSplitCollectionView/master/LICENSE)
[![CocoaPods](https://img.shields.io/badge/pod-v1.3.1-green.svg)]()
[![Travis](https://img.shields.io/badge/platform-ios-green.svg)](https://www.apple.com/nl/ios)
[![Travis](https://img.shields.io/badge/build-passing-green.svg)](https://travis-ci.org/gonghonglou/DJLSplitCollectionView)

# Demo Project
See `Example/DJLSplitCollectionView.xcodeproj`

![SplitView](http://image.gonghonglou.com/github/SplitView.gif)

# Usage
## Initialize UICollectionVIew object and split view
```
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
```

## Call method in interface `didSelectItemAtIndexPath:` of UICollectionVIew
```
// open split view
[self.mainCollectionView djl_openFolderAtIndexPath:indexPath
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
    
// close split view
//    [self.mainCollectionView djl_closeSplitView];
```

# Installation
## CocoaPods
1. Add pod 'DJLSplitCollectionView' to your Podfile.
2. Run pod install or pod update.
3. Import <DJLSplitCollectionView/DJLSplitCollectionView.h>.

## Manually
1. Download all the files in the DJLSplitCollectionView subdirectory.
2. Add the source files to your Xcode project.
3. Import DJLSplitCollectionView.h.

# License
DJLSplitCollectionView is provided under the MIT license. See LICENSE file for details.


