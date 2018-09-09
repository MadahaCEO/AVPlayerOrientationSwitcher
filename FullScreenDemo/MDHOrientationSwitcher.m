//
//  MDHOrientationSwitcher.m
//  FullScreenDemo
//
//  Created by Apple on 2018/9/9.
//  Copyright © 2018年 马大哈. All rights reserved.
//


#import "MDHOrientationSwitcher.h"


static CGFloat switchDuration = 0.25; /* 旋转时间 */


@interface MDHOrientationSwitcher ()



@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen; // 当前是否全屏状态

//@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

@end




@implementation MDHOrientationSwitcher


- (void)dealloc {
    
    [self removeDeviceOrientationObserver];
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        _duration = 0.25;
//        _fullScreenMode = ZFFullScreenModeLandscape;
//        _supportInterfaceOrientation = ZFInterfaceOrientationMaskAllButUpsideDown;
//        _allowOrentitaionRotation = YES;
//        _roateType = ZFRotateTypeNormal;
        
        [self addDeviceOrientationObserver];
    }
    return self;
}


- (void)updateRotateView:(UIView *)rotateView
           containerView:(UIView *)containerView {
    self.smallView = rotateView;
    self.smallContainerView = containerView;
}



- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
   
    if (self.fullScreenMode == MDHFullScreenModePortrait) {
        // 如果切换《竖-全屏》，不走下面代码。
        return;
    }
    
    _currentOrientation = orientation;
    UIView *superView   = nil;
    CGRect frame;
    
    // 适应ios8的方向旋转处理
    if ([self isNeedAdaptiveiOS8Rotation]) {
        
        
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        // 切换至横屏
        superView = self.fullScreenContainerView;
        
        if (!self.isFullScreen) {
            // 如果当前非全屏状态
            self.smallView.frame = [self.smallView convertRect:self.smallView.frame toView:superView];
        }
        // 当前切换至横全屏
        self.fullScreen = YES;
        self.testBar = YES;;
        self.statusBarHidden = YES;

        [superView addSubview:_smallView];
   
    } else {
        // 切换至竖屏
        superView =  self.smallContainerView;
        self.fullScreen = NO;
        self.testBar = NO;
        self.statusBarHidden = NO;
    }
    
    frame = [superView convertRect:superView.bounds toView:self.fullScreenContainerView];
    
    // 切换状态栏方向
    [UIApplication sharedApplication].statusBarOrientation = orientation;
    
    
    if (self.orientationWillSwitchBlock) self.orientationWillSwitchBlock(self, self.isFullScreen);
    
//    [self.smallView setNeedsLayout];
//    [self.smallView layoutIfNeeded];
    
    if (animated) {
        [UIView animateWithDuration:switchDuration animations:^{
            
            self.smallView.transform = [self getTransformRotationAngle:orientation];
            [UIView animateWithDuration:switchDuration animations:^{
                self.smallView.frame = frame;
                [self.smallView layoutIfNeeded];
            }];
        } completion:^(BOOL finished) {
            [superView addSubview:self.smallView];
            self.smallView.frame = superView.bounds;
            
            if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);
        }];
    } else {
        
        self.smallView.transform = [self getTransformRotationAngle:orientation];
        [superView addSubview:self.smallView];
        self.smallView.frame = superView.bounds;
        [self.smallView layoutIfNeeded];

        if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);

    }
    
    
    /*
    if (self.fullScreenMode == ZFFullScreenModePortrait) return;
    _currentOrientation = orientation;
    UIView *superview = nil;
    CGRect frame;
    if ([self isNeedAdaptiveiOS8Rotation]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            if (self.fullScreen) return;
            superview = self.fullScreenContainerView;
            self.fullScreen = YES;
        } else {
            if (!self.fullScreen) return;
            if (self.roateType == ZFRotateTypeCell) superview = [self.cell viewWithTag:self.playerViewTag];
            else superview = self.containerView;
            self.fullScreen = NO;
        }
        if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
        
        [superview addSubview:self.view];
        if (animated) {
            [UIView animateWithDuration:self.duration animations:^{
                self.view.frame = superview.bounds;
                [self.view layoutIfNeeded];
                [self interfaceOrientation:orientation];
            } completion:^(BOOL finished) {
                if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
            }];
        } else {
            self.view.frame = superview.bounds;
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0 animations:^{
                [self interfaceOrientation:orientation];
            }];
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        superview = self.fullScreenContainerView;
        if (!self.isFullScreen) { /// It's not set from the other side of the screen to this side
            self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        }
        self.fullScreen = YES;
        /// 先加到window上，效果更好一些
        [superview addSubview:_view];
    } else {
        if (self.roateType == ZFRotateTypeCell) superview = [self.cell viewWithTag:self.playerViewTag];
        else superview = self.containerView;
        self.fullScreen = NO;
    }
    frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    
    [UIApplication sharedApplication].statusBarOrientation = orientation;
    
    /// 处理8.0系统键盘
    if (SysVersion >= 8.0 && SysVersion < 9.0) {
        NSInteger windowCount = [[[UIApplication sharedApplication] windows] count];
        if(windowCount > 1) {
            UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:(windowCount-1)];
            if (UIInterfaceOrientationIsLandscape(orientation)) {
                keyboardWindow.bounds = CGRectMake(0, 0, MAX(ZFPlayerScreenHeight, ZFPlayerScreenWidth), MIN(ZFPlayerScreenHeight, ZFPlayerScreenWidth));
            } else {
                keyboardWindow.bounds = CGRectMake(0, 0, MIN(ZFPlayerScreenHeight, ZFPlayerScreenWidth), MAX(ZFPlayerScreenHeight, ZFPlayerScreenWidth));
            }
            keyboardWindow.transform = [self getTransformRotationAngle:orientation];
        }
    }
    
    if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            self.view.transform = [self getTransformRotationAngle:orientation];
            [UIView animateWithDuration:self.duration animations:^{
                self.view.frame = frame;
                [self.view layoutIfNeeded];
            }];
        } completion:^(BOOL finished) {
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        self.view.transform = [self getTransformRotationAngle:orientation];
        [superview addSubview:self.view];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
     */
}


- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
  
    /*
    if (self.fullScreenMode == ZFFullScreenModeLandscape) return;
    UIView *superview = nil;
    if (fullScreen) {
        superview = self.fullScreenContainerView;
        self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        [superview addSubview:self.view];
        self.fullScreen = YES;
    } else {
        if (self.roateType == ZFRotateTypeCell) {
            superview = [self.cell viewWithTag:self.playerViewTag];
        } else {
            superview = self.containerView;
        }
        self.fullScreen = NO;
    }
    if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
    CGRect frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            self.view.frame = frame;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        [superview addSubview:self.view];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
     */
}


- (void)addDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)handleDeviceOrientationChange {
    
    // || !self.allowOrentitaionRotation
    if (self.fullScreenMode == MDHFullScreenModePortrait) {
        
        return;
    }
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        _currentOrientation = UIInterfaceOrientationUnknown;
        return;
    }
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // Determine that if the current direction is the same as the direction you want to rotate, do nothing
    if (_currentOrientation == currentOrientation && ![self isNeedAdaptiveiOS8Rotation]) return;
    
    switch (_currentOrientation) {
        case UIInterfaceOrientationPortrait: {
            if ([self isSupportedPortrait]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationPortrait animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            if ([self isSupportedLandscapeLeft]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            if ([self isSupportedLandscapeRight]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
            }
        }
            break;
        default: break;
    }
}


/// 是否支持 Portrait
- (BOOL)isSupportedPortrait {
//    return self.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait;
    return YES;

}

/// 是否支持 LandscapeLeft
- (BOOL)isSupportedLandscapeLeft {
//    return self.supportInterfaceOrientation & ZFInterfaceOrientationMaskLandscapeLeft;

    return YES;
}

/// 是否支持 LandscapeRight
- (BOOL)isSupportedLandscapeRight {
//    return self.supportInterfaceOrientation & ZFInterfaceOrientationMaskLandscapeRight;
    return YES;

}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/// Gets the rotation Angle of the transformation.
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (BOOL)isNeedAdaptiveiOS8Rotation {
    NSArray<NSString *> *versionStrArr = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    int firstVer = [[versionStrArr objectAtIndex:0] intValue];
    int secondVer = [[versionStrArr objectAtIndex:1] intValue];
    if (firstVer == 8) {
        if (secondVer >= 1 && secondVer <= 3) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - getter

- (BOOL)shouldAutorotate {
    return [self isNeedAdaptiveiOS8Rotation];
}


#pragma mark - setter

- (UIView *)fullScreenContainerView {
    if (!_fullScreenContainerView) {
        _fullScreenContainerView = [UIApplication sharedApplication].keyWindow;
    }
    return _fullScreenContainerView;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    // 更新状态栏
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    UIViewController *topViewController = [window rootViewController];
    
    [[self currentViewController] setNeedsStatusBarAppearanceUpdate];

//    [[UIWindow zf_currentViewController] setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    
    [[self currentViewController] setNeedsStatusBarAppearanceUpdate];

//    [[UIWindow zf_currentViewController] setNeedsStatusBarAppearanceUpdate];
}


- (UIViewController*)currentViewController; {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end
