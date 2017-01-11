//
//  TJLongImgCut.m
//  TJLongImg
//
//  Created by TanJian on 17/1/10.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJLongImgCut.h"


@implementation TJLongImgCut

+ (instancetype)manager {
    static TJLongImgCut *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TJLongImgCut new];
    });
    return instance;
}

- (UIImage *)screenShotForView:(UIView *)view screenRect:(CGSize )screenSize imageKB:(NSInteger)size {
    
    UIImage* image = nil;
    /*
     *UIGraphicsBeginImageContextWithOptions有三个参数
     *size    bitmap上下文的大小，就是生成图片的size
     *opaque  是否不透明，当指定为YES的时候图片的质量会比较好
     *scale   缩放比例，指定为0.0表示使用手机主屏幕的缩放比例
     */
    
    CGSize imageSize = view.bounds.size;
    if (screenSize.width == 0 && screenSize.height == 0) {
        
    }else if (screenSize.height <= imageSize.height && screenSize.width <= imageSize.width) {
        imageSize = screenSize;
    }else if (screenSize.height <= imageSize.height){
        imageSize = CGSizeMake(imageSize.width, screenSize.height);
    }else if (screenSize.width <= imageSize.width){
        imageSize = CGSizeMake(screenSize.width, imageSize.height);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    //此处我截取的是TableView的header.
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

- (UIImage *)screenShotForTableView:(UITableView *)tableView screenRect:(UIEdgeInsets )screenEdge imageKB:(NSInteger)size{
    
    UIImage* image = nil;
    
    CGSize imageSize = tableView.contentSize;
    if (screenEdge.bottom >= 0 && screenEdge.right >= 0) {
        imageSize = CGSizeMake(imageSize.width-screenEdge.right, imageSize.height-screenEdge.bottom);
    }else if (screenEdge.bottom >= 0){
        imageSize = CGSizeMake(imageSize.width, imageSize.height-screenEdge.bottom);
    }else if (screenEdge.right >= 0){
        imageSize = CGSizeMake(imageSize.width-screenEdge.right, imageSize.height);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize , YES, 0.0);
    
    //保存tableView当前的偏移量
    CGPoint savedContentOffset = tableView.contentOffset;
    CGRect saveFrame = tableView.frame;
    
    //将tableView的偏移量设置为(0,0)
    tableView.contentOffset = CGPointZero;
    tableView.frame = CGRectMake(0, 0, tableView.contentSize.width, tableView.contentSize.height);
    
    //在当前上下文中渲染出tableView
    [tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复tableView的偏移量
    tableView.contentOffset = savedContentOffset;
    tableView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}


- (UIImage *)screenShotForCollectionView:(UICollectionView *)collectionView screenRect:(UIEdgeInsets )screenEdge imageKB:(NSInteger)size{
    
    UIImage* image = nil;
    
    CGSize imageSize = collectionView.contentSize;
    if (screenEdge.bottom >= 0 && screenEdge.right >= 0) {
        imageSize = CGSizeMake(imageSize.width-screenEdge.right, imageSize.height-screenEdge.bottom);
    }else if (screenEdge.bottom >= 0){
        imageSize = CGSizeMake(imageSize.width, imageSize.height-screenEdge.bottom);
    }else if (screenEdge.right >= 0){
        imageSize = CGSizeMake(imageSize.width-screenEdge.right, imageSize.height);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    
    //保存tableView当前的偏移量
    CGPoint savedContentOffset = collectionView.contentOffset;
    CGRect saveFrame = collectionView.frame;
    
    //将tableView的偏移量设置为(0,0)
    collectionView.contentOffset = CGPointZero;
    collectionView.frame = CGRectMake(0, 0, collectionView.contentSize.width, collectionView.contentSize.height);
    
    //在当前上下文中渲染出tableView
    [collectionView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复tableView的偏移量
    collectionView.contentOffset = savedContentOffset;
    collectionView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }

}

 
- (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage directionType:(directionType)direction{
    
    CGSize size;
    switch (direction) {
        case directionTypeUpAndDown:
        {
            size.width = masterImage.size.width;
            size.height = masterImage.size.height + slaveImage.size.height;
        }
            break;
        case directionTypeLeftAndRight:
        {
            size.width = masterImage.size.width+slaveImage.size.width;
            size.height = masterImage.size.height;
        }
            break;
        default:
            break;
    }
    
     
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    switch (direction) {
        case directionTypeUpAndDown:
        {
            //Draw masterImage
            [masterImage drawInRect:CGRectMake(0, 0, masterImage.size.width, masterImage.size.height)];
            
            //Draw slaveImage
            [slaveImage drawInRect:CGRectMake(0, masterImage.size.height, masterImage.size.width, slaveImage.size.height)];
        }
            break;
        case directionTypeLeftAndRight:
        {
            //Draw masterImage
            [masterImage drawInRect:CGRectMake(0, 0, masterImage.size.width, masterImage.size.height)];
            
            //Draw slaveImage
            [slaveImage drawInRect:CGRectMake(masterImage.size.width,0, masterImage.size.width, slaveImage.size.height)];

        }
            break;
        default:
            break;
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
     
    UIGraphicsEndImageContext();
    
    if (resultImage != nil) {
        return resultImage;
    }else {
        return nil;
    }
    
    
}

@end
