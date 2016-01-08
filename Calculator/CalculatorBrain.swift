//
//  Calculator Brain.swift
//  Calculator
//
//  Created by Nicholas Swekosky on 3/14/15.
//  Copyright (c) 2015 SwekoDev. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var knownOps = [String:Op]()
    
    var opStack = [Op]()
    
    var variableValues = [String : Double]()
 
    var description: String
    {
        let (result, remainder) = newDescription(opStack)
        if let answer = result
        {
            return answer
        }
        return " "
    }
    
    
    
    /************************************************
    ** Serves as the helper function for retrieving
    ** the description for the operation occuring
    **
    *************************************************/
    private func newDescription(ops: [Op]) -> (result: String?, remainingOps: [Op])
    {
        if(!ops.isEmpty)
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(_, _):
                let operandEvaluation = newDescription(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return ("\(op.description)(\(operand))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, _):
                let op1Evaluation = newDescription(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = newDescription(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        if ((op.description == "÷") || (op.description == "−"))
                        {
                            return ("\(operand2) \(op.description) \(operand1)", op2Evaluation.remainingOps)
                        }
                        else if ((op.description == "+") || (op.description == "×"))
                        {
                            return ("\(operand1) \(op.description) \(operand2)", op2Evaluation.remainingOps)

                        }
                    }
                }
            case .Variable(let variable):
                return (variable, remainingOps)
            }
        }
        return (nil, ops)
    }
    
    
    /****************************************
    ** Serves as the data type that we work 
    ** with. Will be either an operand, an 
    ** operation, or a variable that represents
    ** a value.
    **
    ****************************************/
    enum Op: Printable
    {
        case Operand (Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        
        var description: String
        {
            get {
                switch self{
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                    case .Variable(let variable):
                        return variable
                }
            }
        }
    }
    
//      
//
//    typealias PropertyList = AnyObject //PropertyList is an alias for AnyObject
//    var program: PropertyList { // guaranteed to be a property list
//        get { // get teh property list representation of our internal data structure
//            return opStack.map { $0.description }
//        }
//        set { // take teh property list and turn it back into the private representation
//            if let opSymbols = newValue as? [String]
//            {
//                var newOpStack = [Op]()
//                for opSymbol in opSymbols
//                {
//                    if let op = knownOps[opSymbol]
//                    {
//                        newOpStack.append(op)
//                    }
//                    else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue
//                    {
//                        newOpStack.append(.Operand(operand))
//                    }
//                }
//                opStack = newOpStack
//            }
//        }
//    }
    
    
    
    /****************************************
    ** initializes a Calculator Brain object.
    **
    ****************************************/
    init()
    {
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        //learnOp(Op.BinaryOperation(", <#(Double, Double) -> Double##(Double, Double) -> Double#>)
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
    }
    
    
    
    /****************************************
    ** Serves function for adding an operand
    ** to the opStack
    **
    ** @Param operand
    ****************************************/
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
    
    /****************************************
    ** Serves function for adding an operand
    ** to the opStack
    **
    ** @Param operand
    ****************************************/
    func pushOperand(variable: String) -> Double?
    {
        opStack.append(Op.Variable(variable))
        return evaluate()
    }
    
    
    
    /****************************************
    ** Serves as the function for adding 
    ** an operation to the history stack.
    **
    ** @Param symbol
    ****************************************/
    func performOperation(symbol: String) -> Double?
    {
        //whenever you look up something in a dictionary, it returns an optional
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    
    
    
    /****************************************
    ** Evaluate function to evaluate a 
    ** calculator expression
    **
    ****************************************/
    private func evaluate( ops: [Op]) -> (result: Double?,remainingOps: [Op])
    {
        if(!ops.isEmpty)
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
                case .Operand(let operand):
                    return (operand, remainingOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result
                    {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result
                    {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result
                        {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
                case .Variable(let variable):
                    if let doubleValue = variableValues[variable]
                    {
                        return (doubleValue, remainingOps)
                    }
                    else
                    {
                        return (nil, remainingOps)
                    }
            }
        }
        return (nil, ops)
    }
    
    
    
    
    /****************************************
    ** Wrapper function for evaluate function
    **
    ****************************************/
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
}