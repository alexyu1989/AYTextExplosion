//
//  AYTextLabelCollectionView.m
//  TextExplosion
//
//  Created by Alex Yu on 30/10/2016.
//  Copyright © 2016 Alex Yu. All rights reserved.
//

#import "AYTextLabelCollectionView.h"
#import "AYTextLabelCollectionViewLayout.h"
#import "AYLabelCollectionViewCell.h"

static NSString *const cellId = @"AYLabelCollectionViewCellIdentifier";

@interface AYTextLabelCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL canDraggingSelection;
@property (nonatomic, strong) UIPanGestureRecognizer *horizantalPanGR;
@property (nonatomic, assign) CGPoint panStartPoint;

@end

@implementation AYTextLabelCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    [super setDelegate:self];
    [super setDataSource:self];
    [super setCollectionViewLayout:[AYTextLabelCollectionViewLayout new]];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self registerClass:[AYLabelCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    _horizantalPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHorizantal:)];
    [_horizantalPanGR setDelegate:self];
    [self addGestureRecognizer:_horizantalPanGR];
    
    _canDraggingSelection = NO;
}

#pragma mark - pan gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == _horizantalPanGR) {
        CGPoint velocity = [self.horizantalPanGR velocityInView:self];
        if (fabs(velocity.y) > fabs(velocity.x)) {
            _canDraggingSelection = NO;
            return YES;
        } else {
            _canDraggingSelection = YES;
            return NO;
        }
    }
    return NO;
}

CGRect CGRectFromPoints(CGPoint p1, CGPoint p2) {
    CGRect rect = CGRectMake(MIN(p1.x, p2.x),
                             MIN(p1.y, p2.y),
                             fabs(p1.x - p2.x),
                             fabs(p1.y - p2.y));
    return rect;
}



- (void)panHorizantal:(UIPanGestureRecognizer *)sender {
    
    if (!self.canDraggingSelection) return;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [sender locationInView:self];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint endPoint = [sender locationInView:self];
            [self selelctCellsFromPoint:self.panStartPoint toPoint:(CGPoint)endPoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            break;
            
        default:
            break;
    }
}

- (void)selelctCellsFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 {
    
    NSIndexPath *path1 = [self indexPathForItemAtPoint:p1];
    NSIndexPath *path2 = [self indexPathForItemAtPoint:p2];
    
    if (!path1) {
        return;
    }
    
    if (!path2) {
        return;
    }
    
    NSMutableArray *indexToSelect = [@[] mutableCopy];
    
    if (path1.item <= path2.item) {
        for (NSUInteger i = path1.item; i<=path2.item; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
            [indexToSelect addObject:path];
        }
    }
    
    for (NSIndexPath *visiblePath in self.indexPathsForVisibleItems) {
        BOOL shouldSelect = [indexToSelect containsObject:visiblePath];
        if (shouldSelect) {
            [self selectItemAtIndexPath:visiblePath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        } else {
//            [self deselectItemAtIndexPath:visiblePath animated:NO];
        }
    }
}

- (void)setWords:(NSArray<NSString *> *)words {
    _words = words;
    [self reloadData];
    return;
}

- (NSArray<NSString *> *)selectedWords {
    
    NSMutableArray *words = [@[] mutableCopy];
    
    NSArray *indexPaths = self.indexPathsForSelectedItems;
    
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        if (obj1.item < obj2.item) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    for (NSIndexPath *indexPath in indexPaths) {
        NSString *word = self.words[indexPath.item];
        [words addObject:word];
    }
    return [words copy];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.words.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    
    AYLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
        [CATransaction commit];;
    
    NSString *word = self.words[indexPath.item];
    cell.text = word;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AYTextLabelCollectionViewLayout *layout = (AYTextLabelCollectionViewLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    AYLabelCollectionViewCell *cell = [[AYLabelCollectionViewCell alloc] init];
    [cell setText:self.words[indexPath.item]];
    
    CGSize size = cell.intrinsicContentSize;
    size = CGSizeMake(size.width + 28, size.height + 20);
    
    size.width = MIN(size.width, maxSize.width);
    size.height = MIN(size.height, maxSize.height);
    
    return size;
}

@end
