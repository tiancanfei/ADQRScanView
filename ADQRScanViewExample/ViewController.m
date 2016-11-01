//
//  ViewController.m
//  ADQRScanViewExample
//
//  Created by bjwltiankong on 16/4/15.
//  Copyright © 2016年 bjwltiankong. All rights reserved.
//

#import "ViewController.h"
#import "QRcodeScanView.h"

@interface ViewController ()<QRcodeScanViewDelegate>

/**扫描框*/
@property (weak, nonatomic) QRcodeScanView *scanView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QRcodeScanView *scanView = [QRcodeScanView scanViewWithFrame:self.view.bounds visibleRect:CGRectMake(10, 60, 300, 200)];
    scanView.delegate = self;
    scanView.previewBackgroundColor = [UIColor redColor];
    self.scanView = scanView;
    [self.view addSubview:scanView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scanView startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanView:(QRcodeScanView *)scanView didFinishedScanWithCodeString:(NSString *)codeString
{
    NSLog(@"%@",codeString);
}


@end
