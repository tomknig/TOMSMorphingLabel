//
//  ViewController.m
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "ViewController.h"
#import <TOMSMorphingLabel.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *morphingLabel;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, strong) NSArray *textValues;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _idx = 0;
    [self toggleText];
}

#pragma mark - toggling text

- (NSArray *)textValues
{
    if (!_textValues) {
        _textValues = @[
                        @"Swift",
                        @"Swiftilicious",
                        @"delicious",
                        @"开",
                        @"开源",
                        @"2⃣3⃣4⃣",
                        @"1⃣2⃣3⃣4⃣5⃣",
                        @""
                        ];
    }
    return _textValues;
}

- (void)setIdx:(NSInteger)idx
{
    _idx = MAX(0, MIN(idx, idx % [self.textValues count]));
}

- (void)toggleText
{
    self.morphingLabel.text = self.textValues[self.idx++];

    [self performSelector:@selector(toggleText)
               withObject:nil
               afterDelay:2];
}

@end
