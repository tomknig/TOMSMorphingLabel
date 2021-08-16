//
//  TOMSMorphingLabelTests.m
//  TOMSMorphingLabelTests
//
//  Created by Tom König on 13/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TOMSMorphingLabel.h>

@interface TOMSMorphingLabelTests : XCTestCase

@end

@implementation TOMSMorphingLabelTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)assertMergeOfString:(NSString *)newString intoString:(NSString *)oldString expectedResult:(NSDictionary *)expectedResult
{
    NSMutableString *expectedMergeString = expectedResult[kTOMSDictionaryKeyMergedString];
    NSMutableArray *expectedAdditionRanges = expectedResult[kTOMSDictionaryKeyAdditionRanges];
    NSMutableArray *expectedDeletionRanges = expectedResult[kTOMSDictionaryKeyDeletionRanges];
    
    NSDictionary *actualResult = [newString toms_mergeIntoString:oldString];
    NSMutableString *mergeString = actualResult[kTOMSDictionaryKeyMergedString];
    NSMutableArray *additionRanges = actualResult[kTOMSDictionaryKeyAdditionRanges];
    NSMutableArray *deletionRanges = actualResult[kTOMSDictionaryKeyDeletionRanges];
    
    XCTAssertTrue([expectedMergeString isEqualToString:mergeString], @"%@ <> %@", expectedMergeString, mergeString);
    
    XCTAssertTrue([expectedAdditionRanges count] == [additionRanges count]);
    
    XCTAssertTrue([expectedDeletionRanges count] == [deletionRanges count]);
    
    for (NSValue *expectedRangeValue in expectedAdditionRanges) {
        NSRange expectedRange = [expectedRangeValue rangeValue];
        NSUInteger numberOfMatches = 0;
        
        for (NSValue *actualRangeValue in additionRanges) {
            NSRange actualRange = [actualRangeValue rangeValue];
            if (expectedRange.location == actualRange.location && expectedRange.length == actualRange.length) {
                ++numberOfMatches;
            }
        }
        
        XCTAssertTrue(numberOfMatches == 1);
    }
    
    for (NSValue *expectedRangeValue in expectedDeletionRanges) {
        NSRange expectedRange = [expectedRangeValue rangeValue];
        NSUInteger numberOfMatches = 0;
        
        for (NSValue *actualRangeValue in deletionRanges) {
            NSRange actualRange = [actualRangeValue rangeValue];
            if (expectedRange.location == actualRange.location && expectedRange.length == actualRange.length) {
                ++numberOfMatches;
            }
        }
        
        XCTAssertTrue(numberOfMatches == 1);
    }
}

- (void)test_prefix
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"something";
    NSString *newString = @"something";
    NSString *oldString = @"some";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(4, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(5, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(6, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(7, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(8, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_suffix
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"something";
    NSString *newString = @"some";
    NSString *oldString = @"something";
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(4, 5)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_prefix_partial
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"something";
    NSString *newString = @"somethin";
    NSString *oldString = @"thing";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(3, 1)]];
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(8, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_suffix_partial
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"something";
    NSString *newString = @"thng";
    NSString *oldString = @"something";
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 4)]];
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(6, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_suffix_partial2
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"anysomething";
    NSString *newString = @"anything";
    NSString *oldString = @"something";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 1)]];
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(3, 4)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_replace
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"foobar";
    NSString *newString = @"foo";
    NSString *oldString = @"bar";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 1)]];
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(3, 3)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_fuzzy_merge
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"12345";
    NSString *newString = @"134";
    NSString *oldString = @"235";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(3, 1)]];
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(4, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_extraction
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"123";
    NSString *newString = @"2";
    NSString *oldString = @"123";
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_superset
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"123";
    NSString *newString = @"123";
    NSString *oldString = @"2";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_absorb
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"123";
    NSString *newString = @"13";
    NSString *oldString = @"123";
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_troll
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"SAWPIFTPLE";
    NSString *newString = @"SAWPIFTLE";
    NSString *oldString = @"APPLE";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(4, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(5, 1)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(6, 1)]];
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(7, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_unicode_prefix
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"开源";
    NSString *newString = @"开源";
    NSString *oldString = @"开";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_unicode_suffix
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"开源";
    NSString *newString = @"开";
    NSString *oldString = @"开源";
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(1, 1)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_unicode_superset
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"1⃣2⃣3⃣";
    NSString *newString = @"1⃣2⃣3⃣";
    NSString *oldString = @"2⃣";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 2)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(4, 2)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

- (void)test_unicode_fuzzy_merge
{
    NSMutableDictionary *expectedResult = [[NSMutableDictionary alloc] init];
    NSMutableArray *additionRanges = [[NSMutableArray alloc] init];
    NSMutableArray *deletionRanges = [[NSMutableArray alloc] init];
    
    NSString *mergeString = @"1⃣2⃣3⃣4⃣5⃣";
    NSString *newString = @"1⃣3⃣4⃣";
    NSString *oldString = @"2⃣3⃣5⃣";
    
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(0, 2)]];
    [additionRanges addObject:[NSValue valueWithRange:NSMakeRange(6, 2)]];
    
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(2, 2)]];
    [deletionRanges addObject:[NSValue valueWithRange:NSMakeRange(8, 2)]];
    
    expectedResult[kTOMSDictionaryKeyMergedString] = mergeString;
    expectedResult[kTOMSDictionaryKeyAdditionRanges] = additionRanges;
    expectedResult[kTOMSDictionaryKeyDeletionRanges] = deletionRanges;
    
    [self assertMergeOfString:newString intoString:oldString expectedResult:expectedResult];
}

@end
