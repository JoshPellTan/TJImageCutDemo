//
//  TJLongImgCut.h
//  TJLongImg
//
//  Created by TanJian on 17/1/10.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, directionType) {
    directionTypeUpAndDown = 0,
    directionTypeLeftAndRight = 1,
};

@interface TJLongImgCut : UIView

/*
 使用：
    1.导入#import "TJLongImgCut.h"
    2.用screenShotForTableView:screenRect:imageSize:或者screenShotForCollectionView:screenRect:imageSize:方法拿到截取的长图
 
    easy！！！
 
 */

+ (instancetype)manager;

/*
    参数说明
    1.view:你想截取的普通view
    2.screenSize:你想截取的大小，默认是整个view,若传入宽高小于view宽高则会舍弃view的右边或下边部分
    3.size:你想要的截图的大小，单位是KB
 */

- (UIImage *)screenShotForView:(UIView *)view screenRect:(CGSize )screenSize imageKB:(NSInteger)size;


/*
    参数说明
    1.tableView或collectionView：你想要截图的view
    2.screenEdge:你想截取的长图距view的各边距离(只有右边和下边起作用)，默认是整个tableView,若传入宽高小于tableView宽高则会舍弃tableView的右边或下边部分
    3.size：你想得到的图片大小，单位是KB
 */

/*截取tableView长图*/
- (UIImage *)screenShotForTableView:(UITableView *)tableView screenRect:(UIEdgeInsets )screenEdge imageKB:(NSInteger)size;

/*截取collectionView长图*/
- (UIImage *)screenShotForCollectionView:(UICollectionView *)collectionView screenRect:(UIEdgeInsets )screenEdge imageKB:(NSInteger)size;


/*
 masterImage  主图片，生成的图片的宽度为masterImage的宽度
 slaveImage   从图片，拼接在masterImage的下面
 */

- (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage directionType:(directionType)direction;

@end
