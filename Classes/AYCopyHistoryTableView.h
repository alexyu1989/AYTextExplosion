//
//  AYCopyHistoryTableView.h
//  TextExplosion
//
//  Created by Alex Yu on 2/11/2016.
//  Copyright © 2016 Alex Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AYSelectCopiedStringAction)(NSString *copiedString);

@interface AYCopyHistoryTableView : UITableView

- (void)setSelectAction:(AYSelectCopiedStringAction)action;
- (void)addCopiedString:(NSString *)string;

@end
