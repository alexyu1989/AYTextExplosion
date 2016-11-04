//
//  AYCopyHistoryTableView.m
//  TextExplosion
//
//  Created by Alex Yu on 2/11/2016.
//  Copyright © 2016 Alex Yu. All rights reserved.
//

#import "AYCopyHistoryTableView.h"

NSString *const cellID = @"historyCell";
NSString *const historyKey = @"CopyStringHistoryArray";

@interface AYCopyHistoryTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) AYSelectCopiedStringAction selectAction;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *copiedStrings;

@end

@implementation AYCopyHistoryTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [super setDelegate:self];
    [super setDataSource:self];
    
    NSArray *copiedStrings = [[NSUserDefaults standardUserDefaults] objectForKey:historyKey];
    _copiedStrings = [copiedStrings copy];
    
    if (!_copiedStrings) {
        _copiedStrings = @[];
    }
}

#pragma mark - data process

- (void)addCopiedString:(NSString *)string {
    if (!string.length) return;
    
    for (NSString *copiedString in self.copiedStrings) {
        if ([copiedString isEqualToString:string]) {
            [[self mutableArrayValueForKey:@"copiedStrings"] removeObject:copiedString];
            break;
        }
    }
    
    [[self mutableArrayValueForKey:@"copiedStrings"] insertObject:string atIndex:0];
    
    if (self.copiedStrings.count > 10) {
        self.copiedStrings = [self.copiedStrings subarrayWithRange:NSMakeRange(0, 10)];
    }
    
    [self reloadData];
    [self syncData];
}

- (void)syncData {
    [[NSUserDefaults standardUserDefaults] setObject:self.copiedStrings forKey:historyKey];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.copiedStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *label = [cell viewWithTag:2001];
    NSString *string = self.copiedStrings[indexPath.row];
    [label setText:string];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedString = self.copiedStrings[indexPath.row];
    if (self.selectAction) {
        self.selectAction(selectedString);
    }
    
}

@end
