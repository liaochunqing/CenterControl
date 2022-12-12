//
//  APVersionView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/12.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APVersionView : APBaseView
@property (nonatomic,strong)UIView *baseview;
//@property (nonatomic,strong)UILabel *titleLab;

//@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;
//-(void)setDefaultValue;
@end

NS_ASSUME_NONNULL_END
