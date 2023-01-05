//
//  APImageView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APBaseView.h"
#import "APSetNumberItem.h"
#import "APChooseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface APImageView : APBaseView
@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备
@property (nonatomic,strong)NSMutableArray *chooseItemArray;//选中的设备

@property(nonatomic,strong)NSMutableArray *sceneModeArray;//场景模式
@property(nonatomic,strong)NSMutableArray *dynamicContrastArray;//动态对比度
@property(nonatomic,strong)NSMutableArray *contrastEnhanceArray;//对比度增强
@property(nonatomic,strong)NSMutableArray *ImageScaleArray;//画面比例
@property(nonatomic,strong)NSMutableArray *gammaAdjustArray;//gamma调节
@property(nonatomic,strong)NSMutableArray *colorAdjustingArray;//色温调节

@property(nonatomic,strong)NSMutableArray *itemArray;//储存器

-(void)setDefaultValue:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
