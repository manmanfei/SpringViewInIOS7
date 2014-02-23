//
//  FFViewController.m
//  iOS7中弹簧式列表的制作
//
//  Created by 王小飞您 on 14-2-21.
//  Copyright (c) 2014年 王小飞. All rights reserved.
//
/**
 而如果我们在TableView向数据源请求数据之前使用-registerNib:forCellReuseIdentifier:方法为@“MY_CELL_ID”注册过nib的话，就可以省下每次判断并初始化cell的代码，要是在重用队列里没有可用的cell的话，runtime将自动帮我们生成并初始化一个可用的cell。
 这个特性很受欢迎，因此在UICollectionView中Apple继承使用了这个特性，并且把其进行了一些扩展。使用以下方法进行注册：
 -registerClass:forCellWithReuseIdentifier:
 -registerClass:forSupplementaryViewOfKind:withReuseIdentifier:
 -registerNib:forCellWithReuseIdentifier:
 -registerNib:forSupplementaryViewOfKind:withReuseIdentifier:
 相比UITableView有两个主要变化：一是加入了对某个Class的注册，这样即使不用提供nib而是用代码生成的view也可以被接受为cell了；二是不仅只是cell，Supplementary View也可以用注册的方法绑定初始化了。在对collection view的重用ID注册后，就可以像UITableView那样简单的写cell配置了：
 */

#import "FFViewController.h"
#import "FFSpringCollViewFlowlayout.h"
#import "UIColor+MLPFlatColors.h"

@interface FFViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) FFSpringCollViewFlowlayout *layout;
@end

static NSString *Id = @"collectionViewCellId";

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化collectionview的布局类
    self.layout = [[FFSpringCollViewFlowlayout alloc] init];
    self.layout.itemSize = CGSizeMake(self.view.bounds.size.width, 44);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    // 注册cell 这样在重用队里没有可用cell runtime会自动生成初始化一个可用的cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:Id];
    
    collectionView.dataSource = self;
    
    [self.view insertSubview:collectionView atIndex:0];
    
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 这里不需要检测初始化cell了，因为前面已经注册了cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Id forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor randomFlatColor];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
