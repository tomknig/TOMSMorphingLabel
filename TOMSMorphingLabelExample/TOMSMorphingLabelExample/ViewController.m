//
//  ViewController.m
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "ViewController.h"
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>

@interface ViewController ()
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, strong) NSArray *textValues;
@property (nonatomic, strong) TOMSMorphingLabel *label;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.idx = 0;
    
    CGRect frame = CGRectMake(0, 42, self.view.frame.size.width, 42);
    self.label = [[TOMSMorphingLabel alloc] initWithFrame:frame];
    
    self.label.font = [UIFont systemFontOfSize:32];
    self.label.textColor = [UIColor colorWithRed:0.102 green:0.839 blue:0.992 alpha: 1];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.label];
    [self toggleTextForLabel:self.label];
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

- (void)toggleTextForLabel:(UILabel *)label
{
    label.text = self.textValues[self.idx++];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self toggleTextForLabel:label];
    });
}

#pragma mark - toggling animating

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // User tapped view
    self.label.shouldAnimate = !self.label.shouldAnimate;
}

@end
