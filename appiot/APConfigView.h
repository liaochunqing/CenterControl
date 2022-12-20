//
//  APConfigView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/20.
//

#import "APBaseView.h"
#import "APChooseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface APConfigView : APBaseView


@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备
//
@property (nonatomic,strong)NSMutableArray *hmblArray;//
@property (nonatomic,strong)NSMutableArray *azfsArray;//
@property(nonatomic,strong)NSMutableArray *tyjidArray;//
@property(nonatomic,strong)NSMutableArray *ykidArray;//
@property (nonatomic,strong)NSMutableArray *ykjsArray;//
@property(nonatomic,strong)NSMutableArray *sshjArray;//

@property (nonatomic,strong)NSMutableArray *itemArray;//

-(void)setDefaultValue:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
