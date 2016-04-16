# ADQRScanView
iOS原生扫码控件，可以任意改变扫码尺寸，限制扫描范围
# 使用办法如下
```
@interface ViewController ()<ADQRcodeScanViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ADQRcodeScanView *scanView = [[ADQRcodeScanView alloc] initWithFrame:self.view.bounds];
    scanView.visibleRect = CGRectMake(20, 90, 200, 300);
    scanView.delegate = self;
    [self.view addSubview:scanView];
}

#pragma mark - ADQRcodeScanViewDelegate
- (void)scanView:(ADQRcodeScanView *)scanView didFinishedScanWithCodeString:(NSString *)codeString
{
    [scanView stopScan];
    NSLog(@"%@",codeString);
    [scanView startScan];
}
```

