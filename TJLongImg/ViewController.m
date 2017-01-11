//
//  ViewController.m
//  TJLongImg
//
//  Created by TanJian on 17/1/10.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "ViewController.h"
#import "TJLongImgCut.h"


#define KScreenSize [UIScreen mainScreen].bounds.size


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *normalView;

@property (nonatomic,strong) UIImageView *showView;
@property (nonatomic,strong) UIButton *jointBtn;

@end

@implementation ViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView *)normalView{
    if (!_normalView) {
        _normalView = [[UIView alloc]initWithFrame:self.view.bounds];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:_normalView.frame];
        imgView.image = [UIImage imageNamed:@"BG13"];
        [_normalView addSubview:imgView];
    }
    return _normalView;
}

-(UIImageView *)showView{
    if (!_showView) {
        _showView = [[UIImageView alloc]init];
    }
    return _showView;
}

-(UIButton *)jointBtn{
    if (!_jointBtn) {
        _jointBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenSize.width-150, 80, 150, 35)];
        _jointBtn .backgroundColor = [UIColor redColor];
        [_jointBtn setTitle:@"拼接两张图" forState:UIControlStateNormal];
        _jointBtn.tag = 999;
        [_jointBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jointBtn;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.normalView];
    self.normalView.hidden = YES;
    
    UIButton *viewChangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenSize.width-150, 40, 150, 35)];
    viewChangeBtn.tag = 0;
    viewChangeBtn.backgroundColor = [UIColor greenColor];
    [viewChangeBtn setTitle:@"切换到普通View" forState:UIControlStateNormal];
    [viewChangeBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewChangeBtn];
    
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((KScreenSize.width-100)*0.5, KScreenSize.height - 80, 100, 30)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"截图" forState:UIControlStateNormal];
    button.tag = 0;
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)changeView:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
        {
            self.normalView.hidden = NO;
            self.tableView.hidden = YES;
            sender.tag = 1;
            [sender setTitle:@"切换到tableView" forState:UIControlStateNormal];
            
            [self.view addSubview:self.jointBtn];
        }
            break;
        case 1:
        {
            self.normalView.hidden = YES;
            self.tableView.hidden = NO;
            sender.tag = 0;
            [sender setTitle:@"切换到普通View" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

-(void)clickBtn:(UIButton *)sender{
    
#warning 获取截取图片或拼接图片真正其实一句话，其他代码则为demo效果需要-_-
    
    UIImage *img;
    
    if (sender.tag == 999) {
        
        img = [[TJLongImgCut manager] addSlaveImage:[UIImage imageNamed:@"BG13"] toMasterImage:[UIImage imageNamed:@"bg11"] directionType:directidirectionTypeLeftAndRight];
        
        self.showView.frame = CGRectMake(0, 0, KScreenSize.width*0.4, KScreenSize.height*0.8);
        self.showView.image = img;
        
    }else{
        if (self.normalView.hidden) {
            img = [[TJLongImgCut manager] screenShotForTableView:self.tableView screenRect:UIEdgeInsetsMake(0, 0, 88, 40) imageKB:1024];//获取图片小于等于1M
            
            self.showView.frame = CGRectMake(0, 0, KScreenSize.width*0.4, 60*44*0.4);
            self.showView.image = img;
            
        }else{
            img = [[TJLongImgCut manager] screenShotForView:self.normalView screenRect:CGSizeZero imageKB:1024];
            
            self.showView.frame = CGRectMake(0, 0, KScreenSize.width*0.4, KScreenSize.height*0.4);
            self.showView.image = img;
        }
    }
    
    
    
    if (![self.view.subviews containsObject:self.showView]) {
        [self.view addSubview:self.showView];
    }
    
    [self alert:img];
}

-(void)alert:(UIImage *)image{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"是否保存到相册"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
        
    }];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"IMG_4"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行",indexPath.row];

    return cell;
    
}



@end
