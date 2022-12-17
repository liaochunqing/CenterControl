//
//  APSetupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/17.
//

#import "APBaseView.h"
#import "APChooseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface APSetupView : APBaseView
-(void)setDefaultValue:(NSArray *)array;
@property (nonatomic,strong)NSMutableArray *djmsDevArray;//
@property (nonatomic,strong)NSMutableArray *zjdjArray;//
@property(nonatomic,strong)NSMutableArray *kjszArray;//
@property(nonatomic,strong)NSMutableArray *ghbmsArray;//
@property(nonatomic,strong)NSMutableArray *yxmsArray;//

@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备

@property (nonatomic,strong)NSMutableArray *powerItemArray;//

@end

NS_ASSUME_NONNULL_END
