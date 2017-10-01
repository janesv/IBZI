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
    
    @IBAction func encryptionButton(_ sender: UIButton) {
        
        let sizeOfBlock: Int = Int(sizeOfBlockField.text!)!
        var arrayOfSymbols = [String]()
        var arrayOfCharacters = [String]()
        
        func cryptTheMessage (order: [Int], fragment: [String]) -> String {
            var result = ""
            for i in 0...sizeOfBlock - 1 {
                result += fragment[order[i] - 1]
            }
            
            return result
        }
        
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
                
                repeat {
                    
                    arrayOfCharacters.append(String("_"))
                
                } while arrayOfCharacters.count % sizeOfBlock  ==  0
                
                print(arrayOfCharacters)
                
                }
        } else {
            
            //exception
            print("Error: Text field is empty!")
        }
        
        
        if orderField.hasText {
            
            arrayOfSymbols = orderField.text!.components(separatedBy: " ")
            
            //arrayOfSymbols = arrayOfSymbols.flatMap({Int($0)})
            
            if arrayOfSymbols.count == sizeOfBlock {
                
                print("Everything is okay")
            
            } else {
                
                print("Error: Size of array of symbols is incorrect!")
            }
        } else {
            print("Error: Order field is empty!")
        }
        
        var resultText = ""
        var i = 0

        repeat {
            var fragment = [String]()

            if i + sizeOfBlock <= arrayOfCharacters.count {
                for j in 0...sizeOfBlock - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                    i += 1
                }
                
                print("res:", fragment)
                
                let cryptedMessage = cryptTheMessage(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
                print("Crypted message: ", cryptedMessage)
                
                resultText += cryptedMessage

            } else {
                for j in i...arrayOfCharacters.count - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                
                print("res:", fragment)
                
                let cryptedMessage = cryptTheMessage(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
                print("Crypted message: ", cryptedMessage)
                
                resultText += cryptedMessage
                
                i += 1
                }
            
            
            
        } while i < arrayOfCharacters.count
        
        
        
        
    }
   
    @IBAction func decryptionButton(_ sender: UIButton) {
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
