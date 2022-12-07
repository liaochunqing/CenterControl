//
//  APInstallView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/7.
//

#import "APInstallView.h"

@implementation APInstallView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{

    CGFloat x = 0;
    CGFloat y = Center_Top_Gap + Center_Btn_Heigth + top_Gap;
    CGFloat w = Center_View_Width;
    CGFloat h = SCREEN_HEIGHT - y;
    
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x161635);
//    
//    [self createSwitchView];
//    [self createTestView];
//    [self createMonitorView];
//    [self getSelectedDev];
}

@end
