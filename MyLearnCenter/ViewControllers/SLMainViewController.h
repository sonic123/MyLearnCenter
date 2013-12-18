//
//  SLMainViewController.h
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/14/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SLRootViewController.h"
#import "SLBookDetailViewController.h"

#import "PopoverView.h"
@interface SLMainViewController : SLRootViewController<UICollectionViewDelegate,UICollectionViewDataSource,PopoverViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *bookCollection;
@property (strong, nonatomic) NSMutableArray *bookArray;
@property (strong, nonatomic) NSMutableArray *bookReadHistoryArray;


@property (strong, nonatomic) NSArray *objArray;
@property (strong, nonatomic) SLBookDetailViewController *bookDetailVC;
@end
