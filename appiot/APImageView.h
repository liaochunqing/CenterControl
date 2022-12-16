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

@property(nonatomic,strong)NSMutableDictionary *sceneModeDict;

-(void)setDefaultValue:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
