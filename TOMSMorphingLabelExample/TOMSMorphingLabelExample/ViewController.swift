//
//  ViewController.swift
//  TOMSMorphingLabelExample
//
//  Created by Tom König on 12/06/14.
//  Copyright (c) 2014 TomKnig. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        showMorphingLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMorphingLabel() {
        let textLabelFrame = CGRect(x: 0, y: 42, width: self.view.frame.size.width, height: 42)
        var textLabel = TOMSMorphingLabel(frame: textLabelFrame)
        
        textLabel.font = UIFont.systemFontOfSize(32)
        textLabel.textColor = UIColor(red: 0.102, green: 0.839, blue: 0.992, alpha: 1)
        textLabel.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(textLabel)
        
        self.insertTestText(textLabel)
    }
    
    func insertTestText(label: UILabel) {
        label.text = "Swift"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            label.text = "Swiftilicious"
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                label.text = "delicious"
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    label.text = ""
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.insertTestText(label)
                        })
                    })
                })
            })
    }


}

