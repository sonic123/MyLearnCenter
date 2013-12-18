//
//  SLPDFRenderView.h
//  MyLearnCenter
//
//  Created by Sonic Lin on 12/15/13.
//  Copyright (c) 2013 Sonic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPDFRenderView : UIView{
    CGPDFDocumentRef pdfDocument;
    int pageNumber;
}

@property (nonatomic,assign) CGPDFDocumentRef pdfDocument;

@property (nonatomic,assign) int pageNumber;
@end
