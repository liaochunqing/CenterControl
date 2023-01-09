//
//  APCenterView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import <UIKit/UIKit.h>
#import "APBaseView.h"
#import "APCommandView.h"
#import "APMonitorView.h"
#import "APInstallView.h"


NS_ASSUME_NONNULL_BEGIN

@interface APCenterView : APBaseView
@property(nonatomic,strong)UIView *centerChangeView;//
@property(nonatomic,strong)NSMutableArray *menuBtnArray;
@property(nonatomic,strong)APCommandView *commandView;
@property(nonatomic,strong)APMonitorView *__nullable monitorView;
@property(nonatomic,strong)APInstallView *installView;

@property(nonatomic,strong)UIButton *controlBtn;

@end

NS_ASSUME_NONNULL_END
