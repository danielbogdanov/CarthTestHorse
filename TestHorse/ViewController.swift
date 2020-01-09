//
//  ViewController.swift
//  TestHorse
//
//  Created by Daniel Bogdanov on 14.03.19.
//  Copyright © 2019 Daniel Bogdanov. All rights reserved.
//

import UIKit
import Leanplum
//import LeanplumLocation



class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventParamField: UITextField!
    @IBOutlet weak var eventValueField: UITextField!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var attrValueField: UITextField!
    @IBOutlet weak var attrIdField: UITextField!
    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var labelToChange: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    
    var userId:String!
    var point:CGPoint!
    var customLabel = LPVar.define("customLabel")
    var testVar = LPVar.define("testVariable2")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage()
        
        userIdField.delegate = self
        userIdField.placeholder = "Current: " + getUserId()
        userIdField.tag = 0
        
        attrIdField.delegate = self
        attrIdField.tag = 1
        
        attrValueField.delegate = self
        attrValueField.tag = 2
        
        eventNameField.delegate = self
        eventNameField.tag = 3
        
        eventValueField.delegate = self
        eventValueField.tag = 4
        
        eventParamField.delegate = self
        eventParamField.tag = 5
        
        labelToChange.text = customLabel?.stringValue
        labelTwo.text = testVar?.stringValue
        
        
    }
    
    
    @IBAction func setUserId(_ sender: Any) {
        userId = userIdField.text
        print(userId!)
        Leanplum.setUserId(userId!)
        Leanplum.setUserAttributes(["logged" : true] )
        userIdField.text = nil
        userIdField.placeholder = "Current: " + getUserId()
    }
    
    @IBAction func logUserOut(_ sender: Any) {
//        // Leanplum.setUserAttributes(["logged": NSNull()])
//        let testArray = ["test1","test2","test3"]
////        Leanplum.setUserAttributes(["logged": ""])
//        Leanplum.setUserAttributes(["testAttributeName":["test1","test2","test3"], "testTwo":24])
//        print(UI_USER_INTERFACE_IDIOM())
        Leanplum.setDeviceLocationWithLatitude(37.233333, longitude: -115.77, city: "Sugar Bunker", region: "NV",country: "USA", type: LPLocationAccuracyCELL)
        Leanplum.forceContentUpdate()
//        Leanplum.setVers
//        Leanplum.track( "authStat", withParameters: <#T##[AnyHashable : Any]!#>)
//        Leanplum.track("zed", withValue: 30.00)
    }
    
    
    @IBAction func setUserAttribute(_ sender: Any) {
        Leanplum.setUserAttributes([attrIdField.text! : attrValueField.text!])
        attrIdField.text = nil
        attrValueField.text = nil
    }
    
    @IBAction func switchState(_ sender: UISwitch) {
        if(sender.isOn == true){
            Leanplum.advance(to: "LP_EVENT_SWITCH_IS_ON")
        }else{
            Leanplum.advance(to: "LP_EVENT_SWITCH_IS_OFF")
        }
    }
    
    @IBAction func trackMultievent(_ sender: Any) {
//        Leanplum.setUserAttributes(["unsubscribeChannelsToAdd":"Email"])
//        LPLocationManager.shared().authorizeAutomatically = true
//        LPLocationManager.shared().authorize()

    }
    
    @IBAction func addEvent(_ sender: Any) {
        let paramString = eventParamField.text!
        let paramIndex = paramString.firstIndex(of: ",") ?? paramString.endIndex
        let firstParam = paramString[..<paramIndex]
        let secondParam = paramString[paramIndex...]
        let secondParamString = secondParam.replacingOccurrences(of: ",", with: "")
        print(firstParam)
        print(secondParamString)
        let params:[String:Any] = [String(firstParam):secondParamString]
        if(!isInt(string: eventValueField.text!)){
            Leanplum.track(eventNameField.text, withInfo: eventValueField.text!)
        }else{
            Leanplum.track(eventNameField.text, withValue: Double(eventValueField.text!)!, andParameters: params)
        }
        eventNameField.text = nil
        eventValueField.text = nil
        eventParamField.text = nil
    }
    
    @IBAction func refreshContent(_ sender: Any) {
    
        Leanplum.forceContentUpdate()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        
        switch(textField.tag) {
            case 1,3,4 :
                nextField!.becomeFirstResponder()
                print("Tag")
                print(nextField!.tag)
            case 2,5 :
                textField.resignFirstResponder()
                print(textField.tag)
            default :
                textField.resignFirstResponder()
            
        }
       
        return true
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        point = textField.frame.origin
        var x = point!.x
        var y = point!.y
        print(point!.x)
        print(point!.y)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.scrollView.contentOffset = CGPoint(x: x, y: y-50)
            }, completion: nil)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("ENDED")
    }
    
    
    func getUserId() -> String! {
        print(Leanplum.userId()!)
        return Leanplum.userId()
    }
    
    
    func setBackgroundImage() {
        let background = UIImage(named: "ios_bkg")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
    }
    
    func isInt(string: String) -> Bool {
        return Int(string) != nil
    }

}

