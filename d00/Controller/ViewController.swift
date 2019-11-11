//
//  ViewController.swift
//  Calculator
//
//  Created by Steve Vovchyna on 03.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

protocol FixedWidthInteger {
    
}

class ViewController: UIViewController {
    
    var left : Int = 0
    var right : Int = 0
    var operation : String = ""
    var newNumber : Bool = true
    var isNegative : Bool = false

    @IBOutlet weak var onscreenNumbers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func numberTapped(_ sender: UIButton) {
        print("Button pressed: \(sender.tag)")
        if (onscreenNumbers.text!.count < 9 && !isNegative) || (onscreenNumbers.text!.count < 10 && isNegative) || newNumber {
            if newNumber || onscreenNumbers.text! == "0" {
                setLabel(output: String(sender.tag))
                let numberOnScreen = onscreenNumbers?.text ?? "1"
                right = NSDecimalNumber(string: numberOnScreen) as! Int
                newNumber = false
            } else {
                onscreenNumbers.text! += String(sender.tag)
                let numberOnScreen = onscreenNumbers?.text ?? "1"
                right = NSDecimalNumber(string: numberOnScreen) as! Int
            }
        }
    }
    
    @IBAction func allClear(_ sender: Any) {
        print("Label cleared!")
        setLabel(output: "0")
        resetValues()
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if let _ = onscreenNumbers.text!.firstIndex(of: "e") {
            setLabel(output: "0")
        } else if isNegative {
            if onscreenNumbers.text!.count > 2 {
                setLabel(output: String(onscreenNumbers.text!.dropLast()))
                let numberOnScreen = onscreenNumbers?.text ?? "1"
                right = NSDecimalNumber(string: numberOnScreen) as! Int
            } else if onscreenNumbers.text!.count == 2, let _ = onscreenNumbers.text!.firstIndex(of: "-") {
                setLabel(output: "0")
                isNegative = false
                let numberOnScreen = onscreenNumbers?.text ?? "1"
                right = NSDecimalNumber(string: numberOnScreen) as! Int
            }
        } else {
            if onscreenNumbers.text!.count != 1 {
                setLabel(output: String(onscreenNumbers.text!.dropLast()))
                let numberOnScreen = onscreenNumbers?.text ?? "1"
                right = NSDecimalNumber(string: numberOnScreen) as! Int
            } else if onscreenNumbers.text!.count == 1 && onscreenNumbers.text! != "0" {
                setLabel(output: "0")
                let numberOnScreen = onscreenNumbers?.text ?? "1"
                right = NSDecimalNumber(string: numberOnScreen) as! Int
            }
        }
        print("Number deleted")
    }
    
    
    @IBAction func setNegativeNumber(_ sender: Any) {
        if let i = onscreenNumbers.text!.firstIndex(of: "-") {
            onscreenNumbers.text!.remove(at: i)
            isNegative = false
            print("Value set to positive")
        } else {
            if onscreenNumbers.text! != "0" {
                setLabel(output: "-\(onscreenNumbers.text!)")
                isNegative = true
                print("Value set to negative")
            }
        }
    }
    
    @IBAction func operation(_ sender: UIButton) {
        let numberOnScreen = onscreenNumbers?.text ?? "1"
        if operation == "" {
            left = NSDecimalNumber(string: numberOnScreen) as! Int
        } else {
            let result = calculator()
            print("Result: \(result). Left: \(left). Right: \(right). Operation: \(operation)")
            operation = ""
            if result == "Error" {
                setLabel(output: "Error")
            } else {
                setLabel(output: formatOutput(Int(result)!))
                left = NSDecimalNumber(string: result) as! Int
            }
        }
        newNumber = true
        switch sender.tag {
        case 0:
            operation = "plus"
        case 1:
            operation = "minus"
        case 2:
            operation = "multiply"
        case 3:
            operation = "divide"
        default:
            operation = ""
        }
        print("Operation is now : \(operation)")
    }
   
    @IBAction func result(_ sender: UIButton) {
        newNumber = true
        let result = calculator()
        print("Result: \(result). Left: \(left). Right: \(right). Operation: \(operation)")
        operation = ""
        if result == "Error" {
            setLabel(output: "Error")
        } else {
            setLabel(output: formatOutput(Int(result)!))
            left = NSDecimalNumber(string: result) as! Int
        }
    }
    
    func calculator() -> String {
        switch operation {
        case "plus":
            let result = left.addingReportingOverflow(right)
            if result.1 {
                resetValues()
                return "Error"
            } else {
                return String(result.0)
            }
        case "minus":
            let result = left.subtractingReportingOverflow(right)
            if result.1 {
                resetValues()
                return "Error"
            } else {
                return String(result.0)
            }
        case "multiply":
            let result = left.multipliedReportingOverflow(by: right)
            if result.1 {
                resetValues()
                return "Error"
            } else {
                return String(result.0)
            }
        case "divide":
            if right == 0 {
                return "Error"
            } else {
                let result = left.dividedReportingOverflow(by: right)
                if result.1 {
                    resetValues()
                    return "Error"
                } else {
                    return String(result.0)
                }
            }
        case "":
            return String(left)
        default:
            resetValues()
            print("error")
            return "Error"
        }
    }
    
    func setLabel(output : String) {
        if let _ = output.firstIndex(of: "-") {
            isNegative = true
        } else {
            isNegative = false
        }
        onscreenNumbers.text = output
    }
    
    func resetValues() {
        left = 0
        right = 0
        operation = ""
        newNumber = true
        isNegative = false
    }
    
    func formatOutput(_ value: Int) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: value)
        
        if value > 999999999 || value < -999999999{
            formatter.numberStyle = .scientific
            formatter.exponentSymbol = "e"
        }

        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        
        return String(formatter.string(from: number) ?? "")
    }
    
}

