//
//  APSignalView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/19.
//

#import "APBaseView.h"
#import "APRadioItem.h"

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

//VGA
@property(nonatomic,strong)NSMutableArray *VGAitemArray;//储存器


//3d设置
@property (nonatomic,strong)NSMutableArray *moshiArray;//
@property (nonatomic,strong)NSMutableArray *geshiArray;//
@property(nonatomic,strong)NSMutableArray *tongbuArray;//
@property(nonatomic,strong)NSMutableArray *zyyysArray;//
@property(nonatomic,strong)NSMutableArray *zyyfzArray;//
@property(nonatomic,strong)NSMutableArray *acsjArray;//

//hdmi
@property(nonatomic,strong)NSMutableArray *cskjArray;//
@property(nonatomic,strong)NSMutableArray *xhdpfwArray;//
@property(nonatomic,strong)NSMutableArray *HDMIitemArray;//储存器

@end

NS_ASSUME_NONNULL_END
