//
//  TOMSMorphingLabel.h
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Morphing.h"

@interface TOMSMorphingLabel : UILabel

@property (readonly, atomic, strong) NSString *targetText;
@property (nonatomic, assign) IBInspectable CGFloat animationDuration;
@property (nonatomic, assign) IBInspectable CGFloat characterAnimationOffset;
@property (nonatomic, assign) IBInspectable CGFloat characterShrinkFactor;
@property (nonatomic, assign, getter=isMorphingEnabled) IBInspectable BOOL morphingEnabled;

- (void)setTextWithoutMorphing:(NSString *)text;
- (void)setText:(NSString*)text withCompletionBlock:(void (^)(void))block;

@end
