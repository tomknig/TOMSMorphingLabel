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
@property (atomic, assign) BOOL isAnimating;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, strong) NSArray *textValues;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.idx = 0;
    self.isAnimating = YES;
    
    CGRect frame = CGRectMake(0, 42, self.view.frame.size.width, 42);
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc] initWithFrame:frame];
    
    label.font = [UIFont systemFontOfSize:32];
    label.textColor = [UIColor colorWithRed:0.102 green:0.839 blue:0.992 alpha: 1];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [self toggleTextForLabel:label];
}

#pragma mark - toggling text

- (NSArray *)textValues
{
    if (!_textValues) {
        _textValues = @[
                        @"开",
                        @"开源",
                        @"2⃣3⃣4⃣",
                        @"1⃣2⃣3⃣4⃣5⃣",
                        @"Swift",
                        @"Swiftilicious",
                        @"delicious"
                        ];
    }
    return _textValues;
}

- (void)setIdx:(NSInteger)idx
{
    _idx = MAX(0, MIN(idx, idx % [self.textValues count]));
}

- (void)toggleTextForLabel:(TOMSMorphingLabel *)label
{
    [label setText:self.textValues[self.idx++] animated:self.isAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self toggleTextForLabel:label];
    });
}

#pragma mark - toggling animating

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // User tapped view
    self.isAnimating = !self.isAnimating;
}

@end
