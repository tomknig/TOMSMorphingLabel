//
//  NSString+Morphing.m
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "NSString+Morphing.h"

@implementation NSString (Morphing)

- (NSDictionary *)toms_mergeIntoString:(NSString *)string
{
    return [self toms_mergeIntoString:string
                      lookAheadRadius:6];
}

- (NSDictionary *)toms_mergeIntoString:(NSString *)string
                       lookAheadRadius:(NSUInteger)lookAheadRadius
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSMutableString *mergeString = [[NSMutableString alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    __block int startLocation, endLocation;
    __block int ownIdx = 0, numberOfInsertions = 0;
    
    [self toms_enumerateCharacters:^(BOOL *stopOwnEnumeration, const unichar ownChar, NSUInteger index){
        startLocation = -1;
        endLocation = -1;
        
        [string toms_enumerateCharacters:^(BOOL *stopAlienEnumeration, const unichar alienChar, NSUInteger alienIdx){
            if (ownIdx <= alienIdx++) {
                if (startLocation < 0) {
                    startLocation = ownIdx;
                }
                
                if (ownChar == alienChar) {
                    endLocation = alienIdx;
                    
                    [mergeString appendString:[string substringWithRange:NSMakeRange(startLocation, endLocation - startLocation)]];
                    ownIdx = alienIdx;
                    *stopAlienEnumeration = YES;
                }
                
                if (alienIdx - ownIdx >= lookAheadRadius) {
                    *stopAlienEnumeration = YES;
                }
            }
        }];
        
        if (endLocation >= 0) {
            if (endLocation - startLocation - 1 > 0) {
                NSRange deletionRange = NSMakeRange(startLocation + numberOfInsertions, endLocation - startLocation - 1);
                [deletionRanges addObject:[NSValue valueWithRange:deletionRange]];
            }
        } else {
            NSRange additionRange = NSMakeRange(mergeString.length, 1);
            [additionRanges addObject:[NSValue valueWithRange:additionRange]];
            [mergeString appendFormat:@"%c", ownChar];
            ++numberOfInsertions;
        }
    }];
    
    
    NSUInteger alienStringLength = string.length;
    if (ownIdx < alienStringLength) {
        NSUInteger deletionLength = alienStringLength - ownIdx;
        NSRange deletionRange = NSMakeRange(mergeString.length, deletionLength);
        [deletionRanges addObject:[NSValue valueWithRange:deletionRange]];
        [mergeString appendString:[string substringWithRange:NSMakeRange(ownIdx, deletionLength)]];
    }
    
    result[kTOMSDictionaryKeyMergedString] = mergeString;
    result[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    result[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    return result;
}


-(void)toms_enumerateCharacters:(void(^)(BOOL *stop, const unichar aChar, NSUInteger index))enumerationBlock
{
    const unichar *chars = CFStringGetCharactersPtr((__bridge CFStringRef)self);
    BOOL stop = NO;
    
    if (chars != NULL) {
        NSUInteger index = 0;
        while (*chars && !stop) {
            enumerationBlock(&stop, *chars, index);
            chars++;
            index++;
        }
    } else {
        SEL sel = @selector(characterAtIndex:);
        unichar (*charAtIndex)(id, SEL, NSUInteger) = (typeof(charAtIndex)) [self methodForSelector:sel];
        for (NSUInteger i = 0; i < self.length; i++) {
            const unichar c = charAtIndex(self, sel, i);
            enumerationBlock(&stop, c, i);
            if (stop) {
                break;
            }
        }
    }
}

@end
