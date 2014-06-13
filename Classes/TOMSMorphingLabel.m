//
//  TOMSMorphingLabel.m
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "TOMSMorphingLabel.h"

#define kTOMSKernPercentageAttributeName @"kTOMSKernPercentageAttributeName"

@interface TOMSMorphingLabel ()

@property (readonly, nonatomic, assign, getter=isAnimating) BOOL animating;
@property (readonly, nonatomic, assign) NSUInteger numberOfAttributionStages;
@property (readonly, nonatomic, strong) NSArray *attributionStages;

@end

@implementation TOMSMorphingLabel
@synthesize attributionStages = _attributionStages;

#pragma mark - initialization

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self designatedInitialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self designatedInitialization];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self designatedInitialization];
    }
    
    return self;
}

- (void)designatedInitialization
{
    self.animationDuration = 0.37;
    self.characterAnimationOffset = 0.25;
    self.characterShrinkFactor = 4;
    self.fps = 60;
}

#pragma mark - setters

- (void)numberOfAttributionStagesShouldChange
{
    _numberOfAttributionStages = (NSInteger) (_fps * _animationDuration);
    _attributionStages = nil;
}

- (void)setFps:(NSUInteger)fps
{
    if (!self.isAnimating) {
        _fps = fps;
        [self numberOfAttributionStagesShouldChange];
    }
}

- (void)setAnimationDuration:(CGFloat)animationDuration
{
    if (!self.isAnimating) {
        _animationDuration = animationDuration;
        [self numberOfAttributionStagesShouldChange];
    }
}

#pragma mark - getters

- (CGFloat)easedValue:(CGFloat)p
{
    if (p < 0.5) {
        return 2 * p * p;
    }
    return (-2 * p * p) + (4 * p) - 1;
}

- (UIColor *)textColorWithAlpha:(CGFloat)alpha
{
    return [self.textColor colorWithAlphaComponent:alpha];
}

- (UIFont *)fontForScale:(CGFloat)scale
{
    return [UIFont fontWithName:self.font.fontName size:(self.font.pointSize * scale)];
}

- (NSArray *)attributionStages
{
    NSMutableArray *attributionStages = [[NSMutableArray alloc] initWithCapacity:self.numberOfAttributionStages];
    
    CGFloat minFontSize = self.font.pointSize / self.characterShrinkFactor;
    CGFloat fontRatio = minFontSize / self.font.pointSize;
    CGFloat fontPadding = 1 - fontRatio;
    
    CGFloat progress, fontScale;
    UIColor *color;
    
    for (int i = 0; i < self.numberOfAttributionStages; i++) {
        NSMutableDictionary *attributionStage = [[NSMutableDictionary alloc] init];
        
        progress = [self easedValue:(i / (self.numberOfAttributionStages - 1))];
        color = [self textColorWithAlpha:progress];
        attributionStage[NSForegroundColorAttributeName] = color;
        
        fontScale = fontRatio + progress * fontPadding;
        attributionStage[NSFontAttributeName] = [self fontForScale:fontScale];
        
        attributionStage[kTOMSKernPercentageAttributeName] = [NSNumber numberWithFloat:1 - progress];
        
        [attributionStages addObject:attributionStage];
    }
    
    return attributionStages;
}

@end
