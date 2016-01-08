//
//  ViewController.swift
//  Calculator
//
//  Created by Nicholas Swekosky on 3/14/15.
//  Copyright (c) 2015 SwekoDev. All rights reserved.
//

import UIKit


/****************************************
 ** Controller to provide the values
 ** for the calculator app.
 ****************************************/
class CalculatorViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInMiddleOfTypingOperand = false
    
    var brain = CalculatorBrain()
    
    var displayValue: Double?
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set
        {
            display.text = "\(newValue!)"
            userIsInMiddleOfTypingOperand = false
        }
    }
    
    
    
    /****************************************
    ** Performs the operation based off the 
    ** operator that is chosen.
    **
    ** @Param sender
    ****************************************/
    @IBAction func operate(sender: UIButton) {
        if userIsInMiddleOfTypingOperand
        {
            let operation = sender.currentTitle!
        }
        
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation)
            {
                displayValue = result
                display.text = "= " + "\(displayValue!)"
            }
            else
            {
                displayValue = 0
            }
            
        }
        
        
        
        //////////////////////////////
        // Update the history label //
        //////////////////////////////
        updateHistory()
    }
    
    
    
    /****************************************
     ** Press the enter key to either complete
     ** the entering of the number or to 
     ** complete an operation.
     **
     ****************************************/
    @IBAction func enter()
    {
        userIsInMiddleOfTypingOperand = false
        
        ////////////////////////////////////////////
        // Options are for pi, any operand, or no //
        // operand.                               //
        ////////////////////////////////////////////
        if display.text == "∏"
        {
            brain.pushOperand(3.14159265359)
        }
        else if let result = brain.pushOperand(displayValue!)
        {
            displayValue = result
        }
        else
        {
            display.text = " "
        }
        
        
        //////////////////////////////
        // Update the history label //
        //////////////////////////////
        updateHistory()
    }
    
    
    
    /****************************************
    ** This button allows the app to clear the 
    ** display and start again.
    **
    ****************************************/
    @IBAction func clear() {
        display.text! = " "
        historyDisplay.text! = " "
        brain.variableValues.removeAll()
    }
    
    
    
    /****************************************
    ** Invert the number to either the positive
    ** or the negative form. Method lets the
    ** user continue to add numbers even if
    ** they are in between still typing.
    **
    ****************************************/
    @IBAction func inversion() {
        let newDisplayValue = displayValue! * -1
        display.text = "\(newDisplayValue)"
    }
    
    
    
    /****************************************
     ** Either set the digit or append the
     ** digit to the previous digit.
     **
     ** @Param sender
     ****************************************/
    @IBAction func digit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        //////////////////////////////////////////
        // Either set the display or append the //
        // digit to the current diplay value.   //
        //////////////////////////////////////////
        if(userIsInMiddleOfTypingOperand)
        {
            ////////////////////////////////////////////////
            // Add the label of the current button to the //
            // display.                                   //
            ////////////////////////////////////////////////
            display.text = display.text! + digit
        }
        else
        {
            //////////////////////////////////////////////////
            // Set the display to the first button pressed. //
            // Also, set the boolean value to true so that  //
            // the other values are appended to the current //
            // value                                        //
            //////////////////////////////////////////////////
            display.text = digit
            userIsInMiddleOfTypingOperand = true
        }
    }
    
    
    @IBAction func pushVariable() {
        brain.pushOperand("M")
        
        updateHistory()
    }
    
    
    @IBAction func setVariable() {
    
        ///////////////////////////////////////////////////////
        // Set the variable M with the current display value //
        ///////////////////////////////////////////////////////
        brain.variableValues["M"] = displayValue!
        
        if let value = brain.evaluate()
        {
            display.text = "\(value)"
            enter()
        }
        
        userIsInMiddleOfTypingOperand = false
        updateHistory()
    }
    
    
    // FINISH IN THE FUTURE. 
    @IBAction func undo() {
        /*if userIsInMiddleOfTypingOperand
        {
            backSpace()
            enter()
        }
        else
        {
            //////////////////////////////////////////
            // Remove the last element in the stack //
            //////////////////////////////////////////
            var opStack = brain.opStack
            opStack.removeLast()
            
        }*/
    }
    
    
    
    func backSpace()
    {
     //   let numberOfCharactersInDisplay: Int = display.text!.utf16Count
        dropLastElementOfDisplay(display.text!)
    }
    
    
    
    func dropLastElementOfDisplay(display: String) -> String
    {
        var characterArray = Array(display)
        characterArray.removeLast()
        
        var newString =  "\(characterArray)"
        
        return (newString)
    }
    
    
    
    /****************************************
    ** Updates the history with the current
    ** operand or operator.
    **
    ** @Param value
    ****************************************/
    private func updateHistory()
    {
        historyDisplay.text = "History: " + brain.description
    }
}

