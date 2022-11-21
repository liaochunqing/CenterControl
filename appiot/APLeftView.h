//
//  APLeftView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import <UIKit/UIKit.h>
#import "APBaseView.h"
#import "APGroupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APLeftView : APBaseView
//@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *topView;//顶头标题栏基础view
@property(nonatomic,strong)UIButton *btnLeft;
@property(nonatomic,strong)UIButton *btnRight;
@property(nonatomic,strong)APGroupView *groupView;

@property(nonatomic,strong)NSMutableArray *pageBtnArray;

@end

NS_ASSUME_NONNULL_END
