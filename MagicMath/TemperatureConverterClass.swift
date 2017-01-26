//
//  TemperatureConverterClass.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/2/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class TemperatureConverterClass: NSObject {
    
    var unitsAvailable = ["Celsius (C)", "Farenheit (F)", "Kelvin (K)"]
    
    var selectedFromUnit = String()
    var selectedToUnit = String()
    var resultValue = Float()
    
    func convertValues(value: Float) -> Float {
        
        if selectedFromUnit == "Celsius (C)" {
            switch selectedToUnit {
            case "Farenheit (F)":
                resultValue = value * 1.8 + 32
                break
            case "Kelvin (K)":
                resultValue = value + 273.15
                break
            default:
                break
            }
        }
        else if selectedFromUnit == "Farenheit (F)" {
            switch selectedToUnit {
            case "Celsius (C)":
                resultValue = (value - 32) / 1.8
                break
            case "Kelvin (K)":
                resultValue = (value + 459.67) * 0.56
                break
            default:
                break
            }
        }
        else {
            switch selectedToUnit {
            case "Farenheit (F)":
                resultValue = (value * 1.8) - 459.67
                break
            case "Celsius (C)":
                resultValue = value - 273.15
                break
            default:
                break
            }
        }
        
        return resultValue
    }
}
