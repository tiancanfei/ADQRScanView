//
//  QRcodeScanView.h
//  TestCode
//
//  Created by bjwltiankong on 15/9/22.
//  Copyright © 2015年 bjwltiankong. All rights reserved.
//  

#import <UIKit/UIKit.h>

@class QRcodeScanView;

@protocol QRcodeScanViewDelegate <NSObject>

- (void)scanView:(QRcodeScanView *)scanView didFinishedScanWithCodeString:(NSString *)codeString;

@end

@interface QRcodeScanView : UIView

@property (nonatomic, weak) id<QRcodeScanViewDelegate> delegate;

/**可视区域*/
@property (nonatomic, assign)  CGRect visibleRect;

/**背景
 改变背景颜色的时候推荐使用带alph值的颜色
 [[UIColor clearColor] colorWithAlphaComponent:0]
 */
@property (nonatomic, strong) UIColor *previewBackgroundColor;

/**可是区域背景*/
@property (nonatomic, strong)  UIImage *visibleRectImage;


/**
 frame：控件的frame
 visibleRect：可是区域的frame
 */
+ (instancetype)scanViewWithFrame:(CGRect)frame visibleRect:(CGRect)visibleRect;

- (void)startScan;

- (void)stopScan;

@end
