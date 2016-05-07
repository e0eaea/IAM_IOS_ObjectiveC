//
//  Card_Images_ViewController.m
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 5. 2..
//  Copyright © 2016년 KMK. All rights reserved.
//

#import "Card_Images_ViewController.h"
#import "Image.h"
#import "UIColor+Helper.h"

@interface Card_Images_ViewController ()

@property(strong, nonatomic) Card *my_card;
@property (nonatomic, retain) NSManagedObjectContext        *managedObjectContext;

@end

@implementation Card_Images_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  _arrPageTitles = @[@"1",@"2",@"3"];
   // _arrPageImages =@[@"plus.png",@"bar.png",@"play_button.png"];
    
    
    // Create page view controller
    _PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    _PageViewController.dataSource = self;
    Card_image_ViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_PageViewController];
    [self.view addSubview:_PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor blackColor];
    
    
    
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    

}

-(void) setup_images:(Card *)card
{
    _arrPageImages=[NSMutableArray new];
    _my_card=card;
    
    if([_my_card.card_images count]==0)
        NSLog(@"카드갯수는 0개");
    
    else
    {NSLog(@"카드갯수는 %lu개",[_my_card.card_images count]);}
    
    for( Image *image_data in _my_card.card_images)
    {
        NSData *data = image_data.image;
        
        [_arrPageImages addObject:data];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((Card_image_ViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((Card_image_ViewController*) viewController).pageIndex;
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [self.arrPageImages count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (Card_image_ViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrPageImages count] == 0) || (index >= [self.arrPageImages count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    Card_image_ViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Card_Image_ViewController"];
    pageContentViewController.imgFile = self.arrPageImages[index];
   // pageContentViewController.txtTitle = self.arrPageTitles[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}


-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.arrPageImages count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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