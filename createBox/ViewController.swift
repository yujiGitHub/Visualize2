//
//  ViewController.swift
//  createBox
//
//  Created by 楢木 悠士 on 2015/08/01.
//  Copyright (c) 2015年 yuji. All rights reserved.
//

import UIKit
import Social
import Accounts

//extension UIScrollView {
//    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.nextResponder()?.touchesBegan(touches as Set<NSObject>, withEvent: event)
//    }
//    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.nextResponder()?.touchesMoved(touches as Set<NSObject>, withEvent: event)
//    }
//    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.nextResponder()?.touchesEnded(touches as Set<NSObject>, withEvent: event)
//    }
//}

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var array:NSArray = NSArray()
    var mainView:UIScrollView = UIScrollView()
    var subView: UIView = UIView()
    var lastTweetID: String = ""
    var backgroundImage: UIImage = UIImage(named: "background.png")!
    var backgroundImageView: UIImageView = UIImageView()
    var touchedNum: Int = 0
    var bLongPress: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var scale = backgroundImage.size.height / self.view.frame.height/2
        mainView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        mainView.contentSize = CGSizeMake(backgroundImage.size.width/scale, backgroundImage.size.height/scale)
        mainView.backgroundColor = UIColor.clearColor()
        mainView.bounces = true
        mainView.tag = 0
        self.view.addSubview(mainView)
        
        mainView.maximumZoomScale = 3.0
        mainView.minimumZoomScale = 0.5
        mainView.delegate = self
        
        subView.backgroundColor = UIColor.clearColor()
        subView.tag = 0
        subView.frame = CGRectMake(0, 0, backgroundImage.size.width/scale, backgroundImage.size.height/scale)
        mainView.addSubview(subView)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.frame = subView.frame
        backgroundImageView.tag = 0
        backgroundImageView.userInteractionEnabled = true
        subView.addSubview(backgroundImageView)
        
        self.twitterTimeline()
        self.roadData()
    }
    
    func twitterTimeline() {
        
        //STEP.1 iOS内部に保存されている Twitterのアカウント情報を取得
        let account:ACAccountStore = ACAccountStore()
        let accountType:ACAccountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        //ユーザーに Twitterの認証情報を使うことを確認
        let handler: ACAccountStoreRequestAccessCompletionHandler = { (granted, error) -> Void in
            if granted == true {
                NSLog("ユーザーがアクセスを許可しました。")
                let arrayOfAccounts:NSArray = account.accountsWithAccountType(accountType)
                if (arrayOfAccounts.count > 0) {
                    let twitterAccount:ACAccount = arrayOfAccounts.lastObject as! ACAccount
                    let requestAPI:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!
                    let parameters:NSMutableDictionary! = NSMutableDictionary()
                    parameters.setObject("100", forKey: "count")
                    parameters.setObject("1", forKey: "include_entities")
//                    if(self.lastTweetID != ""){
//                        parameters.setObject(self.lastTweetID, forKey: "max_id")
//                    }
                    let posts:SLRequest = SLRequest(forServiceType:SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestAPI, parameters: parameters as [NSObject : AnyObject]!)
                    posts.account = twitterAccount
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    posts.performRequestWithHandler({ (response, urlResponse, error) -> Void in
                        var preError:NSError?
                        self.array = NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.MutableLeaves, error: &preError) as! NSArray
                    })
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }else{
                NSLog("ユーザーがアクセスを拒否しました。")
            }
        }
        account.requestAccessToAccountsWithType(accountType, options: nil, completion: handler)
    }
    
    @IBAction func refreshButton() {
        
        mainView.zoomScale = 1.0
        
        for(var i:Int = 0; i<array.count; i++) {
            var view = subView.viewWithTag(i+1)
            view?.removeFromSuperview()
        }
        
        self.twitterTimeline()
        self.roadData()
        
    }
    
    @IBAction func tweetButoon() {
        var twitterPostViewController:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        self.presentViewController(twitterPostViewController, animated: true, completion: nil)
    }
    
    func roadData() {
        NSLog(String(array.count))
        var tapGestureArray: [UITapGestureRecognizer]! = []
        var panGestureArray: [UIPanGestureRecognizer]! = []
        var longPressGestureArray: [UILongPressGestureRecognizer]! = []
        
        for var i = 0; i < array.count; i++ {
            
            //ユーザーデータ取得
            var tweet:NSDictionary = array[i] as! NSDictionary
            var userInfo:NSDictionary = tweet["user"] as! NSDictionary
            var tweetText:String = tweet["text"]!.description
            var userName:String = userInfo["name"]!.description
            var userID:String = userInfo["screen_name"]!.description
            
            if(i == array.count-1){
                lastTweetID = tweet["id"]!.stringValue
            }
            
//            NSLog(tweetID)
            NSLog(userName)
            
            var userImagePath:NSString = userInfo["profile_image_url"]!.description
            var userImagePathUrl:NSURL = NSURL(string: userInfo["profile_image_url"]!.description)!
            var userImagePathData:NSData = NSData(contentsOfURL: NSURL(string: userInfo["profile_image_url"]!.description)!)!
            var userImage:UIImage = UIImage(data: userImagePathData)!
            
            tapGestureArray.append(UITapGestureRecognizer(target: self, action: "tapGesture:"))
            tapGestureArray[i].delegate = self
            
            panGestureArray.append(UIPanGestureRecognizer(target: self, action: "panGesture:"))
            panGestureArray[i].delegate = self
            
            longPressGestureArray.append(UILongPressGestureRecognizer(target: self, action: "longPressGesture:"))
            longPressGestureArray[i].delegate = self
            
            //お絵描き
            var width: CGFloat = 200
            var draw = ovalView(frame: CGRectMake(CGFloat(arc4random_uniform(UInt32(subView.frame.width-width))), CGFloat(arc4random_uniform(UInt32(subView.frame.height-(width/2)))), width, width/2))
            draw.userNameLabel.text = userName
            draw.userIDLabel.text = userID
            draw.tweetTextView.text = tweetText
            draw.userImageView.image = userImage
            draw.backgroundColor = UIColor.clearColor()
            draw.tag = i+1
            subView.addSubview(draw)
            draw.addGestureRecognizer(tapGestureArray[i])
            draw.addGestureRecognizer(panGestureArray[i])
            draw.addGestureRecognizer(longPressGestureArray[i])
        }
    }
    
    func tapGesture(sender: UITapGestureRecognizer){
        
        mainView.scrollEnabled = false
        
        touchedNum = sender.view!.tag
        print("tapped\(touchedNum)! ")
//        mainView.zoomScale = 1.0
        subView.bringSubviewToFront(sender.view!)
        mainView.scrollEnabled = true
        
    }
    func panGesture(sender: UIPanGestureRecognizer){
        
        if(bLongPress){
            
            if(sender.state == UIGestureRecognizerState.Began){
                mainView.scrollEnabled = false
                subView.bringSubviewToFront(sender.view!)
            }
            
            // ドラッグで移動した距離を取得する
            var location = sender.translationInView(subView)
            // 移動した距離だけ、UIImageViewのcenterポジションを移動させる
            var movedPoint = CGPoint(x:sender.view!.center.x + location.x, y:sender.view!.center.y + location.y)
            sender.view!.center = movedPoint;
            // ドラッグで移動した距離を初期化する
            // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
            // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
            sender.setTranslation(CGPointZero, inView: subView)
            
            
            if(sender.state == UIGestureRecognizerState.Ended){
                
                mainView.scrollEnabled = true
                bLongPress = false
                
                var x = sender.view!.frame.height
                sender.view!.frame.origin.x += x/5
                sender.view!.frame.origin.y += x/10
                sender.view!.frame.size.width *= 4/5
                sender.view!.frame.size.height *= 4/5
            }
        }
    }
    
    func longPressGesture(sender: UILongPressGestureRecognizer) {
        
        if(sender.state == UIGestureRecognizerState.Began){
            
            bLongPress = true
            mainView.scrollEnabled = false
            
            var x = sender.view!.frame.height
            sender.view!.frame.origin.x -= x/4
            sender.view!.frame.origin.y -= x/8
            sender.view!.frame.size.width *= 5/4
            sender.view!.frame.size.height *= 5/4
        }
        
        print("longPressed")
        
        if(sender.state == UIGestureRecognizerState.Ended){
            mainView.scrollEnabled = true
            
            var x = sender.view!.frame.height
            sender.view!.frame.origin.x += x/5
            sender.view!.frame.origin.y += x/10
            sender.view!.frame.size.width *= 4/5
            sender.view!.frame.size.height *= 4/5
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //更新
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return subView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

