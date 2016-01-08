//
//  GraphViewController.swift
//  Calculator
//
//  Created by Nicholas Swekosky on 3/22/15.
//  Copyright (c) 2015 SwekoDev. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var calcBrain = CalculatorBrain()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cvc = segue.destinationViewController as? CalculatorViewController
        {
            if let identifier = segue.identifier
            {
                /*switch identifier
                {
                    case "Graph":
                    
                }*/
            }
        }
    }

}
