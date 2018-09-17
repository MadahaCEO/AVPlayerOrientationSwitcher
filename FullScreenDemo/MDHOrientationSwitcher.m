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

@property (nonatomic, weak) UIView *playerView; /* 小图 */
@property (nonatomic, assign) MDHFullScreenMode fullScreenMode; /* MDHFullScreenMode */

@end




@implementation MDHOrientationSwitcher


- (void)dealloc {
    
    [self removeDeviceOrientationObserver];
}

- (instancetype)initWithFullScreenModel:(MDHFullScreenMode)model {
    self = [super init];
    if (self) {
        
        self.fullScreenMode =  model;
        
        [self addDeviceOrientationObserver];
    }
    return self;
}

- (MDHFullScreenMode)fullScreenMode {
    return _fullScreenMode;
}



// 获取视频view and 承载视频的view
- (void)updateRotateView:(UIView *)rotateView
           containerView:(UIView *)containerView {
   
    self.playerView = rotateView;
    self.playerContainerView = containerView;
}


// 横全屏
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
        /*
         当前是否处于横屏
         */
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            if (self.fullScreen) return;
            superView = self.fullScreenContainerView;
            self.fullScreen = YES;
            self.statusBarHidden = YES;

        } else {
            if (!self.fullScreen) return;
            superView = self.playerContainerView;
            self.fullScreen = NO;
            self.statusBarHidden = NO;

        }
        
        // 即将旋转回调
        if (self.orientationWillSwitchBlock) self.orientationWillSwitchBlock(self, self.isFullScreen);

        /*
         横-全屏：加载到window上
         竖-全屏：加载到containerView上
         */
        [superView addSubview:self.playerView];
        if (animated) {
            [UIView animateWithDuration:switchDuration animations:^{
                self.playerView.frame = superView.bounds;
                [self.playerView layoutIfNeeded];
                [self interfaceOrientation:orientation];
            } completion:^(BOOL finished) {
                if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);
            }];
        } else {
            self.playerView.frame = superView.bounds;
            [self.playerView layoutIfNeeded];
            [UIView animateWithDuration:0 animations:^{
                [self interfaceOrientation:orientation];
            }];
            if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);
        }
        
        return;
    }
    
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        // 切换至横屏
        superView = self.fullScreenContainerView;
        
        if (!self.isFullScreen) {
            // 如果当前非全屏状态
            self.playerView.frame = [self.playerView convertRect:self.playerView.frame toView:superView];
        }
        // 当前切换至横全屏
        self.fullScreen = YES;

        self.statusBarHidden = YES;

        [superView addSubview:_playerView];
   
    } else {
        // 切换至竖屏
        superView =  self.playerContainerView;
        self.fullScreen = NO;

        self.statusBarHidden = NO;
    }
    
    frame = [superView convertRect:superView.bounds toView:self.fullScreenContainerView];
    
    // 切换状态栏方向
    [UIApplication sharedApplication].statusBarOrientation = orientation;
    
    
    CGFloat version = [[UIDevice currentDevice] systemVersion].floatValue;

    /// 处理8.0系统键盘
    if (version >= 8.0 && version < 9.0) {
        NSInteger windowCount = [[[UIApplication sharedApplication] windows] count];
        if(windowCount > 1) {
            
            UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:(windowCount-1)];
            if (UIInterfaceOrientationIsLandscape(orientation)) {
                keyboardWindow.bounds = CGRectMake(0, 0, MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width), MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width));
            } else {
                keyboardWindow.bounds = CGRectMake(0, 0, MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width), MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width));
            }
            keyboardWindow.transform = [self getTransformRotationAngle:orientation];
        }
    }
    
    if (self.orientationWillSwitchBlock) self.orientationWillSwitchBlock(self, self.isFullScreen);
    

    
    if (animated) {
        [UIView animateWithDuration:switchDuration animations:^{
            
            self.playerView.transform = [self getTransformRotationAngle:orientation];
            [UIView animateWithDuration:switchDuration animations:^{
                self.playerView.frame = frame;
                [self.playerView layoutIfNeeded];
            }];
        } completion:^(BOOL finished) {
            [superView addSubview:self.playerView];
            self.playerView.frame = superView.bounds;
            
            if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);
        }];
    } else {
        
        self.playerView.transform = [self getTransformRotationAngle:orientation];
        [superView addSubview:self.playerView];
        self.playerView.frame = superView.bounds;
        [self.playerView layoutIfNeeded];

        if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);

    }
}


// 竖全屏
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    
    if (self.fullScreenMode == MDHFullScreenModeLandscape) {
        // 如果切换《横-全屏》，不走下面代码。
        return;
    }
    
    UIView *superview = nil;
    if (fullScreen) {
        superview = self.fullScreenContainerView;
        self.playerView.frame = [self.playerView convertRect:self.playerView.frame toView:superview];
        [superview addSubview:self.playerView];
        self.fullScreen = YES;
    } else {
        
        superview = self.playerContainerView;

        self.fullScreen = NO;
    }
    if (self.orientationWillSwitchBlock) self.orientationWillSwitchBlock(self, self.isFullScreen);
    CGRect frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    if (animated) {
        [UIView animateWithDuration:switchDuration animations:^{
            self.playerView.frame = frame;
            [self.playerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [superview addSubview:self.playerView];
            self.playerView.frame = superview.bounds;
            if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);
        }];
    } else {
        [superview addSubview:self.playerView];
        self.playerView.frame = superview.bounds;
        [self.playerView layoutIfNeeded];
        if (self.orientationDidSwitchBlock) self.orientationDidSwitchBlock(self, self.isFullScreen);
    }
    /* */
}


#pragma mark - Noftification

- (void)addDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)removeDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)handleDeviceOrientationChange {
    
    // || !self.allowOrentitaionRotation
    if (self.fullScreenMode == MDHFullScreenModePortrait) {
        // 只有横-全屏模式下才支持 屏幕旋转 通知
        return;
    }
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        _currentOrientation = UIInterfaceOrientationUnknown;
        return;
    }
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 是否即将旋转的方向与当前方向相同
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
    return YES;
}

/// 是否支持 LandscapeLeft
- (BOOL)isSupportedLandscapeLeft {
    return YES;
}

/// 是否支持 LandscapeRight
- (BOOL)isSupportedLandscapeRight {
    return YES;
}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        /*
         在 iOS中可以直接调用某个对象的消息方式有两种：
         1. performSelector:withObject；
         2. NSInvocation。
         
         NSInvocation;用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数,

         NSMethodSignature：签名：再创建NSMethodSignature的时候，必须传递一个签名对象，
                            签名对象的作用：用于获取参数的个数和方法的返回值
                            创建签名对象的时候不是使用NSMethodSignature这个类创建，而是方法属于谁就用谁来创建 UIDevice
         */
        NSMethodSignature*signature = [UIDevice instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        
        //注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用
        [invocation setArgument:&val atIndex:2];
        
        //只要调用invocation的invoke方法，就代表需要执行NSInvocation对象中制定对象的指定方法，并且传递指定的参数
        [invocation invoke];
    }
}

/// 旋转
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

// 针对ios8版本处理
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
    [[self currentViewController] setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    
    [[self currentViewController] setNeedsStatusBarAppearanceUpdate];
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
