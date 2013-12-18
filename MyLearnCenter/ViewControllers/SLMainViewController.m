//
//  SLMainViewController.m
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/14/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import "SLMainViewController.h"
#import "SLBookCell.h"
#import "SLBookDM.h"
#import "SLAppDelegate.h"

static NSString *bookCellID = @"BookCell";

@interface SLMainViewController ()

@end

@implementation SLMainViewController
@synthesize bookArray;
@synthesize bookCollection;
@synthesize bookDetailVC;
@synthesize bookReadHistoryArray;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.bookArray=[NSMutableArray arrayWithCapacity:0];
        self.bookReadHistoryArray=[NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
-(void)initUI{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 748, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"My Learning Center";
    titleLabel.font=[UIFont fontWithName:@"Avenir-Book" size:24];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    [self.bookCollection registerClass:[SLBookCell class] forCellWithReuseIdentifier:bookCellID];
    UIBarButtonItem *rightButtom=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"burger"] style:UIBarButtonItemStylePlain target:self action:@selector(showReadHistory)];
    self.navigationItem.rightBarButtonItem=rightButtom;
    rightButtom=nil;

    [self fetchBookArray];
    
    
}
-(void)showReadHistory{
    self.objArray=[self fetchBookReadHistory];
     [self.bookReadHistoryArray removeAllObjects];
    if ([self.objArray count]==0) {
        [self.bookReadHistoryArray addObject:@"No History"];
    }else{
       
        for (NSDictionary  *dic in self.objArray) {
            [self.bookReadHistoryArray addObject:[dic objectForKey:@"bookName"]];
        }
    }
    
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
        [PopoverView showPopoverAtPoint:CGPointMake(740, 55) inView:self.view withTitle:@"History" withStringArray:self.bookReadHistoryArray delegate:self];
    }else{
        [PopoverView showPopoverAtPoint:CGPointMake(740, 35) inView:self.view withTitle:@"History" withStringArray:self.bookReadHistoryArray delegate:self];
    }

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(NSArray *)fetchBookReadHistory{
    
    NSManagedObjectContext *context=nil;
    context=[[self getAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest=nil;
    fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BookReadHistory" inManagedObjectContext:context];
    
    NSSortDescriptor *sort=nil;
    sort=[[NSSortDescriptor alloc]initWithKey:@"modifyDate" ascending:NO];
    NSMutableArray *sortDesctiptors=nil;
    sortDesctiptors=[[NSMutableArray alloc]initWithObjects:sort, nil];
    
    fetchRequest.sortDescriptors=sortDesctiptors;
    fetchRequest.returnsDistinctResults=YES;
    fetchRequest.resultType=NSDictionaryResultType;
    [fetchRequest setEntity:entity];
    NSError *error=nil;
    NSArray *bookReadHistory=[context executeFetchRequest:fetchRequest error:&error];
    if ([bookReadHistory count]!=0) {
        return bookReadHistory;
    }else{
        return NULL;
    }
    
}
-(SLAppDelegate *)getAppDelegate{
    return [[UIApplication sharedApplication]delegate];
}

-(void)fetchBookArray{
    self.bookArray=[NSMutableArray arrayWithArray:[super fetchDocumentBookList]];
    NSLog(@"bookArray:%@",self.bookArray);
}

#pragma mark -
#pragma mark PopoverViewDelegate

//Delegate receives this call as soon as the item has been selected
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index{
    if ([self.objArray count]!=0) {
        if (!self.bookDetailVC) {
            self.bookDetailVC=[[SLBookDetailViewController alloc]init];
        }
        self.bookDetailVC.bookPath=[[self.objArray objectAtIndex:index] objectForKey:@"bookPath"];
        self.bookDetailVC.bookName=[[self.objArray objectAtIndex:index] objectForKey:@"bookName"];
        self.bookDetailVC.haveNeedToPage=0;
        if ([[self.objArray objectAtIndex:index] objectForKey:@"currentPage"]) {
            self.bookDetailVC.haveNeedToPage=[[[self.objArray objectAtIndex:index] objectForKey:@"currentPage"] integerValue];
        }
        [self.bookDetailVC loadPDF];
        [self.navigationController pushViewController:self.bookDetailVC animated:NO];
    }
    [popoverView dismiss];
}

//Delegate receives this call once the popover has begun the dismissal animation
- (void)popoverViewDidDismiss:(PopoverView *)popoverView{

}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num=0;
    if ([self.bookArray count]!=0) {
        num=[self.bookArray count];
    }
    return num;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
//-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewWithReuseIdentifier:atIndexPath:




#pragma mark -
#pragma mark UICollectionViewDelegate


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    SLBookCell * cell = [self.bookCollection dequeueReusableCellWithReuseIdentifier:bookCellID forIndexPath:indexPath];
    if (!cell) {
        cell=[[SLBookCell alloc]init];
    }
    SLBookDM *oneBook=[self.bookArray objectAtIndex:indexPath.row];
    cell.bookCover.image=oneBook.bookCover;
    cell.bookName.text=oneBook.bookName;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.bookCollection deselectItemAtIndexPath:indexPath animated:YES];
    SLBookDM *oneBookDM=[self.bookArray objectAtIndex:indexPath.row];
    if (!self.bookDetailVC) {
        self.bookDetailVC=[[SLBookDetailViewController alloc]init];
    }
    self.bookDetailVC.bookPath=oneBookDM.bookPath;
    self.bookDetailVC.bookName=oneBookDM.bookName;
    [self.bookDetailVC loadPDF];
    [self.navigationController pushViewController:self.bookDetailVC animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
