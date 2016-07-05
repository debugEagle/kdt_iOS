//
//  TVC.m
//  ui
//
//  Created by wd on 15-6-21.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "ScpCtlViewCell.h"
#import "ScpViewCell.h"
#import "ScpController.h"
#import "ScriptStore.h"
//#import "AppDelegate.h"
#import "KDTCustom.h"
#import "ScriptStore.h"
#import "KDTNavigationController.h"
#import <objc/runtime.h>

@interface ScpController ()

@end

static NSString *Maincell = @"Maincell";
static NSString *AddCell = @"AddCell";


@implementation ScpController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:KDT_SETTINGS_PATH];
    assert(dict);
    NSString* identifier = [dict objectForKey:@"select"];
    if (!identifier)
        identifier = @"";
    self.selectID = identifier;
    self.dataSource = [[ScriptStore shared] allScripts];
}

-(void) reload
{
    self.expand = nil;
    self.select = nil;
    self.selectID = @"";
    self.dataSource = [[ScriptStore shared] allScripts];
    [self writeSelect];
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                    target:self
                                                                                    action:@selector(reload)];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f; //Section 头部高度
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cell_type = [self.dataSource[indexPath.row] objectForKey:@"celltype"];
    if ([cell_type isEqualToString:Maincell]) {
        return 73.f;
    }
    if ([cell_type isEqualToString:AddCell]) {
        return 38.f;
    }
    return 0.f;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cell_type = [self.dataSource[indexPath.row] objectForKey:@"celltype"];
    
    if ([cell_type isEqualToString:Maincell]) {
        if (_expand) {
            NSIndexPath *to_del = [NSIndexPath indexPathForItem:(_expand.row + 1) inSection:indexPath.section];
            
            [self.dataSource[_expand.row] removeObjectForKey:@"expand"];
            [self.dataSource removeObjectAtIndex:to_del.row];
            
            ScpViewCell* cell = (ScpViewCell*)[self.tableView cellForRowAtIndexPath:_expand];
            if (cell)
                [cell leftArrow];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[to_del]  withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            
            if (_expand.row == indexPath.row) {
                if (_select && (_select.row > _expand.row)) {
                    WDLog("-1 s:%ld e:%ld i:%ld",_select.row,_expand.row,indexPath.row);
                    self.select = [NSIndexPath indexPathForItem:(_select.row - 1) inSection:_select.section];
                }
                self.expand = nil;
                return nil;
            }
            
            /* 修正选中index */
            if (_select && (_expand.row < _select.row)) {
                if (indexPath.row >= _select.row) {
                    WDLog("-1 s:%ld e:%ld i:%ld",_select.row,_expand.row,indexPath.row);
                    self.select = [NSIndexPath indexPathForItem:(_select.row - 1) inSection:_select.section];
                }
            }
            
            if (_select && (_expand.row >= _select.row)) {
                if (indexPath.row < _select.row) {
                    WDLog("+1 s:%ld e:%ld i:%ld",_select.row,_expand.row,indexPath.row);
                    self.select = [NSIndexPath indexPathForItem:(_select.row + 1) inSection:_select.section];
                }
            }
            /* 修正选中index */
            if (_expand.row < indexPath.row) {
                return [NSIndexPath indexPathForItem:(indexPath.row - 1) inSection:indexPath.section];
            }
            return indexPath;
        }
        /* 修正选中index */
        if (_select && (_select.row > indexPath.row)) {
            WDLog("+1:%ld",_select.row + 1);
            self.select = [NSIndexPath indexPathForItem:(_select.row + 1) inSection:_select.section];
        }
        /* 修正选中index */
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cell_type = [self.dataSource[indexPath.row] objectForKey:@"celltype"];
    WDLog("select:%ld",indexPath.row);
    if ([cell_type isEqualToString:Maincell]) {      /* 主cell */
        /* 要展开的位置 */
        NSIndexPath *to_add = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
        /* 更新数据源 */
        NSDictionary * dict = @{@"celltype": @"AddCell"};
        [self.dataSource insertObject:dict atIndex:to_add.row];
        [self.dataSource[indexPath.row] setObject:@YES forKey:@"expand"];
        /* 如果cell可见 显式更改状态 */
        ScpViewCell* cell = (ScpViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell)
            [cell downArrow];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[to_add]  withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        self.expand = indexPath;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDLog("get:%ld", indexPath.row);
    NSString* cell_id = [self.dataSource[indexPath.row] objectForKey:@"celltype"];
    
    if ([cell_id isEqualToString:Maincell])
    {
        NSMutableDictionary* dict = self.dataSource[indexPath.row];
        ScpViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Maincell];
        if (cell == nil) {
            cell = [[ScpViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Maincell];
            /* cell首次创建时查找select项所在位置 */
            if ([_selectID isEqualToString: [dict objectForKey:@"id"]]) {
                self.select = indexPath;
                [dict setObject:@YES forKey:@"select"];
            }
        }
        [cell renderWithContent: dict];
        return cell;
    }
    
    if ([cell_id isEqualToString:AddCell])
    {
        ScpCtlViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCell];
        if (cell == nil) {
            cell = [[ScpCtlViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCell];
            cell.delegate = self;
        }
        return cell;
    }
    
    return nil;
}


- (void)writeSelect {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:KDT_SETTINGS_PATH];
    assert(dict);
    WDLog("%@:%@",_selectID,dict);
    [dict setObject:_selectID forKey:@"select"];
    [dict writeToFile:KDT_SETTINGS_PATH atomically:YES];
}

- (void) choose:(NSIndexPath*)index {
    NSMutableDictionary* add_dict = self.dataSource[index.row];
    NSMutableDictionary* del_dict = nil;
    
    NSString* identifier = [add_dict objectForKey:@"id"];
    if (!identifier)
        identifier = @"";
    ScpViewCell* cell = nil;
    
    
    if (_select) {
        del_dict = self.dataSource[_select.row];
        [del_dict removeObjectForKey:@"select"];
        WDLog("last:%@",del_dict);
        cell = (ScpViewCell*)[self.tableView cellForRowAtIndexPath:_select];
        if (cell)
            [cell deSelect:del_dict];
        /* 取消所选 */
        if (_select.row == index.row) {
            self.select = nil;
            self.selectID = @"";
            WDLog("now:%p",_selectID);
            [self writeSelect];
            return;
        }
    }
    
    cell = (ScpViewCell*)[self.tableView cellForRowAtIndexPath:index];
    if (cell)
        [cell setSelect:add_dict];
    [add_dict setObject:@YES forKey:@"select"];
    self.select = index;
    self.selectID = identifier;
    WDLog("now:%@ ;%ld",add_dict,index.row);
    [self writeSelect];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) return;
    NSIndexPath* index = objc_getAssociatedObject(alertView, "index");
    [self _delete:index];
}

-(void) _delete:(NSIndexPath*)index {
    NSMutableDictionary* add_dict = self.dataSource[index.row];
    NSString* identifier = [add_dict objectForKey:@"id"];
    NSIndexPath* del_scp = index;
    NSIndexPath* del_ctl = [NSIndexPath indexPathForItem:(index.row + 1) inSection:index.section];
    
    if (_select && _select.row == index.row) {
        self.select = nil;
        self.selectID = @"";
        [self writeSelect];
    }
    
    [self.dataSource removeObjectAtIndex:del_ctl.row];
    [self.dataSource removeObjectAtIndex:del_scp.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[del_scp, del_ctl]  withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    
    self.expand = nil;
    
    
    NSFileManager* manger = [NSFileManager defaultManager];
    NSError* error = nil;
    NSString* path = [NSString stringWithFormat:@"%@/script/%@", KDT_DOC_PATH, identifier];
    [manger removeItemAtPath:path error:&error];
    if (error)
        NSLog(@"remove %@: %@",path, error);
}



-(void) delete:(NSIndexPath*)index {
    NSMutableDictionary* add_dict = self.dataSource[index.row];
    NSString* identifier = [add_dict objectForKey:@"name"];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"是否删除"
                                                    message:identifier
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    objc_setAssociatedObject(alert, "index", index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

-(void) runSetting:(NSIndexPath*)index {
    NSMutableDictionary* add_dict = self.dataSource[index.row];
    NSString* path = [add_dict objectForKey:@"settings"];
    if (!path)
        return;
    NSString* title = [add_dict objectForKey:@"name"];
    KDTCustom* settings = [[KDTCustom alloc] initWithPath:path];
    settings.title = title;
    [self.navigationController pushViewController:(UIViewController*)settings animated:YES];
    [settings release];
}

- (void) handleEvent:(NSInteger)arg{
    switch (arg) {
        case 0:
            [self choose:_expand];
            break;
        case 2:
            [self delete:_expand];
            break;
        case 3:
            [self runSetting:_expand];
        default:
            break;
    }
}




@end
