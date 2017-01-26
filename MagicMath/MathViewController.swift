//
//  MathViewController.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/2/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class MathViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    // 3D Touch Capability Added
    // IBOutlets
    @IBOutlet var valueToBeConverted: UITextField!
    @IBOutlet var fromUnit: UITextField!
    @IBOutlet var toUnit: UITextField!
    @IBOutlet var resultValue: UILabel!
    //@IBOutlet var convertButton: UIButton!
    var unitPickerForFrom = UIPickerView()
    var unitPickerForTo = UIPickerView()
    var activeTextField: UITextField!
    // Class variables
    var unitName = String()
    var availableUnits = NSArray()
    var lengthConverter = LengthConverterClass()
    var volumeConverter = VolumeConverterClass()
    var massConverter = MassConverterClass()
    var tempConverter = TemperatureConverterClass()
    var areaConverter = AreaConverterClass()
    var selectedFromUnit = String()
    var selectedToUnit = String()
    var isReversed = Bool()
    // GA Variables
    var tracker = GAI.sharedInstance().defaultTracker
    var builder = GAIDictionaryBuilder()
    // Constants
    let fromUnitTF_TAG = 16534
    let toUnitTF_TAG = 16535
    let valueTF_TAG = 16533
    let kKEYBOARD_CONST = 50.0
    let borderColor = UIColor(red:  210.0/255.0,
                              green:  122.0/255.0,
                              blue:  47.0/255.0,
                              alpha: 1.0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tracker?.set(kGAIScreenName, value: "Units Conversion Screen")
        
        builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder.build() as [NSObject : AnyObject])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.dataSourceForPicker()
        
        // Default units
        fromUnit.text = availableUnits[0] as? String
        toUnit.text = availableUnits[1] as? String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let appRated = UserDefaults.standard
        if !appRated.bool(forKey: "appRated") {
            
            let launchCount = UserDefaults.standard.integer(forKey: "launchCount")
            
            if  launchCount == 5 ||
                launchCount == 10 ||
                launchCount == 20 ||
                launchCount == 30 ||
                launchCount > 35 {
                
                let mathAlert = MathAlert().createMathAlertForRating(title: "Rate this app!", message: "If you are finding MagicMath useful, would you mind rating it. It would only take a minute to write the review. Thanks for your support!")
                
                present(mathAlert, animated: true);
                
            }

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Private Methods
    
    func dataSourceForPicker() {
        switch unitName {
        case "Length":
            availableUnits = lengthConverter.unitsAvailable as NSArray
            return
        case "Volume":
            availableUnits = volumeConverter.unitsAvailable as NSArray
            return
        case "Weight":
            availableUnits = massConverter.unitsAvailable as NSArray
            return
        case "Temperature":
            availableUnits = tempConverter.unitsAvailable as NSArray
            return
        case "Area":
            availableUnits = areaConverter.unitsAvailable as NSArray
            return
        default:
            return
        }
    }
    
    func setUpUI() {
        
        self.title = String(format: "%@", unitName)
        
        resultValue.layer.cornerRadius = 5
        resultValue.layer.masksToBounds = true
        
        // Convert button
//        convertButton.layer.cornerRadius = 15.0
//        convertButton.layer.borderWidth = 1.0
//        convertButton.layer.borderColor = borderColor.cgColor
        
        // Setting keyboard input views
        valueToBeConverted.inputAccessoryView = self.addToolbarForKeyboard()
        fromUnit.inputAccessoryView = self.addToolbarForKeyboard()
        fromUnit.inputView = unitPickerForFrom
        toUnit.inputAccessoryView = self.addToolbarForKeyboard()
        toUnit.inputView = unitPickerForTo
        
        unitPickerForFrom.delegate = self
        unitPickerForFrom.dataSource = self
        unitPickerForTo.delegate = self
        unitPickerForTo.dataSource = self
    }
    
    // MARK: Picker view methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableUnits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowName = availableUnits[row] as! String
        return rowName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let rowName = availableUnits[row] as! String
        
        if pickerView == unitPickerForFrom {
            fromUnit.text = rowName
            selectedFromUnit = rowName
            
            tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "unitPicker", action: rowName, label: "From Unit", value: nil).build() as [NSObject : AnyObject])
        }
        else {
            toUnit.text = rowName
            selectedToUnit = rowName
            
            tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "unitPicker", action: rowName, label: "To Unit", value: nil).build() as [NSObject : AnyObject])
        }
    }
//    
//    // MARK: Convert Button Pressed
//    @IBAction func convertAction(_ sender: Any) {
//        
//        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "buttonClick", action: "Convert", label: "Convert Button", value: nil).build() as [NSObject : AnyObject])
//        
//        view.endEditing(true)
//        
//        if  unitName != "Temperature" &&
//            ((valueToBeConverted.text?.isEmpty)! ||
//           valueToBeConverted.text == "0") {
//            let mathAlert = MathAlert().createMathAlert(title: "Enter a Value", message: "Please enter a valid value to be converted")
//            
//            present(mathAlert, animated: true);
//        }
//            
//        else if (fromUnit.text?.isEmpty)! ||
//                (toUnit.text?.isEmpty)! {
//            let mathAlert = MathAlert().createMathAlert(title: "Select a Unit", message: "Please select a unit to convert your value")
//            
//            present(mathAlert, animated: true);
//        }
//        
//        else if fromUnit.text == toUnit.text {
//            let mathAlert = MathAlert().createMathAlert(title: "Select a Different Unit", message: "Both units cannot be same. Please select two different units to convert your value")
//            
//            present(mathAlert, animated: true);
//        }
//        else { // Calculating the value
//            let enteredValue = Float(valueToBeConverted.text!)
//            var resultFloatValue = Float()
//            
//            switch unitName {
//            case "Length":
//                lengthConverter.selectedFromUnit = fromUnit.text!
//                lengthConverter.selectedToUnit = toUnit.text!
//                resultFloatValue = lengthConverter.convertValues(value: enteredValue!)
//                
//                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Length", label: "Length Conversion", value: nil).build() as [NSObject : AnyObject])
//                
//                break
//            case "Volume":
//                volumeConverter.selectedFromUnit = fromUnit.text!
//                volumeConverter.selectedToUnit = toUnit.text!
//                resultFloatValue = volumeConverter.convertValues(value: enteredValue!)
//                
//                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Volume", label: "Volume Conversion", value: nil).build() as [NSObject : AnyObject])
//                
//                break
//            case "Weight":
//                massConverter.selectedFromUnit = fromUnit.text!
//                massConverter.selectedToUnit = toUnit.text!
//                resultFloatValue = massConverter.convertValues(value: enteredValue!)
//                
//                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Weight", label: "Weight Conversion", value: nil).build() as [NSObject : AnyObject])
//                
//                break
//            case "Temperature":
//                tempConverter.selectedFromUnit = fromUnit.text!
//                tempConverter.selectedToUnit = toUnit.text!
//                resultFloatValue = tempConverter.convertValues(value: enteredValue!)
//                
//                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Temperature", label: "Temperature Conversion", value: nil).build() as [NSObject : AnyObject])
//                
//                break
//            case "Area":
//                areaConverter.selectedFromUnit = fromUnit.text!
//                areaConverter.selectedToUnit = toUnit.text!
//                resultFloatValue = areaConverter.convertValues(value: enteredValue!)
//                
//                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Area", label: "Area Conversion", value: nil).build() as [NSObject : AnyObject])
//                
//                break
//            default:
//                break
//            }
//            
//            resultValue.text = String(format: "%f", resultFloatValue)
//        }
//    }
    
    // MARK: Convert Value
    func convertValue() {
        
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "valueEntered", action: "Convert", label: "Convert Value", value: nil).build() as [NSObject : AnyObject])
        
        view.endEditing(true)
        
        if  unitName != "Temperature" &&
            valueToBeConverted.text == "0" {
            let mathAlert = MathAlert().createMathAlert(title: "Enter a Value", message: "Please enter a valid value to be converted")
            
            present(mathAlert, animated: true);
        }
            
        else if (fromUnit.text?.isEmpty)! ||
            (toUnit.text?.isEmpty)! {
            let mathAlert = MathAlert().createMathAlert(title: "Select a Unit", message: "Please select a unit to convert your value")
            
            present(mathAlert, animated: true);
        }
            
        else if fromUnit.text == toUnit.text {
            let mathAlert = MathAlert().createMathAlert(title: "Select a Different Unit", message: "Both units cannot be same. Please select two different units to convert your value")
            
            present(mathAlert, animated: true);
        }
        else { // Calculating the value
            let enteredValue = Float(valueToBeConverted.text!)
            var resultFloatValue = Float()
            
            switch unitName {
            case "Length":
                lengthConverter.selectedFromUnit = fromUnit.text!
                lengthConverter.selectedToUnit = toUnit.text!
                resultFloatValue = lengthConverter.convertValues(value: enteredValue!)
                
                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Length", label: "Length Conversion", value: nil).build() as [NSObject : AnyObject])
                
                break
            case "Volume":
                volumeConverter.selectedFromUnit = fromUnit.text!
                volumeConverter.selectedToUnit = toUnit.text!
                resultFloatValue = volumeConverter.convertValues(value: enteredValue!)
                
                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Volume", label: "Volume Conversion", value: nil).build() as [NSObject : AnyObject])
                
                break
            case "Weight":
                massConverter.selectedFromUnit = fromUnit.text!
                massConverter.selectedToUnit = toUnit.text!
                resultFloatValue = massConverter.convertValues(value: enteredValue!)
                
                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Weight", label: "Weight Conversion", value: nil).build() as [NSObject : AnyObject])
                
                break
            case "Temperature":
                tempConverter.selectedFromUnit = fromUnit.text!
                tempConverter.selectedToUnit = toUnit.text!
                resultFloatValue = tempConverter.convertValues(value: enteredValue!)
                
                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Temperature", label: "Temperature Conversion", value: nil).build() as [NSObject : AnyObject])
                
                break
            case "Area":
                areaConverter.selectedFromUnit = fromUnit.text!
                areaConverter.selectedToUnit = toUnit.text!
                resultFloatValue = areaConverter.convertValues(value: enteredValue!)
                
                tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Conversion Type", action: "Area", label: "Area Conversion", value: nil).build() as [NSObject : AnyObject])
                
                break
            default:
                break
            }
            
            resultValue.text = String(format: "%f", resultFloatValue)
        }
    }
    
    // MARK: Reverse Button Pressed
    @IBAction func reverseButtonClicked(_ sender: Any) {
        
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "buttonClick", action: "Reverse", label: "Reverse Button", value: nil).build() as [NSObject : AnyObject])
        
        view.endEditing(true)
        
        if (fromUnit.text?.isEmpty)! ||
            (toUnit.text?.isEmpty)! {
            let mathAlert = MathAlert().createMathAlert(title: "Select a Unit", message: "Please select a unit to convert your value")
            
            present(mathAlert, animated: true);
        }
            
        else if fromUnit.text == toUnit.text {
            let mathAlert = MathAlert().createMathAlert(title: "Select a Different Unit", message: "Both units cannot be same. Please select two different units to convert your value")
            
            present(mathAlert, animated: true);
        }
        
        else if isReversed{
            
            if selectedFromUnit.isEmpty {
                fromUnit.text = availableUnits[0] as? String
            }
            else {
                fromUnit.text = selectedFromUnit
            }
            
            if selectedToUnit.isEmpty {
                toUnit.text = availableUnits[1] as? String
            }
            else {
                toUnit.text = selectedToUnit
            }
            
            isReversed = false
            
            if (valueToBeConverted.text?.characters.count)! > 0 {
                self.convertValue()
            }
        }
        
        else {
            if selectedToUnit.isEmpty {
                fromUnit.text = availableUnits[1] as? String
            }
            else {
                fromUnit.text = selectedToUnit
            }
            
            if selectedFromUnit.isEmpty {
                toUnit.text = availableUnits[0] as? String
            }
            else {
                toUnit.text = selectedFromUnit
            }
            
            isReversed = true
            
            if (valueToBeConverted.text?.characters.count)! > 0 {
                self.convertValue()
            }
        }
    }
    
    // MARK: Add done button to hide the keyboard
    func addToolbarForKeyboard() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneClickOnToolBar))]
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    func doneClickOnToolBar() {
        view.endEditing(true)
        valueToBeConverted.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        valueToBeConverted.resignFirstResponder()
    }
    
    // MARK: Keyboard animation methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == valueTF_TAG {
            if (valueToBeConverted.text?.characters.count)! > 0 {
                self.convertValue()
            }
        }
    }
    
    /*
    func keyboardWillShow(notification: NSNotification) {
        if activeTextField.tag == toUnitTF_TAG {
          if self.view.frame.origin.y == 0 {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.frame.origin.y -= CGFloat(self.kKEYBOARD_CONST + 25)
                })
            }
        }
        else if activeTextField.tag == fromUnitTF_TAG {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                     self.view.frame.origin.y -= CGFloat(self.kKEYBOARD_CONST)
                })
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if activeTextField.tag == toUnitTF_TAG {
           if self.view.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.frame.origin.y += CGFloat(self.kKEYBOARD_CONST + 25)
                })
            }
        }
        else if activeTextField.tag == fromUnitTF_TAG {
            if self.view.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.frame.origin.y += CGFloat(self.kKEYBOARD_CONST)
                })
            }
        }
    }
 */
}
