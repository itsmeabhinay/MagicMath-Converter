//
//  AreaConverterClass.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/2/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class AreaConverterClass: NSObject {
    
    var unitConversionTableDict = NSDictionary()
    
    var unitsAvailable = ["Square Foot (Sq ft)", "Square Meter (Sq m)", "Square Yard (Sq yard)", "Square Mile (Sq mile)", "Acre (acre)", "Hectare (hectare)"]
    
    var selectedFromUnit = String()
    var selectedToUnit = String()
    
    func convertValues(value: Float) -> Float {
        
        unitConversionTableDict = self.fetchConversionTableFromPlist(fromUnitValue: selectedFromUnit)
        
        let resultValue = value * Float(unitConversionTableDict[selectedToUnit] as! Float)
        
        return resultValue
    }
    
    func fetchConversionTableFromPlist(fromUnitValue: String) -> NSDictionary {
        let lengthPlist = Bundle.main.path(forResource: "AreaConversion", ofType: "plist")
        let lengthArray = NSArray(contentsOfFile: lengthPlist!)
        
        let lengthDict = lengthArray?[0] as! NSDictionary
        
        return lengthDict[fromUnitValue] as! NSDictionary
    }

}
