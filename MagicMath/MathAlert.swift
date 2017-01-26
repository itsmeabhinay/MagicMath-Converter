//
//  MathAlert.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/4/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class MathAlert: NSObject {
    
    var appRated = UserDefaults.standard
    
    func createMathAlert(title: String, message: String) -> UIAlertController {
        let mathAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        mathAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        return mathAlert
    }
    
    func createMathAlertForRating(title: String, message: String) -> UIAlertController {
        let mathAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        mathAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            
            let urlString = String(format: "itms-apps://itunes.apple.com/app/id1175596702") as String
            
            UIApplication.shared.openURL(NSURL(string: urlString) as! URL)
            
            self.appRated.set(true, forKey: "appRated")
            
        }))
        
        mathAlert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { action in
            self.appRated.set(false, forKey: "appRated")
        }))
        
        return mathAlert
    }

}
