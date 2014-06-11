//
//  TOMSStringExtensions.swift
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 08/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

import Foundation

extension String {
    
    func mergeIntoString(string: String, maxLookAhead: Int = 6) -> (mergedString: String, rangesOfAdditions: NSRange[], rangesOfDeletions: NSRange[]) {
        var rangesOfAdditions = NSRange[]()
        var rangesOfDeletions = NSRange[]()
        var mergedString = ""
        var range: NSRange
        var idx = 0, startIndex = -1, endIndex = -1, insertions = 0
        
        for ownChar in self {
            var i = 0
            
            for alienChar in string {
                if (i++ < idx) {
                    continue
                }
                
                if (startIndex < 0) {
                    startIndex = idx
                }
                
                if ownChar == alienChar {
                    endIndex = i
                    
                    mergedString += string.substringFromIndex(startIndex).substringToIndex(endIndex - startIndex)
                    idx = i
                    break
                }
                
                if (i - idx >= maxLookAhead) {
                    break
                }
            }
            
            if (endIndex >= 0) {
                if (endIndex - startIndex - 1 > 0) {
                    rangesOfDeletions += NSRange(location: startIndex + insertions, length: endIndex - startIndex - 1)
                }
            } else {
                rangesOfAdditions += NSRange(location: countElements(mergedString), length: 1)
                mergedString += ownChar
                ++insertions
            }
            
            startIndex = -1
            endIndex = -1
        }
        
        let lengthOfAlienString = countElements(string)
        if (idx < lengthOfAlienString) {
            rangesOfDeletions += NSRange(location: countElements(mergedString), length: lengthOfAlienString - idx)
            mergedString += string.substringFromIndex(idx).substringToIndex(lengthOfAlienString - idx)
        }
        
        return (mergedString, rangesOfAdditions, rangesOfDeletions)
    }
}
