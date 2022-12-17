//
//  APColourView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/17.
//

#import "APBaseView.h"
#import "APSetNumberItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface APColourView : APBaseView
@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备

-(void)setDefaultValue:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
