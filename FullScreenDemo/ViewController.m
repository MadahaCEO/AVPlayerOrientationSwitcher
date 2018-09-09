//
//  ViewController.m
//  FullScreenDemo
//
//  Created by Apple on 2018/9/9.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "ViewController.h"
#import "MDHOrientationSwitcher.h"


@interface ViewController () {
    
    MDHOrientationSwitcher *orientationSwitcher;
}

@property (nonatomic, strong) UIView *smallContainerView;
@property (nonatomic, strong) UIView *smallView;
@property (nonatomic, strong) UIButton *playBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [self.view addSubview:self.smallContainerView];
    [self.smallContainerView addSubview:self.smallView];
    
    
    [self.smallView addSubview:self.playBtn];
    self.playBtn.center = self.smallView.center;
    
    orientationSwitcher = [[MDHOrientationSwitcher alloc] init];
    orientationSwitcher.fullScreenMode = MDHFullScreenModeLandscape;
    [orientationSwitcher updateRotateView:self.smallView containerView:self.smallContainerView];

    __weak typeof(self) weakSelf = self;
    orientationSwitcher.orientationWillSwitchBlock = ^(MDHOrientationSwitcher *switcher, BOOL isFullScreen) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setNeedsStatusBarAppearanceUpdate];
    };
    
    orientationSwitcher.orientationDidSwitchBlock = ^(MDHOrientationSwitcher *switcher, BOOL isFullScreen) {
        
    };
}


- (void)switchButtonClick:(UIButton *)button {
    
    if (orientationSwitcher.fullScreenMode == MDHFullScreenModePortrait) {
        
    } else {
        
        UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
        orientation = orientationSwitcher.isFullScreen ? UIInterfaceOrientationPortrait :  UIInterfaceOrientationLandscapeRight;
        [orientationSwitcher enterLandscapeFullScreen:orientation animated:YES];
    }
    
}




- (UIStatusBarStyle)preferredStatusBarStyle {
    if (orientationSwitcher.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    
    NSLog(@"\n\n\n prefersStatusBarHidden +++++++++++++++%@\n\n\n",orientationSwitcher.isStatusBarHidden?@"Y":@"N");

    return orientationSwitcher.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    
    NSLog(@"\n\n\n shouldAutorotate ============%@\n\n\n",orientationSwitcher.shouldAutorotate?@"Y":@"N");

    return orientationSwitcher.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (orientationSwitcher.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - lazy load

- (UIView *)smallContainerView {
    if (!_smallContainerView) {
        
        CGFloat width  = CGRectGetWidth(self.view.frame);
        CGFloat height = width*9/16;
        
        _smallContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
        _smallContainerView.backgroundColor = [UIColor orangeColor];
        
    }
    return _smallContainerView;
}

- (UIView *)smallView {
    if (!_smallView) {
        
        _smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.smallContainerView.bounds.size.width, self.smallContainerView.bounds.size.height)];
        _smallView.backgroundColor = [UIColor redColor];
        _smallView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _smallView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(0, 0, 80, 80);
        _playBtn.backgroundColor = [UIColor blackColor];
        [_playBtn setTitle:@"Touch" forState:UIControlStateNormal];
        [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
 
//        _playBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    }
    return _playBtn;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
