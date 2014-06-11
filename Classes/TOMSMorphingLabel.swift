//
//  TOMSSuggestionLabel.swift
//  TOMSSuggestionBarExample
//
//  Created by Tom König on 06/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

import UIKit

class TOMSMorphingLabel: UILabel {
    
    let kernPercentageAttributeName = "TOMSKernPercentageAttributeName"
    
    var animationTimer: NSTimer?
    var currentAttributionStage = 0
    
    let numberOfAttributionStages: Int!
    let animationDuration: Double!
    let charAnimationOffset: Double!
    
    @lazy var attributionStages: NSMutableDictionary[] = self.attributionStagesForNumberOfStages(self.numberOfAttributionStages)
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, animationDuration: 0.21, charAnimationOffset: 0.25, fps: 60)
    }
    
    init(frame: CGRect, animationDuration: Double, charAnimationOffset: Double, fps: Int) {
        super.init(frame: frame)
        
        self.animationDuration = animationDuration
        self.charAnimationOffset = charAnimationOffset
        self.numberOfAttributionStages = Int(Double(fps) * animationDuration)
    }
    
    func attributionStagesForNumberOfStages(numberOfStages: Int) -> NSMutableDictionary[] {
        var attributionStages = NSMutableDictionary[]()
        
        let minFontSize: Float = Float(self.font.pointSize) / (1.61 * 2)
        let fontRatio: Float = minFontSize / Float(self.font.pointSize)
        let fontPadding: Float = 1 - fontRatio
        
        func ease(x: Float) -> Float {
            if (x < 0.5) {
                return 2 * x * x;
            }
            return (-2 * x * x) + (4 * x) - 1;
        }
        
        func textColorWithAlpha(alpha: CGFloat) -> UIColor {
            var textColor = self.textColor;
            textColor = textColor.colorWithAlphaComponent(alpha)
            return textColor;
        }
        
        func fontOfScale(scale: CGFloat) -> UIFont {
            var font = self.font
            font = font.fontWithSize(font.pointSize * scale)
            return font
        }
        
        for i in 0..numberOfStages {
            var attributionStage = NSMutableDictionary()
            
            let progress = ease(Float(i) / Float(numberOfStages - 1))
            let textColor = textColorWithAlpha(CGFloat(progress))
            attributionStage[NSForegroundColorAttributeName] = textColor
            
            let fontScale = fontRatio + progress * fontPadding
            attributionStage[NSFontAttributeName] = fontOfScale(CGFloat(fontScale))
            
            attributionStage[kernPercentageAttributeName] = 1 - progress
            
            attributionStages += attributionStage
        }
        
        return attributionStages
    }
    
    
    var isAnimating: Bool {
        return self.animationTimer != nil
    }
    
    override var text: String! {
    get {
        return super.text
    }
    set(newText) {
        self.nextText = newText
    }
    }
    
    var targetText: String?
    var nextText: String? {
    didSet {
        if let _ = nextText {
            if !self.isAnimating {
                self.beginAnimation()
            }
        }
    }
    }
    
    var rangesOfAdditions = NSRange[]()
    var rangesOfDeletions = NSRange[]()
    
    func pursueAttribution() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                let stage = self.currentAttributionStage
                
                if (self.currentAttributionStage++ >= self.numberOfAttributionStages) {
                    self.endAnimation()
                } else {
                    self.applyAttributedStringForStage(stage, string: self.attributedText.string)
                }
                })
            })
    }
    
    func applyAttributedStringForStage(stage: Int, string: String) {
        var mutableString = NSMutableAttributedString(string: string)
        
        struct AnimationDirection {
            static func entryPoint(location: Int, middle: Int) -> Double {
                if (location >= middle) {
                    return Double(location - middle) / Double(middle)
                } else {
                    return 1 - Double(location) / Double(middle)
                }
            }
        }
        
        func applyMutations(mutations: NSRange[], offset: Double) {
            let middle = countElements(string) / 2
            
            for range in mutations {
                let entryPoint = AnimationDirection.entryPoint(range.location, middle: middle) * self.charAnimationOffset * Double(self.numberOfAttributionStages)
                
                var idx = Int(offset - entryPoint)
                idx = min(self.numberOfAttributionStages - 1, max(0, idx))
                
                var attributionStage: NSMutableDictionary = self.attributionStages[idx]
                let kerning = attributionStage[kernPercentageAttributeName] as CGFloat
                let char: NSString = string.substringFromIndex(range.location).substringToIndex(1)
                let charSize = char.sizeWithFont(attributionStage[NSFontAttributeName] as UIFont)
                attributionStage[NSKernAttributeName] = -kerning * charSize.width
                
                mutableString.setAttributes(attributionStage, range: range)
            }
        }
        
        applyMutations(self.rangesOfAdditions, Double(stage) * (1 + self.charAnimationOffset))
        applyMutations(self.rangesOfDeletions, Double(self.numberOfAttributionStages - stage))
        
        self.attributedText =  mutableString
    }
    
    func arrayOfScalarRangesFromArrayWithRanges(arrayOfRanges: NSRange[]) -> NSRange[] {
        var arrayOfScalarRanges = NSRange[]()
        
        for range in arrayOfRanges {
            for i in 0..range.length {
                arrayOfScalarRanges += NSRange(location: range.location + i, length: 1)
            }
        }
        
        return arrayOfScalarRanges
    }
    
    func prepareAnimation() -> String{
        if let targetText = self.nextText {
            var newText: String
            if let _ = self.text {
                let (mergedString, rangesOfAdditions, rangesOfDeletions) = targetText.mergeIntoString(self.text)
                self.rangesOfAdditions = arrayOfScalarRangesFromArrayWithRanges(rangesOfAdditions)
                self.rangesOfDeletions = arrayOfScalarRangesFromArrayWithRanges(rangesOfDeletions)
                
                newText = mergedString
            } else {
                newText = targetText
                self.rangesOfAdditions = arrayOfScalarRangesFromArrayWithRanges([NSRange(location: 0, length: countElements(newText))])
                self.rangesOfDeletions = []
            }
            
            self.targetText = self.nextText
            self.nextText = nil
            return newText
        }
        return ""
    }
    
    func beginAnimation() {
        self.currentAttributionStage = 0
        if let targetText = self.nextText {
            let newText = self.prepareAnimation()
            
            self.applyAttributedStringForStage(self.currentAttributionStage, string: newText)
            
            let timeInterval = NSTimeInterval(Double(self.animationDuration) / Double(self.numberOfAttributionStages))
            self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: Selector("pursueAttribution"), userInfo: nil, repeats: true)
        }
    }
    
    func endAnimation() {
        if let timer = self.animationTimer {
            timer.invalidate()
            self.animationTimer = nil
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            dispatch_sync(dispatch_get_main_queue(), {
                self.attributedText = NSAttributedString(string: self.targetText)
                if let targetText = self.nextText {
                    self.nextText = targetText
                }
                })
            })
    }

}
