//
//  MDHAVPlayerView.m
//  FullScreenDemo
//
//  Created by Apple on 2018/9/10.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHAVPlayerView.h"

@interface MDHAVPlayerView ()


@end


@implementation MDHAVPlayerView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.playBtn];

    }
    
    return self;
}


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(0, 0, 80, 80);
        _playBtn.backgroundColor = [UIColor blackColor];
        [_playBtn setTitle:@"Touch" forState:UIControlStateNormal];
        [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _playBtn;
}


/*
 屏幕旋转重新布局
 */
- (void)layoutSubviews {
    
    self.playBtn.frame = CGRectMake(0, 0, 80, 80);

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
