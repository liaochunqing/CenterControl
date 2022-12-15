//
//  APSetNumberItem.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APSetNumberItem : APBaseView<UITextFieldDelegate>

@property(nonatomic,strong)UILabel* label;
@property(nonatomic,strong)UITextField* field;
@property(nonatomic,strong)UISlider * slider;
@end

NS_ASSUME_NONNULL_END
