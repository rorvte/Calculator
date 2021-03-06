//
//  ViewController.swift
//  Calculator
//
//  Created by yolanda yuan on 8/6/2017.
//  Copyright © 2017 yolanda yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //使用_weak关键字 防止closure循环引用
        brain.addUnaryOperation(named: "✅") { [weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    //unwrap 做的事情 (!)就是提取 .Some 中的 value 变量
    @IBOutlet weak var display: UILabel!
    
    var userInTheMiddleOfTyping = false {
        didSet {
            if !userInTheMiddleOfTyping {
                userInTheMiddleOfFloatingtyping = false
            }
        }
    }
    var userInTheMiddleOfFloatingtyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if userInTheMiddleOfFloatingtyping {
                return
            }
            
            if !userInTheMiddleOfTyping {
                digit = "0."
            }
            
            userInTheMiddleOfFloatingtyping = true
        }
        
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }else {
            display.text = digit
            userInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
           display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

