//
//  AYTextLabelCollectionView.h
//  TextExplosion
//
//  Created by Alex Yu on 30/10/2016.
//  Copyright © 2016 Alex Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYTextLabelCollectionView : UICollectionView

@property (nonatomic, strong) NSArray<NSString *> *words;
@property (nonatomic, strong, readonly) NSArray<NSString *> *selectedWords;

@end
