//
//  ViewController.swift
//  IBZI_Lab1
//
//  Created by Sviridova Evgenia on 11.09.17.
//  Copyright © 2017 Sviridova Evgenia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sizeOfBlockField: UITextField!
    @IBOutlet weak var orderField: UITextField!
    
    @IBOutlet weak var encryptedMessageLabel: UILabel!
    @IBOutlet weak var decryptedMessageLabel: UILabel!
    
    private var sizeOfBlock: Int = 0
    private var arrayOfSymbols = [String]()
    private var arrayOfCharacters = [String]()
    
    private func check () {
        
        if sizeOfBlockField.hasText && sizeOfBlock >= 1 {
            print("Size of block has been entered succesfully")
        } else {
            //error
            print("Error: Size of block field is empty!")
        }
        
        if textField.hasText {
            print("Input text has been entered succesfully")
            
            for character in String(textField.text!).characters {
                arrayOfCharacters.append(String(character))
            }
            
            if  arrayOfCharacters.count % sizeOfBlock  ==  0 {
                print("Size is okay")
            } else {
                
                while arrayOfCharacters.count % sizeOfBlock  !=  0 {
                    arrayOfCharacters.append(String("_"))
                }
                print(arrayOfCharacters)
            }
        } else {
            //exception
            print("Error: Text field is empty!")
        }
        
        if orderField.hasText {
            arrayOfSymbols = orderField.text!.components(separatedBy: " ")
            
            for i in arrayOfSymbols {
                if "0"..."9" ~= i {
                    print("Order consists of digits only")
                } else {
                    print("Error: Only digits should be there!")
                }
            }
            
            if arrayOfSymbols.count == sizeOfBlock {
                print("Everything is okay")
            } else {
                print("Error: Size of array of symbols is incorrect!")
            }
        } else {
            print("Error: Order field is empty!")
        }
    }
    
    @IBAction private func encryptionButton(_ sender: UIButton) {
        sizeOfBlock = Int(sizeOfBlockField.text!)!
        
        func cryptTheMessage (order: [Int], fragment: [String]) -> String {
            var result = ""
            for i in 0...sizeOfBlock - 1 {
                result += fragment[order[i] - 1]
            }
            return result
        }
        
        check()
        
        var resultText = ""
        var i = 0

        repeat {
            var fragment = [String]()

            if i + sizeOfBlock <= arrayOfCharacters.count {
                for j in 0...sizeOfBlock - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += sizeOfBlock
            } else {
                for j in i...arrayOfCharacters.count - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += 1
                }
            
            print("res:", fragment)
            
            let cryptedMessage = cryptTheMessage(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
            print("Crypted message: ", cryptedMessage)

            resultText += cryptedMessage
            
        } while i < arrayOfCharacters.count
        
        print(resultText)
        
        encryptedMessageLabel.text = resultText
        resultText = ""
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []
        
    }
   
    @IBAction func decryptionButton(_ sender: UIButton) {
        sizeOfBlock = Int(sizeOfBlockField.text!)!
        
        func decryptTheMessage (order: [Int], fragment: [String]) -> String {
            var result = ""
            for i in 0...sizeOfBlock - 1 {
                result += fragment[order[i] - 1]
            }
            return result
        }

        check()

        var resultText = ""
        var i = 0
        
        repeat {
            var fragment = [String]()
            
            if i + sizeOfBlock <= arrayOfCharacters.count {
                for j in 0...sizeOfBlock - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += sizeOfBlock
            } else {
                for j in i...arrayOfCharacters.count - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += 1
            }
           
            print("res:", fragment)
            
            let decryptedMessage = decryptTheMessage(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
            print("Crypted message: ", decryptedMessage)
            
            resultText += decryptedMessage
            
        } while i < arrayOfCharacters.count
        
        print(resultText)
        
        decryptedMessageLabel.text = resultText
        resultText = ""
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
