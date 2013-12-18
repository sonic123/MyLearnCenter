//
//  SLBookDetailViewController.m
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/15/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import "SLBookDetailViewController.h"
#import "SLPDFRenderView.h"
#import "SLAppDelegate.h"

@interface SLBookDetailViewController ()

@end

@implementation SLBookDetailViewController
@synthesize bookPath;
@synthesize flipper;
@synthesize pdfDocument;
@synthesize bookHistoryDM;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self saveCurrentStatus];
    [super viewWillDisappear:animated];
}
#pragma mark -
#pragma mark CoreData Handle
-(void)saveCurrentStatus{
    if ([self fetchBookReadHistoryWithBookName:self.bookName]) {
        NSLog(@"success !");
    }else{
        NSLog(@"fail !");
    }
}
-(BOOL )fetchBookReadHistoryWithBookName:(NSString *)bookName{
    BOOL isSuccess=NO;
    SLAppDelegate *delegate=(SLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=nil;
    context=delegate.managedObjectContext;
    NSFetchRequest *fetchRequest=nil;
    fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BookReadHistory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate=nil;
    predicate = [NSPredicate predicateWithFormat:@"bookName = %@",bookName];
    fetchRequest.predicate=predicate;
     NSError *error=nil;
    BookReadHistory *bookreadHistory=nil;
    bookreadHistory=[[context executeFetchRequest:fetchRequest error:&error] lastObject];
    if (bookreadHistory) {
        bookreadHistory.bookName=self.bookName;
        bookreadHistory.bookPath=self.bookPath;
        bookreadHistory.currentPage=[NSNumber numberWithInteger:self.flipper.currentPage];
        bookreadHistory.modifyDate=[NSDate date];
    }else{
        bookreadHistory=[NSEntityDescription insertNewObjectForEntityForName:@"BookReadHistory" inManagedObjectContext:context];
        bookreadHistory.bookName=self.bookName;
        bookreadHistory.bookPath=self.bookPath;
        bookreadHistory.currentPage=[NSNumber numberWithInteger:self.flipper.currentPage];
        bookreadHistory.modifyDate=[NSDate date];
    }
    if ([context save:&error]) {
            isSuccess=YES;
        }else{
            isSuccess=NO;
        }
    return isSuccess;
}

-(NSArray *)fetchBookReadHistory{
    SLAppDelegate *delegate=(SLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=nil;
    context=delegate.managedObjectContext;    NSFetchRequest *fetchRequest=nil;
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
    SLAppDelegate *delegate=(SLAppDelegate *)[UIApplication sharedApplication];
    return delegate;
}

#pragma mark -
#pragma mark Data source implementation


- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *)pageFlipper {
	return self.view.bounds.size.width > self.view.bounds.size.height ? ceil((float) CGPDFDocumentGetNumberOfPages(self.pdfDocument) / 2) : CGPDFDocumentGetNumberOfPages(self.pdfDocument);
}


- (UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper {
    SLPDFRenderView *result=nil;
    result= [[SLPDFRenderView alloc] initWithFrame:pageFlipper.bounds] ;
	result.pdfDocument = pdfDocument;
	result.pageNumber = page;
	return result;
}


#pragma mark -
#pragma mark View management


- (void) loadView {
	[super loadView];
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    if (!flipper) {
        flipper = [[AFKPageFlipper alloc] initWithFrame:self.view.bounds];
        flipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
    }
	flipper.dataSource = self;
	[self.view addSubview:flipper];
}



#pragma mark -
#pragma mark Initialization and memory management


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}


- (id) init {
	if ((self = [super init])) {
	}
	
	return self;
}
-(void)loadPDF{
    self.title=self.bookName;
    self.pdfDocument=nil;
    self.pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)
                                                  [NSURL fileURLWithPath:self.bookPath isDirectory:YES]);
    [self loadView];
}


- (void)dealloc {
	CGPDFDocumentRelease(self.pdfDocument);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
