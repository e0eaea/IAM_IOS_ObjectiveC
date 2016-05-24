//
//  FavoriteViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 18..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "FavoriteViewController.h"
#import "UIColor+Helper.h"
#import "Client.h"
#import "Card.h"
#import "SearchCell.h"
#import "Other_Info.h"
#import "Detail_Card_ViewController.h"

@interface FavoriteViewController ()

@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)  NSMutableArray * tableData;
@property (strong, nonatomic) MyInfo* myInfo;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     _tableData=[NSMutableArray new];
   
    UINavigationBar * navibar =self.navigationController.navigationBar;
    navibar.barTintColor=[UIColor colorWithRGBA:0x01afffff];
    
}



- (void) viewWillAppear:(BOOL)animated
{
    
    [self load_favorite_card];
    [_tableView reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if([_tableData count]>0)
        [_tableView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void) load_favorite_card
{
    _tableData=[NSMutableArray new];
    
    _managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
    
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *info= [fetchedObjects objectAtIndex:0];
    
    _myInfo = (MyInfo *)info;

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
    NSArray *sorted_other =    [_myInfo.interest_other sortedArrayUsingDescriptors:@[sort]];
    
    [_tableData addObjectsFromArray:sorted_other];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


//섹션의 row갯수 반환
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

// 셀 만들기
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SearchCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil] objectAtIndex:0];
    
    
    Other_Info* other = (Other_Info *)_tableData[indexPath.row];
    
    Client *client=[[Client alloc]init];
    client.id=other.id;

    NSArray * other_cards= [other.other_cards allObjects];
    
    Card * card= [other_cards objectAtIndex:0];
    client.card=card;
    
    client.myinfo=card.myinfo;

    client.status=YES;
    
    cell.client_info=client;
    [cell adjust ];
     
    
    return cell;
}

//섹션 헤더 높이
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UIColor *clearColor = [UIColor clearColor];
    view.tintColor = clearColor;
}

//테이블셀의 높이
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"셀클릭");
    
    SearchCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    
    Detail_Card_ViewController *detail=[[Detail_Card_ViewController alloc]init_with_client_info:cell.client_info from_favorite:YES];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
