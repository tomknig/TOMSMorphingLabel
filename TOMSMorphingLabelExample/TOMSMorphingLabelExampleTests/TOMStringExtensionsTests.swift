//
//  TOMStringExtensionsTests.swift
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 08/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

import XCTest

class TOMStringExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func assertMergeOfString(newString: String, intoString oldString: String, expectedResult: (string: String, rangesOfAdditions: NSRange[], rangesOfDeletions: NSRange[]))
    {
        let (mergedString, rangesOfAdditions, rangesOfDeletions) = newString.mergeIntoString(oldString)
        
        XCTAssertEqual(expectedResult.string, mergedString, "Merging `\(newString)` into `\(oldString)`.")
        
        XCTAssertEqual(expectedResult.rangesOfAdditions.count, rangesOfAdditions.count, "Merging `\(newString)` into `\(oldString)`.")
        
        XCTAssertEqual(expectedResult.rangesOfDeletions.count, rangesOfDeletions.count, "Merging `\(newString)` into `\(oldString)`.")
        
        for expectedRange in expectedResult.rangesOfAdditions {
            var filter = rangesOfAdditions.filter({$0.location == expectedRange.location && $0.length == expectedRange.length})
            
            XCTAssertTrue(filter.count == 1, "Merging `\(newString)` into `\(oldString)`.")
        }
        
        for expectedRange in expectedResult.rangesOfDeletions {
            var filter = rangesOfDeletions.filter({$0.location == expectedRange.location && $0.length == expectedRange.length})
            
            XCTAssertTrue(filter.count == 1, "Merging `\(newString)` into `\(oldString)`.")
        }
    }
    
    func test_prefix() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 4, length: 1)
        expectedRangesOfAdditions += NSRange(location: 5, length: 1)
        expectedRangesOfAdditions += NSRange(location: 6, length: 1)
        expectedRangesOfAdditions += NSRange(location: 7, length: 1)
        expectedRangesOfAdditions += NSRange(location: 8, length: 1)
        
        let expectedResult = ("something", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("something", intoString: "some", expectedResult: expectedResult)
    }
    
    func test_suffix() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfDeletions += NSRange(location: 4, length: 5)
        
        let expectedResult = ("something", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("some", intoString: "something", expectedResult: expectedResult)
    }
    
    func test_prefix_partial() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 0, length: 1)
        expectedRangesOfAdditions += NSRange(location: 1, length: 1)
        expectedRangesOfAdditions += NSRange(location: 2, length: 1)
        expectedRangesOfAdditions += NSRange(location: 3, length: 1)
        
        expectedRangesOfDeletions += NSRange(location: 8, length: 1)
        
        let expectedResult = ("something", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("somethin", intoString: "thing", expectedResult: expectedResult)
    }
    
    func test_suffix_partial() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfDeletions += NSRange(location: 0, length: 4)
        expectedRangesOfDeletions += NSRange(location: 6, length: 1)
        
        let expectedResult = ("something", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("thng", intoString: "something", expectedResult: expectedResult)
    }
    
    func test_suffix_partial2() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 0, length: 1)
        expectedRangesOfAdditions += NSRange(location: 1, length: 1)
        expectedRangesOfAdditions += NSRange(location: 2, length: 1)
        
        expectedRangesOfDeletions += NSRange(location: 3, length: 4)
        
        let expectedResult = ("anysomething", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("anything", intoString: "something", expectedResult: expectedResult)
    }
    
    func test_replace() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 0, length: 1)
        expectedRangesOfAdditions += NSRange(location: 1, length: 1)
        expectedRangesOfAdditions += NSRange(location: 2, length: 1)
        
        expectedRangesOfDeletions += NSRange(location: 3, length: 3)
        
        let expectedResult = ("foobar", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("foo", intoString: "bar", expectedResult: expectedResult)
    }
    
    func test_fuzzy_merge() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 0, length: 1)
        expectedRangesOfAdditions += NSRange(location: 3, length: 1)
        
        expectedRangesOfDeletions += NSRange(location: 1, length: 1)
        expectedRangesOfDeletions += NSRange(location: 4, length: 1)
        
        let expectedResult = ("12345", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("134", intoString: "235", expectedResult: expectedResult)
    }
    
    func test_extraction() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfDeletions += NSRange(location: 0, length: 1)
        expectedRangesOfDeletions += NSRange(location: 2, length: 1)
        
        let expectedResult = ("123", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("2", intoString: "123", expectedResult: expectedResult)
    }
    
    func test_superset() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 0, length: 1)
        expectedRangesOfAdditions += NSRange(location: 2, length: 1)
        
        let expectedResult = ("123", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("123", intoString: "2", expectedResult: expectedResult)
    }
    
    func test_absorb() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfDeletions += NSRange(location: 1, length: 1)
        
        let expectedResult = ("123", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("13", intoString: "123", expectedResult: expectedResult)
    }
    
    func test_troll() {
        var expectedRangesOfAdditions = NSRange[]()
        var expectedRangesOfDeletions = NSRange[]()
        
        expectedRangesOfAdditions += NSRange(location: 0, length: 1)
        expectedRangesOfAdditions += NSRange(location: 2, length: 1)
        expectedRangesOfAdditions += NSRange(location: 4, length: 1)
        expectedRangesOfAdditions += NSRange(location: 5, length: 1)
        expectedRangesOfAdditions += NSRange(location: 6, length: 1)
        
        expectedRangesOfDeletions += NSRange(location: 7, length: 1)
        
        let expectedResult = ("SAWPIFTPLE", expectedRangesOfAdditions, expectedRangesOfDeletions)
        assertMergeOfString("SAWPIFTLE", intoString: "APPLE", expectedResult: expectedResult)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
