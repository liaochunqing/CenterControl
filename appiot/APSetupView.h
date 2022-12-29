//
//  APSetupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/17.
//

#import "APBaseView.h"
#import "APChooseItem.h"
#import "APSetNumberItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface APSetupView : APBaseView
-(void)setDefaultValue:(NSArray *)array;
//电源设置
@property (nonatomic,strong)NSMutableArray *djmsDevArray;//
@property (nonatomic,strong)NSMutableArray *zjdjArray;//
@property(nonatomic,strong)NSMutableArray *kjszArray;//
@property(nonatomic,strong)NSMutableArray *ghbmsArray;//
@property(nonatomic,strong)NSMutableArray *yxmsArray;//

//菜单设置
@property (nonatomic,strong)NSMutableArray *languegArray;//
@property (nonatomic,strong)NSMutableArray *locationArray;//
@property(nonatomic,strong)NSMutableArray *nosigalArray;//
@property(nonatomic,strong)NSMutableArray *quitArray;//
@property(nonatomic,strong)NSMutableArray *hidenArray;//
@property(nonatomic,strong)NSMutableArray *muteArray;//

@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备

@property (nonatomic,strong)NSMutableArray *powerItemArray;//
@property (nonatomic,strong)NSMutableArray *menuItemArray;//

@property (nonatomic,strong)UIView *menuBaseview;
@property (nonatomic,strong)UIView *usallyTitleview;

@end

NS_ASSUME_NONNULL_END
