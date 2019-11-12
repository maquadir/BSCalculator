//
//  ViewController.swift
//  BSCalculator
//
//  Created by Quadir on 11/11/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Declare UI variables
    @IBOutlet weak var operationLabel: UILabel!      //Label where user inputs characters
    @IBOutlet weak var resultLabel: UILabel!         //Label which displays calculatedresult
    @IBOutlet weak var operationView: UIView!        //View of the input label
    @IBOutlet weak var keypadView: UIView!           //View of the calculator
    @IBOutlet weak var resultView: UIView!           //View of the result label
    
    //Declare program variables
    var decimal_dflag = 0                            //Flag for decimal operations
    var decimal_eflag = 0                            //Flag for decimal operations
    var pastChar:NSString = ""                       //NSString for storing previous character
    public var inputString:String! = ""              //String for storing input string
    public var currentOperation:String! = ""         //String for storing operator
    public var result:String! = ""                   //String for storing result
    public var digit: String! = ""                   //String for storing input character
    public var inputOperator:String! = ""            //String for storing operator
    public var inputString_temp:String!              //Temporary String for storing input string
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Update views with corners and background shadows
        updateOperationView()
        updateKeyPadView()
        updateResultView()
        
    }
    
    func updateOperationView(){
        operationView.layer.cornerRadius = 20.0
        operationView.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        operationView.layer.shadowOpacity = 0.3
        operationView.layer.shadowRadius = 5.0;
        operationView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func updateKeyPadView(){
        keypadView.layer.cornerRadius = 20.0
        keypadView.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        keypadView.layer.shadowOpacity = 0.3
        keypadView.layer.shadowRadius = 5.0;
        keypadView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func updateResultView(){
        resultView.layer.cornerRadius = 20.0
    }
    
    @IBAction func digitPressed(_ sender: AnyObject) {
       
       //Extract digit value
       digit = sender.currentTitle
                   
       if decimal_eflag == 0 {
       if !(result == "0"){
        
           //Update text in label
           updateScreen()}
           
           //Code to avoid consecutive dots ... in expression
           if (digit == ".") {
               if (decimal_dflag == 0) {
                   inputString = inputString.appending(digit)
               }else
               {
                   return
               }
               decimal_dflag = 1;
               updateScreen()
           
           } else {
           //Append typed characters
           inputString = inputString.appending(digit)
           updateScreen()
           }
       }
    }
    
    @IBAction func operatorPressed(_ sender: AnyObject) {
                     
          if decimal_eflag == 0 {
                decimal_dflag = 0
             
                //Extract the entered operator
                inputOperator = sender.currentTitle
             
                if !(inputString == ""){
                    result = "0"
                }
               
                if !(result == "0"){
                    
                    let _inputDisplay = result
                    clear()
                    inputString = _inputDisplay
                }
                
                if(currentOperation != ""){
                    
                    if (inputString != ""){
                        
                        if (isOperator(inputString.last!)){
                                 
                             if inputOperator == "-" {
                                //To elimidate - -

                                 let c:Character = inputString.last!
                                         
                                //TO include - after any other operator(+,x,/) except -
                                      if c == "-"
                                        {
                                         if isOperator(inputString.last!) {return}
                                        }
                                //To add '-' after 'x' and '÷'
                                         if (c == "×" || c == "÷" || c == "%")
                                         {
                                             inputString = inputString.appending(inputOperator)
                                             updateScreen()
                                             return
                                         }
                            }
                                    
            //TO replace last 2 operators with a single operartor ( eg replace "x-" with "+")
                            if inputString.count >= 2 {
                                 
                                let offsetValue1 = inputString.count - 2
                                // let offsetValue2 = inputString.characters.count - 1
                                let index = inputString.index(inputString.startIndex, offsetBy: offsetValue1)

                               if isOperator(inputString.last!) && isOperator(inputString[index]) {
                                    let range = inputString.index(inputString.endIndex, offsetBy: -2)..<inputString.endIndex
                
                                    inputString.removeSubrange(range)
                                    inputString = inputString.appending(inputOperator)
                                 
                                }else{
                             
                                    let range = inputString.index(inputString.endIndex, offsetBy: -1)..<inputString.endIndex
                                 
                                    inputString.removeSubrange(range)
                                    inputString = inputString.appending(inputOperator)
                                    currentOperation = inputOperator

                                }
                             }
                                     updateScreen()
                                     return
                                     
                             }
                                 
                             else {
                                     
                                     getResult()//ignore warning- function calculates result
                                     inputString = result;
                                     result = "0"
                             }
                                currentOperation = inputOperator
                                   
                            }
                    }
                        inputString_temp = inputOperator
                        if (inputString_temp != "-") {
                         
                     //To not allow operators ,except '-', to be inserted as the first character of inputString
                            if (inputString == "") && isOperator(inputString_temp.last!){
                                return
                            }
                        }
                           inputString += inputOperator
                           currentOperation = inputOperator
                           updateScreen()
                    }
                 
       }
          
    @IBAction func equalPressed(_ sender: AnyObject) {
           
        //If operation is blank return from this function
        if (inputString == "") {return}
        //If operation is not blank then get result of operation
                 if !getResult() {return}
                     
                     //If result is infinity inputString infinity else inputString the calculated output
                     if result == "Infnity" {
                     
                       self.resultLabel.text = result
                        
                     }else{

                        resultLabel.text = result
                     }
                            
      }
          
    @IBAction func clearPressed(_ sender: AnyObject) {
        //Initialize all labels and variables
            decimal_dflag = 0
            decimal_eflag = 0
            clear()
        
        //Update screen labels , the operation and the output result to "0"
            updateScreen()
            result = "0"
            self.resultLabel.text = String(result)
            self.operationLabel.text = String(result)
    }
           
    @IBAction func deletePressed(_ sender: AnyObject) {
           //Delete single character at a time by going backspace
           var s:NSString = inputString as NSString
                     
                   if s == "" {
                     
                     }else{
                         
                         pastChar = s.substring(from: s.length - 1) as NSString
                         s = s.substring(to: s.length - 1) as NSString
                         inputString = s as String
                         operationLabel.text = inputString
                         
                         if pastChar as String == currentOperation {
                         
                         pastChar = ""
                         currentOperation = ""
                         
                         }
                     }
                     
     }
       
    func clear() ->Void{
        //Clear all variables and set result to "0"
            inputString = "";
            currentOperation = "";
            result = "0";
            
    }
       
    func updateScreen() ->Void{
       //Update operation label
       self.operationLabel.text = inputString
                 
     }
          
    func getResult() -> Bool {
        //If no operation is specified then return false and abort function
        if (currentOperation == "") {return false}
               
                //if operation and operand is entered then extra the entered user input
               let minus = String(describing: inputString.first)
               var operation:Array<String> = inputString.components(separatedBy: currentOperation)
               //If input count is < 2 then abort function
               let count = operation.count
               if (count < 2) {return false}
                     
                     //Take number inputs into variables
                     let operand1 = operation[0]
                     let operand2 = operation[1]
                     
                     //Implement patterns for the operands
                     let pat1 = "\\-*\\d*(\\.\\d)*"
                     let pat2 = "\\-*\\d*\\.*\\d+"
                     
                     
                     let op1Regex = try! NSRegularExpression(pattern: pat1, options: [])
                     let op2Regex = try! NSRegularExpression(pattern: pat2, options: [])
                     
                    
                     let matches1 = op1Regex.firstMatch(in: operand1, options: [], range: NSMakeRange(0, operand1.count))
                     
                     let matches2 = op2Regex.firstMatch(in: operand2, options: [], range: NSMakeRange(0, operand2.count))
                     
                     if (matches1 != nil) && (matches2 != nil) {
                       
                         //To implement cases like "-9-6" where operation length = 3

                         if operation.count == 3 {
                         
                            //Exceptional case when operator is '-'
                             if (minus == "-" && currentOperation == "-") {
                             
                                 if (operation[0] == "" && !operation[1].isEmpty  && !operation[2].isEmpty) {
                                 
                                     operation[0] = minus.appending(operation[1])
                                     operation[1] = operation[2]
                                     
                                 }
                             }
                             
                         }
                         
                        //Remove "," character from operands before inputDisplaying the output
                        if(operation[0].contains(",")){
                           operation[0] = operation[0].replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                        }else if(operation[1].contains(",")){
                           operation[1] = operation[1].replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                        }
                        
                        //Calculate the result by performing the operation
                         result = String(operate(operation[0], b: operation[1],op: currentOperation))
                      
                         let d = Double(result)
                                 
                         //Code to use decimal in operands
                         if (d! - floor(d!) != 0){
                                                     
                               result =  NumberFormatter.localizedString(from: NSNumber(value: d!), number: NumberFormatter.Style.decimal)
                                   
                                 }else{
                                 
                               result =  NumberFormatter.localizedString(from: NSNumber(value: d!), number: NumberFormatter.Style.decimal)
                         }
                         return true
                         
                     }else{
                     
                         return false
                     }
                 
    }

    func operate(_ a:String,b:String,op:String) -> Double {
                     
            //Perform the calculation based on the operator entered by the user
            switch op {
                 
                case "+":
                         
                    return Double(a)! + Double(b)!
                    
                case "×":
                    
                    return Double(a)! * Double(b)!
                
                case "-":
                    if a == "" {
                    
                    return -Double(b)!
                    
                    }
                    else{
                    return Double(a)! - Double(b)!
                    
                    }
                case "÷":
                    
                    return Double(a)! / Double(b)!
                
                case "%":
                
                    return (Double(a)!/100) * Double(b)!
                    
                default:
                         return -1
                     
                     
                     }
                 
       }
          
    func isOperator(_ op: Character) ->Bool{
        //Code to check if the character is an operator
         switch op {
              case "+" :
                  return true
              case "×" :
                  return true
              case "-" :
                  return true
              case "÷" :
                  return true
              case "%" :
                  return true
              default :
                  return false
                  
              }
          }

}

