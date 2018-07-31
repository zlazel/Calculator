//
//  ViewController.swift
//  clacolator
//
//  Created by AhmedZlazel on 5/16/18.
//  Copyright © 2018 AhmedZlazel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    private var userInMiddleTypping = false
  /*  func Display(d:Double)->String{
        get{return d}
        set{
    }
*/

    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let displayedValue = display.text!
        if userInMiddleTypping{
          display.text = displayedValue + digit
        }else{
          display.text = digit
            userInMiddleTypping = true
        }
    }
   private var displayValue:Double {
        get{
             return Double(display.text!)!
        }
        set{
             display.text = String(newValue)
        }
    }
    private var brain = CalculatorBrain()
    @IBAction private func performOperation(_ sender: UIButton) {
        if userInMiddleTypping {
            brain.setOperand(operand: displayValue)
        userInMiddleTypping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathSymbol)
        }
        displayValue = brain.result
        
        }
    var savedProgram:CalculatorBrain.ProperityList?
    
    @IBAction func save() {
    savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
        
        }
    }
    
    
    }

