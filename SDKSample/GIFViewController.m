//
//  GIFViewController.m
//  SDKSample
//
//  Created by XingJun on 9/18/15.
//
//

#import "WXApi.h"
#import "GIFViewController.h"

@interface GIFViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *files;
@end

@implementation GIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *m = @[].mutableCopy;
    for (int i = 221; i<241; i++) {
        NSString *file = [NSString stringWithFormat:@"%d@2x",i];
        [m addObject:file];
    }
    self.files = [NSArray arrayWithArray:m];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendGif:(int)index {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.files[index] ofType:@"gif"];

    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *imageSS = [[UIImage alloc] initWithContentsOfFile:filePath];
    [message setThumbImage:imageSS];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    
    [WXApi sendReq:req];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *i = @"gif";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:i ];
    UIImageView *im ;
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        im = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        [cell addSubview:im];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:self.files[indexPath.row] ofType:@"gif"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    im.image = image;
    
    UILabel *label = [UILabel new];
    [label setFrame: CGRectMake(30, 5, 80, 70)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setText:[NSString stringWithFormat:@"%d",indexPath.row]];
    [cell.contentView addSubview:label];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self sendGif:indexPath.row];
}
@end
