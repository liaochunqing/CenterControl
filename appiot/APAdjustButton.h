//
//  APAdjustButton.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/14.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APAdjustButton : APBaseView

@property(nonatomic,strong)UIButton *microBtn;
@property(nonatomic,strong)UIButton *macroBtn;

@property(nonatomic,strong)UILabel *microLab;
@property(nonatomic,strong)UILabel *macroLab;

@property(nonatomic,strong)UIImageView *microImg;
@property(nonatomic,strong)UIImageView *macroImg;

@end

NS_ASSUME_NONNULL_END
