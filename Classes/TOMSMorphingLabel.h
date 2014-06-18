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
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat characterAnimationOffset;
@property (nonatomic, assign) CGFloat characterShrinkFactor;

@end
