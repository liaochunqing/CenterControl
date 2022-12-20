//
//  APRadioItem.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/20.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChooseClickBlock)(NSString* str);

@interface APRadioItem : APBaseView
@property (nonatomic,strong)NSMutableArray *dataArray;//

//@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *label;
//@property(nonatomic,strong)UIImageView *im;
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *labArray;

@property (nonatomic, copy) ChooseClickBlock btnClickBlock;

-(void)setDefaultValue:(NSArray *)array title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
