//
//  MassConverterClass.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/2/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class MassConverterClass: NSObject {
    
    var unitConversionTableDict = NSDictionary()
    
    var unitsAvailable = ["Milli Gram (mg)", "Gram (g)", "Kilo Gram (kg)", "Ounce (oz)", "Pound (lb)", "Ton (ton)"]
    
    var selectedFromUnit = String()
    var selectedToUnit = String()
    
    func convertValues(value: Float) -> Float {
        
        unitConversionTableDict = self.fetchConversionTableFromPlist(fromUnitValue: selectedFromUnit)
        
        let resultValue = value * Float(unitConversionTableDict[selectedToUnit] as! Float)
        
        return resultValue
    }
    
    func fetchConversionTableFromPlist(fromUnitValue: String) -> NSDictionary {
        let lengthPlist = Bundle.main.path(forResource: "MassConversion", ofType: "plist")
        let lengthArray = NSArray(contentsOfFile: lengthPlist!)
        
        let lengthDict = lengthArray?[0] as! NSDictionary
        
        return lengthDict[fromUnitValue] as! NSDictionary
    }
}
