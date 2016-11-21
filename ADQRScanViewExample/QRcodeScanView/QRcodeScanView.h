//
//  QRcodeScanView.h
//  TestCode
//
//  Created by bjwltiankong on 15/9/22.
//  Copyright © 2015年 bjwltiankong. All rights reserved.
//  

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QRcodeScanViewScanLineAnimaitonStyleNone,
    QRcodeScanViewScanLineAnimaitonStyleNormal
} QRcodeScanViewScanLineAnimaitonStyle;

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

/**可视区域背景图片*/
@property (nonatomic, strong)  UIImage *visibleRectImage;

/**可视区域区域(默认与可视区域相同，如果需要微调请设置)*/
@property (nonatomic, assign) CGRect visibleImageViewFrame;

/**扫描线图片*/
@property (nonatomic, strong) UIImage *scanLineImage;

/**扫描线 (默认是剧中的，如果要做动画或者微调，请设置)*/
@property (nonatomic, assign) CGRect scanLineImageViewFrame;

/**扫描线动画模式*/
@property (nonatomic, assign) QRcodeScanViewScanLineAnimaitonStyle scanLineAnimaitonStyle;

/**
 frame：控件的frame
 visibleRect：可是区域的frame
 */
+ (instancetype)scanViewWithFrame:(CGRect)frame visibleRect:(CGRect)visibleRect;

- (void)startScan;

- (void)stopScan;

@end
