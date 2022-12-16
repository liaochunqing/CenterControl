//
//  APSetNumberItem.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NumberChangedBlock)(NSString* str);

@interface APSetNumberItem : APBaseView<UITextFieldDelegate>

@property(nonatomic,strong)UILabel* label;
@property(nonatomic,strong)UITextField* field;
@property(nonatomic,strong)UISlider * slider;

@property (nonatomic, copy) NumberChangedBlock changedBlock;

@end

NS_ASSUME_NONNULL_END
