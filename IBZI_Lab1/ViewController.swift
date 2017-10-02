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
    
    private func check () -> Bool {
        
        if sizeOfBlockField.hasText {
            for i in sizeOfBlockField.text!.characters {
                if "0"..."9" ~= i {
                        print("Size of block has been entered succesfully")
                    } else {
                        print("Error: Only digits should be there!")
                        return false
                    }
            }
        
            if Int(sizeOfBlockField.text!)! >= 1 && Int(sizeOfBlockField.text!)! <= String(textField.text!).characters.count {
                sizeOfBlock = Int(sizeOfBlockField.text!)!
            } else {
                print("Error: < 1 or > size of text")
                return false
            }
        
        } else {
                //error
                print("Error: Size of block field is empty!")
                return false
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
            return false
        }
        
        if orderField.hasText {
            arrayOfSymbols = []
            
            for i in orderField.text!.components(separatedBy: " ") {
                if "0"..."9" ~= i && arrayOfSymbols.contains(i) == false && Int(i)! > 0 {
                    arrayOfSymbols.append(i)
                } else {
                    print("Error: повторения")
                    return false
                }
            }
            
            if arrayOfSymbols.count == sizeOfBlock && Int(arrayOfSymbols.max()!)! <= sizeOfBlock {
                print("Everything is okay")
            } else {
                print("Error: Array of symbols has been entered with mistakes!")
                return false
            }
        } else {
            print("Error: Order field is empty!")
            return false
        }
        
        return true
    }
    
    private func encryptedFunction(order: [Int], fragment: [String]) -> String {
        var result = ""
        for i in 0...sizeOfBlock - 1 {
            result += fragment[order[i] - 1]
        }
        return result
    }
    
    private func encryptionOfTheMessage() -> String {
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
            let resultMessage = encryptedFunction(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
            print("Decrypted message: ", resultMessage)
            resultText += resultMessage
            
        } while i < arrayOfCharacters.count
        
        return resultText
    }
    
    @IBAction private func encryptionButton(_ sender: UIButton) {
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []

        if check() {
            let resultText = encryptionOfTheMessage()
            print(resultText)
            encryptedMessageLabel.text = resultText
        }
    }
   
    @IBAction func decryptionButton(_ sender: UIButton) {
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []
        
        if textField.hasText {
            print("Input text has been entered succesfully")
            if  String(textField.text!).characters.count % Int(sizeOfBlockField.text!)!  ==  0 {
                print("Size is okay")
                if check() {
                    let resultText = encryptionOfTheMessage()
                    print(resultText)
                    decryptedMessageLabel.text = resultText
                }
            } else {
                decryptedMessageLabel.text = "Error: Decryption is impossible in this case!"
                print("Error: Decryption is impossible in this case")
                }
                print(arrayOfCharacters)
        } else {
            //exception
            print("Error: Text field is empty!")
        }
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
