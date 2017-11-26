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
            if  arrayOfCharacters.count % sizeOfBlock  ==  0 { // если сообщение можно разбить на блоки заданного размера без остатка
                print("Size is okay")
            } else {
                while arrayOfCharacters.count % sizeOfBlock  !=  0 { // если нет, то добавляем "_" пока не будет выполнено условие
                    arrayOfCharacters.append(String("_"))
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
    
    private func encryptedFunction(order: [Int], fragment: [String]) -> String { // расшифровка / шифровка заданного фрагмента
        var result = ""
        for i in 0...sizeOfBlock - 1 {
            result += fragment[order[i] - 1]
        }
        return result
    }
    
    private func encryptionOfTheMessage() -> String { // расшифровка / шифровка сообщения
        var resultText = ""
        var i = 0

        repeat {
            var fragment = [String]()
            
            if i + sizeOfBlock <= arrayOfCharacters.count { // разбиение на фрагмент и посимвольное добавление в массив
                for j in 0...sizeOfBlock - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += sizeOfBlock
            } else { // если этот фрагмент является последним
                for j in i...arrayOfCharacters.count - 1 {
                    let index = arrayOfCharacters.index(after: j + i) - 1
                    print(index)
                    fragment.append(arrayOfCharacters[index])
                }
                i += 1
            }
            
            print("res:", fragment)
            // расшифровка / шифровка фрагмента:
            let fragmentOfMessage = encryptedFunction(order: arrayOfSymbols.flatMap({Int($0)}), fragment: fragment)
            print("Result message: ", fragmentOfMessage)
            resultText += fragmentOfMessage // добавление очередного фрагмента к результату
            
        } while i < arrayOfCharacters.count
        
        return resultText
    }
    
    @IBAction private func encryptionButton(_ sender: UIButton) { // шифровка сообщения
        sizeOfBlock = 0
        arrayOfCharacters = []
        arrayOfSymbols = []

        if check() {
            let resultText = encryptionOfTheMessage() // шифруем заданное сообщение
            print(resultText)
            encryptedMessageLabel.text = resultText
        }
    }
   
    @IBAction func decryptionButton(_ sender: UIButton) { // расшифровка сообщения
        arrayOfCharacters = [] // обнуляем массив для последующего хранения данных
        
        if (encryptedMessageLabel.text?.isEmpty)! == false { // если поле с зашифрованным сообщением не пусто
            for character in String(encryptedMessageLabel.text!).characters { // добавляем символы шифра в массив
                arrayOfCharacters.append(String(character))
            }
            print("Input text has been entered succesfully")
            if  String(encryptedMessageLabel.text!).characters.count % Int(sizeOfBlockField.text!)!  ==  0 { // если шифр можно разбить на блоки заданного размера без остатка
                print("Size is okay")

                let resultText = encryptionOfTheMessage() // расшифровываем сообщение
                print("Result of decryption: ", resultText)
                decryptedMessageLabel.text = resultText

            } else { // если шифр невозможно разбить на блоки заданного размера без остатка
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

