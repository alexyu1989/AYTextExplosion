//
//  ViewController.m
//  TextExplosion
//
//  Created by Alex Yu on 20/10/2016.
//  Copyright © 2016 Alex Yu. All rights reserved.
//

#import "AYTextExplosionViewController.h"
#import "AYTextLabelCollectionView.h"
#import "NSString+Extension.h"

@interface AYTextExplosionViewController ()

@property (weak, nonatomic) IBOutlet AYTextLabelCollectionView *wordsCollectionView;

@property (nonatomic, copy) NSString *analyzedString;

@end

@implementation AYTextExplosionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wordsCollectionView setAllowsMultipleSelection:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyzeCopiedString) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)analyzeCopiedString {
    NSString *copiedString = [UIPasteboard generalPasteboard].string;
    
    if ([copiedString isEqualToString:self.analyzedString]) {
        return;
    } else {
        self.analyzedString = copiedString;
    }
    
    if (copiedString.length) {
        NSArray *words = [self localSegmentWords:copiedString];
        
        [self.wordsCollectionView setWords:words];
    }
}

- (NSArray *)localSegmentWords:(NSString *)string {
    NSArray *words = [string segment:PINSegmentationOptionsKeepSymbols];
    return words;
}

#pragma mark - Get Info

- (NSString *)selectedStringsWithSeperator:(NSString *)seperator {
    
    NSArray *words = self.wordsCollectionView.selectedWords;
    
    NSString *result = @"";
    
    for (NSString *word in words.objectEnumerator) {
        result = [result stringByAppendingString:word];
        if (seperator.length) {
            result = [result stringByAppendingString:seperator];
        }
    }
    
    if (seperator.length) {
        if (words.count) {
            result = [result substringToIndex:result.length - seperator.length];
        }
    }
    
    return result;
}

#pragma mark - Buttons clicked

- (IBAction)onCopyButtonClicked:(UIButton *)sender {
    NSString *string = [self selectedStringsWithSeperator:nil];
    [[UIPasteboard generalPasteboard] setString:string];
}

- (IBAction)onSearchButtonClicked:(UIButton *)sender {
    NSString *text = [self selectedStringsWithSeperator:@"+"];
    NSString *urlString = [NSString stringWithFormat:@"http://www.google.cn/search?q=%@&ie=UTF-8&oe=UTF-8", text];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        //
    }];
}

- (IBAction)onShareButtonClicked:(UIButton *)sender {
    NSString *string = [self selectedStringsWithSeperator:nil];
    UIActivityViewController *AVC = [[UIActivityViewController alloc] initWithActivityItems:@[string] applicationActivities:nil];
    [self presentViewController:AVC animated:YES completion:nil];
}



@end
