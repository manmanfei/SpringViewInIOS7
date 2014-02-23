//
//  FFSpringCollViewFlowlayout.m
//  iOS7中弹簧式列表的制作
//
//  Created by 王小飞您 on 14-2-23.
//  Copyright (c) 2014年 王小飞. All rights reserved.
//

#import "FFSpringCollViewFlowlayout.h"
@interface FFSpringCollViewFlowlayout()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end
@implementation FFSpringCollViewFlowlayout

// prepareLayout将在CollectionView进行排版的时候被调用
- (void)prepareLayout
{
    [super prepareLayout];
    
    if (!self.animator) {
        self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        // 取出内容区域尺寸
        CGSize contentSize = [self collectionViewContentSize];
        
        // 取出所有的items
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        // 遍历，为每个LayoutAttribute的中点上，添加附着件Attachment，锚点
        for (UICollectionViewLayoutAttributes *item in items) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
            
            spring.length = 0;
            spring.damping = 0.5;
            spring.frequency = 0.8;
            
            [self.animator addBehavior:spring];
        }
    }
}

#pragma 通过-initWithCollectionViewLayout:进行初始化后，这个UIDynamicAnimator实例便和我们的layout进行了绑定，之后这个layout对应的attributes都应该由绑定的UIDynamicAnimator的实例给出。

// 根据rect布局整体的的Attribute
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.animator itemsInRect:rect];
}

// 布局每行的Attribute
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}


#pragma 每次layout的bounds发生变化的时候，collectionView都会询问这个方法是否需要为这个新的边界和更新layout。一般情况下只要layout没有根据边界不同而发生变化的话，这个方法直接不做处理地返回NO，表示保持现在的layout即可，而每次bounds改变时这个方法都会被调用的特点正好可以满足我们更新锚点的需求，因此我们可以在这里面完成锚点的更新。

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    
    // 计算滚动的距离
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    // 取出屏幕上触摸点的坐标
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    // 遍历出所有动作，每个动作动绑定着唯一的item（LayoutAttribute）
    for (UIAttachmentBehavior *spring in self.animator.behaviors) {
        // 取出每个item上绑定锚点的坐标
        CGPoint anchorPoint = spring.anchorPoint;
        
        // int abs(int i);                   // 处理int类型的取绝对值
        // double fabs(double i);           //处理double类型的取绝对值
        // float fabsf(float i);           //处理float类型的取绝对值
        
        // 计算触摸点到锚点的距离
        CGFloat distanceFromTouch = fabsf(anchorPoint.y - touchLocation.y);
        
        // 滚动的阻力系数
        CGFloat scrollResistance = distanceFromTouch / [UIScreen mainScreen].bounds.size.height;
        
        // 这一个动作可能涉及好多item，这里只绑定了一个，所以取出第一个。
        // 更新锚点的位置
        UICollectionViewLayoutAttributes *item = [spring.items firstObject];
        CGPoint center = item.center;
        
        center.y += (scrollDelta > 0) ? MIN(scrollDelta, scrollDelta * scrollResistance)
                                      : MAX(scrollDelta, scrollDelta * scrollResistance);
        
        item.center = center;
        
        [self.animator updateItemUsingCurrentState:item];
    }
    
    return NO;
    
    
    
}

@end
