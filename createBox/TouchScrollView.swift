//
//  TouchScrollView.swift
//  Visualize
//
//  Created by 楢木 悠士 on 2015/09/04.
//  Copyright (c) 2015年 yuji. All rights reserved.
//

import Foundation
import UIKit

class TouchScrollView: UIScrollView {
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    convenience init() {
//        
//    }
    
//    var Delegate: ScrollViewDelegate!
    var viewController: ViewController?
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touchbegan")
        
        viewController?.touched(touches)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touchmoved")
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touchended")
    }
}