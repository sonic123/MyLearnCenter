//
//  BookReadHistory.h
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/16/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookReadHistory : NSManagedObject

@property (nonatomic, retain) NSString * bookName;
@property (nonatomic, retain) NSString * bookPath;
@property (nonatomic, retain) NSNumber * currentPage;
@property (nonatomic, retain) NSDate * modifyDate;

@end
