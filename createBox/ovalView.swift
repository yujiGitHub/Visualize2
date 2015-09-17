//
//  ovalView.swift
//  createBox
//
//  Created by 楢木 悠士 on 2015/08/01.
//  Copyright (c) 2015年 yuji. All rights reserved.
//

import UIKit

class ovalView: UIView {
    
    var userNameLabel: UILabel = UILabel()
    var userIDLabel: UILabel = UILabel()
    var tweetTextView: UITextView = UITextView()
    var userImageView: UIImageView = UIImageView()
    var backView: UIView = UIView()

    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor.clearColor()
        
        // 楕円
        var oval = UIBezierPath(ovalInRect: CGRectMake(1, 1, rect.width-2, rect.height-2))
        
        var red: CGFloat = CGFloat(arc4random_uniform(255))/255
        var green: CGFloat = CGFloat(arc4random_uniform(255))/255
        var blue: CGFloat = CGFloat(arc4random_uniform(255))/255
        
        var color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: 0.8)
        
        color.setFill()
        oval.fill()
        
        color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        color.setStroke()
        oval.lineWidth = 2
        oval.stroke()
        
        var availableRect: CGRect = CGRectMake(rect.width/6, rect.height/6, rect.width*4/6, rect.height*4/6)
        backView.frame = availableRect
//        backView.backgroundColor = UIColor.blackColor()
//        backView.alpha = 1.0
        self.addSubview(backView)
        
        userImageView.frame = CGRectMake(availableRect.origin.x, availableRect.origin.y, availableRect.width/6, availableRect.width/6)
//        userImageView.backgroundColor = UIColor.redColor()
//        userImageView.alpha = 0.5
        self.addSubview(userImageView)
        
        userNameLabel.frame = CGRectMake(availableRect.origin.x + availableRect.width/6, availableRect.origin.y, availableRect.width*5/6, availableRect.width/6/1.5)
//        userNameLabel.backgroundColor = UIColor.blueColor()
//        userNameLabel.alpha = 0.5
        userNameLabel.font = UIFont.systemFontOfSize(CGFloat(12.0))
        self.addSubview(userNameLabel)
        
        userIDLabel.frame = CGRectMake(availableRect.origin.x + availableRect.width/6, availableRect.origin.y + availableRect.width/6/1.5, availableRect.width*5/6, availableRect.width/6/3)
//        userIDLabel.backgroundColor = UIColor.orangeColor()
//        userIDLabel.alpha = 0.5
        userIDLabel.font = UIFont.systemFontOfSize(CGFloat(8.0))
        self.addSubview(userIDLabel)
        
        tweetTextView.frame = CGRectMake(availableRect.origin.x, availableRect.origin.y + availableRect.width/6, availableRect.width, availableRect.height - availableRect.width/6)
        tweetTextView.backgroundColor = UIColor.clearColor()
//        tweetTextView.alpha = 1.0
        tweetTextView.font = UIFont.systemFontOfSize(CGFloat(9))
        tweetTextView.editable = false
        self.addSubview(tweetTextView)
        
    }
    
}
