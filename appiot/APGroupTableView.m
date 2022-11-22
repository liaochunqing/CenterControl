//
//  APGroupTableView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import "APGroupTableView.h"
#import "AppDelegate.h"
@implementation APGroupTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        //        self.dataSource = self;
        //        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        
        /*
         self.estimatedSectionHeaderHeight = H_SCALE(44);
         _filteredData = [NSMutableArray array];
         
         
         self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
         self.searchController.searchResultsUpdater = self;
         _searchController.obscuresBackgroundDuringPresentation = NO;
         
         _searchController.hidesNavigationBarDuringPresentation = TRUE;
         
         _searchController.searchBar.delegate = self;
         
         
         //        _searchController.searchBar.frame = CGRectMake(0, 0, Left_View_Width, H_SCALE(44));
         
         //设置bar
         UISearchBar *bar = _searchController.searchBar;
         //将搜索栏添加到页面上
         UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Left_View_Width, H_SCALE(44))];
         [view addSubview:bar];
         [self addSubview:view];
         //            self.tableHeaderView = self.searchController.searchBar;
         //        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
         //        [self addSubview:searchBar];
         bar.tintColor = [UIColor redColor];
         // 改变searchBar背景颜色
         bar.barTintColor = ColorHex(0x29315F);
         // 默认为YES,控制搜索控制器的灰色半透明效果
         bar.placeholder = @"搜索投影机/分组";
         bar.searchBarStyle = UISearchBarStyleMinimal;
         [bar sizeToFit];
         }
         
         //以此来设置搜索框中的颜色
         UITextField *searchField=[_searchController.searchBar valueForKey:@"searchField"];
         searchField.backgroundColor = ColorHex(0x29315F);
         //改变搜索框中的placeholder的颜色
         [searchField setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
         */
    }
    return self;
}




///**
// * 初始化数据源
// */
//-(NSMutableArray *)createTempData : (NSArray *)data{
//    _tempData = [NSMutableArray array];
//    _data = [NSMutableArray array];
//
//    
//    for (int i=0; i<data.count; i++)
//    {
//        APGroupNote *node = [data objectAtIndex:i];
//        [_data addObject:node];
//
//        if (node.expand) {
//            [_tempData addObject:node];
//        }
//    }
//    return _tempData;
//}

-(void)selectedAllWithSelected:(BOOL)selected
{
    for (int k = 0; k < self.data.count; k++)
    {
        APGroupNote *node = self.data[k];
        node.selected = selected;
    }
    [self reloadData];
}

-(void)deleteSelectedNode
{
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];//临时容器，存储将要删除的节点
    
    //收集删除节点
    for (int i = 0; i < _data.count; i++)
    {
        APGroupNote *first = _data[i];
        if (first.selected)//第一层
        {
            if(first.expand == YES)
            {
                for (int k = 0; k < _data.count; k++)
                {
                    APGroupNote *second = _data[k];
                    if (second.parentId == first.nodeId)//第二层
                    {
                        for (int j = 0; j < _data.count; j++)
                        {
                            APGroupNote *third = _data[j];
                            if (third.parentId == second.nodeId)//第三层
                            {
                                [set addIndex:j];

                            }
                        }
                        [set addIndex:k];

                    }
                }
            }
            
            [set addIndex:i];
        }
    }

    
    //删除节点刷新列表
    if (set.count > 0)
    {
        WS(weakSelf);
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            
            [weakSelf.data removeObjectsAtIndexes:set];
            [weakSelf reloadData];
        }];
                
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

        [alert addAction:action1];
        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
    //    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];  //显示对话框
    }
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
     
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
     
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    return image;
}
#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchController.active) {
         return 1;
    }
    return 1;
}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //控制器使用的时候，就是点击了搜索框的时候
    if (_searchController.active)
    {
        return _filteredData.count;
    }
    
    return _data.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";

    APGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[APGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    APGroupNote *node;
    if (_searchController.active)
    {
        node = [_filteredData objectAtIndex:indexPath.row];
    }
    else
    {
        node = [_data objectAtIndex:indexPath.row];
    }

    [cell updateCellWithData:node];
    
//    WS(weakSelf);
    __block APGroupNote *temp = [_data objectAtIndex:indexPath.row];
    [cell setBtnClickBlock:^(BOOL index) {
        
        temp.selected = index;
    }];
    return cell;
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    APGroupNote *node = _data[row];
    if (node && node.height == 0)
    {
        return node.height;
    }
    
    return 40;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    APGroupNote *node = _data[row];
    if (node == nil) return;
    
    if (node.expand == YES)
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if (second.parentId == node.nodeId)
            {
                second.height = 0;
                
                for (int k = 0; k < _data.count; k++)
                {
                    APGroupNote *third = _data[k];
                    if (third.parentId == second.nodeId)
                    {
                        third.height = 0;
                    }
                }
            }
        }
    }
    else
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if (second.parentId == node.nodeId)
            {
                second.height = Group_Cell_Height;
                if(second.expand == YES)
                {
                    for (int k = 0; k < _data.count; k++)
                    {
                        APGroupNote *third = _data[k];
                        if (third.parentId == second.nodeId)
                        {
                            third.height = Group_Cell_Height;
                        }
                    }
                }
            }
        }
    }
    
    [tableView reloadData];
}
@end
