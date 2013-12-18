//
//  SLBookDetailViewController.h
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/15/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFKPageFlipper.h"
#import "BookReadHistory.h"
#import "SLRootViewController.h"

@interface SLBookDetailViewController : SLRootViewController<AFKPageFlipperDataSource,NSFetchedResultsControllerDelegate>{
    CGPDFDocumentRef pdfDocument;
    AFKPageFlipper *flipper;
}
@property (assign, nonatomic) CGPDFDocumentRef pdfDocument;
@property (strong, nonatomic) AFKPageFlipper *flipper;
@property (strong, nonatomic) NSString *bookPath;
@property (strong, nonatomic) NSString *bookName;
@property (nonatomic)  NSInteger haveNeedToPage;
@property (strong, nonatomic) BookReadHistory *bookHistoryDM;

-(void)loadPDF;
@end
