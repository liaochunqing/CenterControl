//
//  APSignalView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/19.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APSignalView : APBaseView
-(void)setDefaultValue:(NSArray *)array;

@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备
//
@property (nonatomic,strong)NSMutableArray *kjmrArray;//
@property (nonatomic,strong)NSMutableArray *xhxzArray;//
@property(nonatomic,strong)NSMutableArray *kbpArray;//
@property(nonatomic,strong)NSMutableArray *zdssArray;//

@property (nonatomic,strong)NSMutableArray *itemArray;//


@property(nonatomic,strong)NSMutableArray *yxmsArray;//

//菜单设置
@property (nonatomic,strong)NSMutableArray *languegArray;//
@property (nonatomic,strong)NSMutableArray *locationArray;//
@property(nonatomic,strong)NSMutableArray *nosigalArray;//
@property(nonatomic,strong)NSMutableArray *quitArray;//
@property(nonatomic,strong)NSMutableArray *hidenArray;//
@property(nonatomic,strong)NSMutableArray *muteArray;//
@end

NS_ASSUME_NONNULL_END
