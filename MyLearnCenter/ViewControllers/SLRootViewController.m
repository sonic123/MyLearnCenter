//
//  SLRootViewController.m
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/14/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import "SLRootViewController.h"
#import "SLAppDelegate.h"
#import "SLBookDM.h"
#import "BookReadHistory.h"


@interface SLRootViewController ()

@end

@implementation SLRootViewController

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
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(NSMutableArray *)fetchDocumentBookList{
    NSMutableArray *bookList=[NSMutableArray arrayWithCapacity:0];
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSError *error=nil;
    NSArray *paths=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
    SLBookDM *oneBook=nil;
    for (NSString *fileName in paths) {
        if ([[fileName pathExtension] isEqualToString:@"pdf"]) {
            @autoreleasepool {
                oneBook=[[SLBookDM alloc]init];
                oneBook.bookName=[fileName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
                oneBook.bookPath=[filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
                oneBook.bookCover=[self imageFromPDFWithDocumentRef:[self createPDFFromExistFile:[filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]]];
                [bookList addObject:oneBook];
            }
        }
    }
    return bookList;
}
- (CGPDFDocumentRef )createPDFFromExistFile:(NSString *)aFilePath{
    
    CFStringRef path;
    
    CFURLRef url;
    
    CGPDFDocumentRef document;
    
    
    path = CFStringCreateWithCString(NULL, [aFilePath UTF8String], kCFStringEncodingUTF8);
    
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    
    CFRelease(path);
    
    document = CGPDFDocumentCreateWithURL(url);
    
    CFRelease(url);
    
    size_t totalPages = CGPDFDocumentGetNumberOfPages(document);
    
    if (totalPages == 0) {
        return NULL;
    }
    
    return document;
    
}
- (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef {
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
