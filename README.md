# ADQRScanView
iOS原生扫码控件，可以任意改变扫码尺寸，限制扫描范围
# 使用办法如下
```
#import "QRcodeScanView.h"

@interface WMMaterialsScanAddVC ()<QRcodeScanViewDelegate>

/**扫描框*/
@property (nonatomic, strong) QRcodeScanView *scanView;

@end

@implementation WMMaterialsScanAddVC

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.view addSubview:self.scanView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scanView startScan];
}

#pragma mark setter getter

- (QRcodeScanView *)scanView
{
    if (!_scanView) {
        _scanView = [[QRcodeScanView alloc] initWithFrame:self.view.bounds];
        _scanView.visibleRect = CGRectMake(20, 90, 200, 300);
        _scanView.delegate = self;
    }
    return _scanView;
}

#pragma mark - 代理

#pragma mark - ADQRcodeScanViewDelegate

- (void)scanView:(QRcodeScanView *)scanView didFinishedScanWithCodeString:(NSString *)codeString
{
    MyLog(@"%@",codeString);
}

```

