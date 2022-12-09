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

    CGFloat x = Left_Gap;
    CGFloat y = Center_Top_Gap + Center_Btn_Heigth + top_Gap;
    CGFloat w = Center_View_Width- 2*Left_Gap;
    CGFloat h = SCREEN_HEIGHT - y - top_Gap;
    
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x1D2242);
    ViewRadius(self, 10);

    [self createSelectedView];
//    [self createTestView];
//    [self createMonitorView];
//    [self getSelectedDev];
}

-(void)createSelectedView
{
    UILabel *fenzuLab = [[UILabel alloc] init];
    [self addSubview:fenzuLab];
    fenzuLab.text = @"当前已选设备";
    fenzuLab.font = [UIFont systemFontOfSize:20];
    fenzuLab.textColor = [UIColor whiteColor];
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(140), H_SCALE(30)));
    }];
}

@end
