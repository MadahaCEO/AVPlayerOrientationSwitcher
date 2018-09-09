//
//  MDHOrientationSwitcher.h
//  FullScreenDemo
//
//  Created by Apple on 2018/9/9.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/// 全屏模式
typedef NS_ENUM(NSUInteger, MDHFullScreenMode) {
    MDHFullScreenModeLandscape,  // 横-全屏
    MDHFullScreenModePortrait    // 竖-全屏
};


@class MDHOrientationSwitcher;
typedef void(^OrientationWillSwitchBlock)(MDHOrientationSwitcher *switcher, BOOL isFullScreen);
typedef void(^OrientationDidSwitchBlock)(MDHOrientationSwitcher *switcher, BOOL isFullScreen);


@interface MDHOrientationSwitcher : NSObject


@property (nonatomic) MDHFullScreenMode fullScreenMode; /* MDHFullScreenMode */

@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation; /* 当前屏幕方向 */

@property (nonatomic, strong) UIView *fullScreenContainerView; /* 全屏状态下承载smallView的容器View 《keyWindow》*/
@property (nonatomic, weak) UIView *smallContainerView; /* 未处于全屏状态的smallView的容器View */

@property (nonatomic, weak) UIView *smallView; /* 小图 */

@property (nonatomic, readonly, getter=isFullScreen) BOOL fullScreen; /* 当前是否处于全屏状态 */

@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

@property (nonatomic, assign) BOOL testBar;


/// Whether automatic screen rotation is supported.
/// iOS8.1~iOS8.3 the value is YES, other iOS version the value is NO.
/// This property is used for the return value of UIViewController `shouldAutorotate` method.
@property (nonatomic, readonly) BOOL shouldAutorotate;


/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) OrientationWillSwitchBlock orientationWillSwitchBlock;

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) OrientationDidSwitchBlock orientationDidSwitchBlock;


/*
 rotateView: 需要旋转的view
 containerView： 需要旋转的view 的容器View
 */
- (void)updateRotateView:(UIView *)rotateView containerView:(UIView *)containerView;



/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModeLandscape.
- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end
