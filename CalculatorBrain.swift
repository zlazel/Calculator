//
//  CalculatorBrain.swift
//  clacolator
//
//  Created by AhmedZlazel on 5/17/18.
//  Copyright © 2018 AhmedZlazel. All rights reserved.
//

import Foundation
enum Optional<T>{
    case None
    case some(T)
}
class CalculatorBrain
{
    private var accumelator = 0.0
    private var internalProgram  = [AnyObject]()
    
    func setOperand (operand:Double) {
        accumelator = operand
        internalProgram.append(operand as AnyObject)
    }
    private var operation:Dictionary<String,Operation> = [
        "C" : Operation.Constant(0.0),
        "∏" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "±" : Operation.UnaryOperation({-$0}),
        "cos" : Operation.UnaryOperation(cos),
        "sin " : Operation.UnaryOperation(sin),
        "×" : Operation.BinaryOperation({ $0 * $1  }),
        "÷" : Operation.BinaryOperation({ $0 / $1  }),
        "+" : Operation.BinaryOperation({ $0 + $1  }),
        "-" : Operation.BinaryOperation({ $0 - $1  }),
        "=" : Operation.equals
    ]
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double)->Double)
        case equals
    }
    func performOperation(symbol:String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operation[symbol]{
            switch operation{
            case .Constant(let x):  accumelator = x
            case .UnaryOperation(let function):accumelator = function(accumelator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperation(binaryFunction:function , firstOperand:accumelator)
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    private func executePendingBinaryOperation(){
        
        if pending != nil{
            accumelator = pending!.binaryFunction(pending!.firstOperand,accumelator)
            pending = nil
        }
    }
    private var pending:PendingBinaryOperation?
    private struct PendingBinaryOperation{
        var binaryFunction :(Double,Double)->Double
        var firstOperand:Double
    }
    
    typealias ProperityList = AnyObject
    var program :ProperityList{
        get{
            return internalProgram as CalculatorBrain.ProperityList
        }
        set{
            clear()
            if let arrOfOps = newValue as? [AnyObject]{
                for op in arrOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }else if let symbol = op as? String {
                        performOperation(symbol: symbol)
                    }
                }
            }

        }
    }
    func clear(){
        accumelator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    var result:Double{
        get{
            return accumelator
        }
    }
}

