//
//  APInstallView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/7.
//

#import "APBaseView.h"
#import "APMenuButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface APInstallView : APBaseView
@property (nonatomic , strong) NSMutableArray *data;//传递过的数据（全量数据）
@property (nonatomic , strong) NSMutableArray *sortData;//排序好后的数据（按照modelid分组）
@property (nonatomic , strong) NSMutableArray *btnArray;
@property (nonatomic , strong) NSMutableArray *menuBtnArray;


@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIView *menuView;

@end

NS_ASSUME_NONNULL_END
