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
    private var encryptionButtonIsPressed = false
    
    private func check () -> Bool { // функция проверки вводимых данных
        
        if sizeOfBlockField.hasText {
            for i in sizeOfBlockField.text!.characters {
                if "0"..."9" ~= i { // проверка на вводимость одних только чисел
                        print("Size of block has been entered succesfully")
                    } else {
                        //error
                        print("Error: Only digits should be there!")
                        return false
                    }
            }
        
            if Int(sizeOfBlockField.text!)! >= 1 && Int(sizeOfBlockField.text!)! <= String(textField.text!).characters.count { // размер блока не должен превышать размер сообщения
                sizeOfBlock = Int(sizeOfBlockField.text!)!
            } else {
                //error
                print("Error: < 1 or > size of text")
                return false
            }
        
        } else {
            //error
            print("Error: Size of block field is empty!")
            return false
        }
        
        if textField.hasText {
            for character in String(textField.text!).characters {
                arrayOfCharacters.append(String(character))
            }
            
            // если сообщение можно разбить на блоки заданного размера без остатка
            if  arrayOfCharacters.count % sizeOfBlock  ==  0 { 
                print("Size is okay")
            } else {
                // если нет, то добавляем " " пока не будет выполнено условие
                while arrayOfCharacters.count % sizeOfBlock  !=  0 { 
                    arrayOfCharacters.append(String(" "))
                }
                print(arrayOfCharacters)
            }
            print("Input text has been entered succesfully")
        } else {
            //error
            print("Error: Text field is empty!")
            return false
        }
        
        if orderField.hasText {
            for i in orderField.text!.components(separatedBy: " ") {
                if "0"..."9" ~= i && arrayOfSymbols.contains(i) == false && Int(i)! > 0 { // проверка введенного порядка на вводимость одних только чисел, а так же на повторяемость
                    arrayOfSymbols.append(i)
                } else {
                    // error
                    print("Error: повторения")
                    return false
                }
            }
            
            if arrayOfSymbols.count == sizeOfBlock && Int(arrayOfSymbols.max()!)! <= sizeOfBlock {
                print("Everything is okay")
            } else {
                // error
                print("Error: Array of symbols has been entered with mistakes!")
                return false
            }
        } else {
            // error
            print("Error: Order field is empty!")
            return false
        }
        
        return true
    }
    
    // функция шифрования фрагмента
    private func encryptedFunction(order: [Int], fragment: [String]) -> String {
        var result = ""
        print("Order of symbols: ", order)
        for i in 0...sizeOfBlock - 1 {
            result += fragment[order[i] - 1]
        }
        return result
    }
    
    // функция расшифровки фрагмента сообщения
    private func decryptedFunction(order: [Int], fragment: [String]) -> String {
        var result = Array(repeating: " ", count: order.count)
        print("Order of symbols: ", order)
        for i in 0...order.count - 1 {
            let index = i - 1
            result[order[i] - 1] = fragment[i]
        }
        return result.joined()
    }
    
    // функция разбиения сообщения на блоки; расшифровка / шифровка сообщения
    private func encryptionOfTheMessage(isEncryption: Bool) -> String {
        var resultText = ""
        var i = 0

        repeat {
            var fragment = [String]()
            var fragmentOfMessage = ""
            
            // разбиение на фрагмент и посимвольное добавление в массив
            if i + sizeOfBlock <= arrayOfCharacters.count {
                for j in 0...sizeOfBlock - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += sizeOfBlock
            } else {
                // если этот фрагмент является последним
                for j in i...arrayOfCharacters.count - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += 1
            }
            
            print("Fragment: ", fragment)
            
            if isEncryption {
                // шифровка фрагмента
                fragmentOfMessage = encryptedFunction(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
            } else {
                // расшифровка
                fragmentOfMessage = decryptedFunction(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
            }
            print("Result fragment: ", fragmentOfMessage)
            resultText += fragmentOfMessage // добавление очередного фрагмента к результату
                
            
        } while i < arrayOfCharacters.count
        return resultText
    }
    
    // шифровка сообщения
    @IBAction private func encryptionButton(_ sender: UIButton) {
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []
        encryptedMessageLabel.text = ""

        encryptionButtonIsPressed = true
        
        if check() {
            print("Encryption:")
            let resultText = encryptionOfTheMessage(isEncryption: true) // шифруем заданное сообщение
            print(resultText)
            encryptedMessageLabel.text = resultText
        }
    }
   
    @IBAction func decryptionButton(_ sender: UIButton) { // расшифровка сообщения
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []
        decryptedMessageLabel.text = ""
        
        // проверка на корректность вводимых данных, на то, была ли выполнена шифровка,
        if check() && encryptionButtonIsPressed {
            print("Input text has been entered succesfully")
            print("Decryption:")
            arrayOfCharacters = [] // обнуляем массив для последующего хранения данных
            
            // добавляем символы шифра в массив
            for character in String(encryptedMessageLabel.text!).characters {
                arrayOfCharacters.append(String(character))
            }
            
            // если шифр можно разбить на блоки заданного размера без остатка
            if  String(encryptedMessageLabel.text!).characters.count % Int(sizeOfBlockField.text!)!  ==  0 {
                print("Size is okay")
                
                let resultText = encryptionOfTheMessage(isEncryption: false) // расшифровываем сообщение
                print("Result of decryption: ", resultText)
                decryptedMessageLabel.text = resultText
            } else {
                // если шифр невозможно разбить на блоки заданного размера без остатка
                // error
                decryptedMessageLabel.text = "Error: Decryption is impossible in this case!"
                print("Error: Decryption is impossible in this case")
            }
            print(arrayOfCharacters)
        } else {
            // error
            print("Error: Press the encryptionButton at first, or data has been entered with mistakes.")
        }
        encryptionButtonIsPressed = false
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
