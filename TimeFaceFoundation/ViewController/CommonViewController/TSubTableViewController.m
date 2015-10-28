//
//  TSubTableViewController.m
//  TimeFaceFire
//
//  Created by zguanyu on 9/9/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TSubTableViewController.h"
#import "UIViewController+ScrollFullScreen.h"
#import "TFCoreUtility.h"

@interface TSubTableViewController (){
    CGFloat lastPosition;
}

@property (nonatomic ,strong ,readwrite) UITableView            *tableView;
@property (nonatomic ,strong ,readwrite) UISearchBar            *searchBar;
@property (nonatomic ,strong ,readwrite) TFTableViewDataSource    *dataSource;

@end

@implementation TSubTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewStyle = UITableViewStylePlain;
        self.showSearchBar = YES;
        self.usePullReload = YES;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
        _tableView.backgroundColor = TFSTYLEVAR(viewBackgroundColor);
        _tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
        
    }
}

- (void)createDataSource {
    if (self.params && [self.params objectForKey:@"listType"]) {
        [self setListType:[[self.params objectForKey:@"listType"] intValue]];
    }
    self.dataSource = [[TFTableViewDataSource alloc] initWithTableView:self.tableView
                                                              listType:self.listType
                                                              delegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self createDataSource];
    [JDStatusBarNotification addStyleNamed:@"scrollNotice"
                                   prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
                                       style.barColor = [UIColor darkTextColor];
                                       style.textColor = [UIColor whiteColor];
                                       style.animationType = JDStatusBarAnimationTypeMove;
                                       return style;
                                   }];
}


- (void)dealloc {
    [self.dataSource stopLoading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated) {
        //        [self.tableView flashScrollIndicators];
    }
    if (self.listType) {
        [self startLoadData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_RELOAD_CELL object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoReload:)
                                                 name:NOTICE_AUTOLOAD_DATA
                                               object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_AUTOLOAD_DATA
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCell:)
                                                 name:NOTICE_RELOAD_CELL
                                               object:nil];
    
}

- (void)autoReload:(NSNotification *)notification {
    _loaded = NO;
    [self startLoadData];
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated {
    NSAssert(YES, @"This method should be handled by a subclass!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLoadData {
    if (!_loaded) {
        [self.dataSource load:DataLoadPolicyNone params:self.requestParams];
        _loaded = YES;
    }
}


- (void)reloadData {
    [self.dataSource load:DataLoadPolicyNone params:self.requestParams];
}

- (void)reloadCell:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo) {
        NSInteger actionType = [[userInfo objectForKey:@"type"] integerValue];
        NSString *timeId = [userInfo objectForKey:@"timeId"];
        [self.dataSource refreshCell:actionType dataId:timeId];
    }
}
#pragma mark - Privare
- (void)onLeftNavClick:(id)sender {
    
}
- (void)onRightNavClick:(id)sender {
    
}

#pragma mark - TableViewDataSourceDelegate

- (void)actionOnView:(RETableViewItem *)item actionType:(NSInteger)actionType {
    
}

- (void)actionItemClick:(RETableViewItem *)item {
    
}

- (BOOL)showPullRefresh {
    return _usePullReload;
}


- (void)didStartLoad {
    TFLog(@"%s",__func__);
    [self showStateView:TFViewStateLoading];
}


- (CGPoint)offsetForStateView:(UIView *)view {
    return CGPointMake(0, 0);
}

- (void)didFinishLoad:(DataLoadPolicy)loadPolicy error:(NSError *)error {
    TFLog(@"%s",__func__);
    if (!error) {
        [self removeStateView];
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    else {
        TFLog(@"%s",__func__);
        if ([error.domain isEqualToString:APP_ERROR_DOMAIN]) {
            if (error.code == TFErrorCodeEmpty) {
                //空数据
                [self showStateView:TFViewStateNoData];
            }
            if (error.code == TFErrorCodeNetwork) {
                //网络错误
                [self showStateView:TFViewStateNetError];
            }
            if (error.code == TFErrorCodeAPI ||
                error.code == TFErrorCodeHTTP) {
                //其他错误
                [self showStateView:TFViewStateDataError];
            }
        }
        else {
            [self showStateView:TFViewStateDataError];
        }
    }
}


- (void)scrollViewDidScroll:(UITableView *)tableView {
    
    CGFloat currentPostion = tableView.contentOffset.y;
    if (currentPostion - lastPosition > 30) {
        lastPosition = currentPostion;
        //向上滚动
        if (currentPostion > kNoticeoffset) {
            BOOL noticed = [[TFCoreUtility sharedUtility] getBoolByKey:STORE_KEY_SCROLLNOTICE];
            if (!noticed) {
                [JDStatusBarNotification showWithStatus:@"点击这里返回顶部"
                                           dismissAfter:1.5
                                              styleName:@"scrollNotice"];
                [[TFCoreUtility sharedUtility] setBoolByKey:STORE_KEY_SCROLLNOTICE value:YES];
            }
        }
    }
    else if (lastPosition - currentPostion > 30) {
        lastPosition = currentPostion;
    }
    
    
}




- (void)scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp
{
    [self hideToolbar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown
{
    [self showToolbar:YES];
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
