//
//  ViewController.swift
//  Calculator
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let calc = Calculator()
    var isEdited : Bool = false
    var isNegative : Bool = false
    
    private var result: Int {
        get {
            if let res = Int(onscreenNumbers.text!) {
                return res
            } else {
                return 0
            }
        }
        set {
            onscreenNumbers.text = formatOutput(newValue)
        }
    }
    
    @IBOutlet weak var onscreenNumbers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

extension ViewController {
    
    @IBAction func numberTapped(_ sender: UIButton) {
        print("\(sender.tag) was pressed")
        let number = String(sender.tag)
        if onscreenNumbers.text! == "0" || !isEdited {
            onscreenNumbers.text = number
            isEdited = true
        } else if (onscreenNumbers.text!.count < 10 && isNegative) || (onscreenNumbers.text!.count < 9 && !isNegative) {
            onscreenNumbers.text! += number
            isEdited = true
        }
    }
    
    @IBAction func allClear(_ sender: Any) {
        calc.setSum(number: result)
        isEdited = false
        calc.calculate(action: .clear)
        result = calc.result
        print("Label cleared!")
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        let text = onscreenNumbers.text!
        if text.firstIndex(of: "-") != nil {
            result = text.count != 2 ? removeLast(in: text) : 0
        } else {
            result = text != "0" && text.count != 1 ? removeLast(in: text) : 0
        }
        isEdited = true
        print("Number deleted")
    }
    
    @IBAction func setNegativeNumber(_ sender: Any) {
        if result < 0 {
            onscreenNumbers.text!.remove(at: onscreenNumbers.text!.startIndex)
            isNegative = false
            print("Value set to positive")
        } else if result > 0 {
            onscreenNumbers.text!.insert("-", at: onscreenNumbers.text!.startIndex)
            isNegative = true
            print("Value set to negative")
        }
        print("Value is supposedly 0 and cant be negative")
    }
    
    @IBAction func operation(_ sender: UIButton) {
        calc.setSum(number: result)
        isEdited = false
        switch sender.tag {
        case 0: calc.calculate(action: .add); print("Operation was set to plus")
        case 1: calc.calculate(action: .substract); print("Operation was set to minus")
        case 2: calc.calculate(action: .multiply); print("Operation was set to multiply")
        case 3: calc.calculate(action: .divide); print("Operation was set to divide")
        default: print("No action chosen")
        }
        result = calc.result
    }
    
    @IBAction func result(_ sender: UIButton) {
        calc.setSum(number: result)
        isEdited = false
        calc.calculate(action: .equal)
        result = calc.result
        print("Result is \(onscreenNumbers.text!)")
    }
}

extension ViewController {
    
    private func formatOutput(_ value: Int) -> String {
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
    
    private func setText(with number: Int) {
        result = number
    }
    
    private func removeLast(in string: String) -> Int {
        var result = string
        result.removeLast(1)
        return Int(result) ?? 0
    }
    
}



