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


@property (nonatomic, assign, readonly) MDHFullScreenMode fullScreenMode; /* MDHFullScreenMode */

@property (nonatomic, assign, readonly) UIInterfaceOrientation currentOrientation; /* 当前屏幕方向 */

@property (nonatomic, weak) UIView *playerContainerView; /* 未处于全屏状态的smallView的容器View */

@property (nonatomic, strong) UIView *fullScreenContainerView; /* 全屏状态下承载smallView的容器View 《keyWindow》*/

@property (nonatomic, readonly, getter=isFullScreen) BOOL fullScreen; /* 当前是否处于全屏状态 */

@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden; /* statusBar是否隐藏 */


/// Whether automatic screen rotation is supported.
/// iOS8.1~iOS8.3 the value is YES, other iOS version the value is NO.
/// This property is used for the return value of UIViewController `shouldAutorotate` method.
@property (nonatomic, readonly) BOOL shouldAutorotate;



@property (nonatomic, copy, nullable) OrientationWillSwitchBlock orientationWillSwitchBlock;
@property (nonatomic, copy, nullable) OrientationDidSwitchBlock orientationDidSwitchBlock;


- (instancetype)initWithRotateView:(UIView *)rotateView
                     containerView:(UIView *)containerView
                   FullScreenModel:(MDHFullScreenMode)mode;


/*
 进入 or 退出《横-全屏》
 */
- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/*
 进入 or 退出《竖-全屏》
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end
