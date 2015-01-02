//
//  NSString+Morphing.m
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import "NSString+Morphing.h"

NSString * const kTOMSDictionaryKeyMergedString = @"mergedString";
NSString * const kTOMSDictionaryKeyAdditionRanges = @"additionRanges";
NSString * const kTOMSDictionaryKeyDeletionRanges = @"deletionRanges";

@implementation NSString (Morphing)

- (NSUInteger)toms_unicodeLength
{
    return [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] / 4;
}

- (NSDictionary *)toms_mergeIntoString:(NSString *)string
{
    return [self toms_mergeIntoString:string
                      lookAheadRadius:6];
}

- (NSDictionary *)toms_mergeIntoString:(NSString *)alien
                       lookAheadRadius:(NSUInteger)lookAheadRadius
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSMutableString *mergeString = [[NSMutableString alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    __block NSUInteger alienIdx = 0;
    __block NSUInteger alienLength = [alien length];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *ownChar, NSRange ownSubstringRange,
                                       NSRange ownEnclosingRange, BOOL *ownStop)
     {
         __block NSRange mergeRange = NSMakeRange(0, 0);
         __block BOOL isMatchingCharFound = NO;
         __block NSRange lastAlienSubstringRange;
         
         [alien enumerateSubstringsInRange:NSMakeRange(alienIdx, alienLength - alienIdx)
                                   options:NSStringEnumerationByComposedCharacterSequences
                                usingBlock:^(NSString *alienChar, NSRange alienSubstringRange,
                                             NSRange alienEnclosingRange, BOOL *alienStop)
          {
              if (mergeRange.length == 0) {
                  mergeRange = alienSubstringRange;
              } else {
                  mergeRange.length += alienSubstringRange.length;
              }
              
              if ([ownChar isEqualToString:alienChar]) {
                  [mergeString appendString:[alien substringWithRange:mergeRange]];
                  alienIdx = mergeRange.location + mergeRange.length;
                  isMatchingCharFound = YES;
                  lastAlienSubstringRange = alienSubstringRange;
                  *alienStop = YES;
              }
              
              if (mergeRange.length >= lookAheadRadius) {
                  *alienStop = YES;
              }
          }];
         
         if (isMatchingCharFound) {
             if (mergeRange.length - lastAlienSubstringRange.length > 0) {
                 NSRange deletionRange = NSMakeRange([mergeString length] - mergeRange.length, mergeRange.length - lastAlienSubstringRange.length);
                 [deletionRanges addObject:[NSValue valueWithRange:deletionRange]];
             }
         } else {
             NSRange additionRange = ownSubstringRange;
             additionRange.location = [mergeString length];
             [additionRanges addObject:[NSValue valueWithRange:additionRange]];
             [mergeString appendString:ownChar];
         }
     }];
    
    if (alienIdx < alienLength) {
        NSRange deletionRange = NSMakeRange([mergeString length], alienLength - alienIdx);
        [deletionRanges addObject:[NSValue valueWithRange:deletionRange]];
        [mergeString appendString:[alien substringWithRange:NSMakeRange(alienIdx, alienLength - alienIdx)]];
    }
    
    result[kTOMSDictionaryKeyMergedString] = mergeString;
    result[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    result[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    return result;
}

@end
