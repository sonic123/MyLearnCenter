//
//  SLBookCell.m
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/14/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import "SLBookCell.h"

@implementation SLBookCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bookCover=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 180, 260)];
        self.bookCover.backgroundColor=[UIColor clearColor];
        self.bookCover.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:self.bookCover];
        
        self.bookName=[[UILabel alloc]initWithFrame:CGRectMake(0, 265, 220, 40)];
        self.bookName.backgroundColor=[UIColor clearColor];
        self.bookName.textColor=[UIColor blackColor];
        self.bookName.textAlignment=NSTextAlignmentCenter;
        self.bookName.font=[UIFont fontWithName:@"Avenir-Light" size:12.0f];
        self.bookName.numberOfLines=2;
        [self addSubview:self.bookName];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
