//
//  StartViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 07/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    public var data1: [Wallet] = []
    var context: NSManagedObjectContext?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.text = "Escreva aqui"
        textField.textColor = #colorLiteral(red: 0.5569834113, green: 0.5566322207, blue: 0.5783061981, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        fetchData()
    }
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        textField.text = Int(sender.value).description
        
    }
    
    
    @IBAction func startBtnPressed(_ sender: Any) {
        
        if textField.text != "Escreva aqui"{
            
            if Int(textField.text!)! >= 1000 && Int(textField.text!)! <= 100000{
                
                data1[0].availableBalance = Float(textField.text!)!
                
                do{
                    try self.context!.save()
                    
                } catch{
                    print("Error when saving context")
                }
                
                let defaults = UserDefaults()
                defaults.set("terms", forKey: "terms")
                
                performSegue(withIdentifier: "startSegue", sender: self)
                
            } else{
                
                let alert = UIAlertController(title: "Número fora de alcance", message: "Mínimo de 1.000 e máximo de 100.000.", preferredStyle: UIAlertController.Style.alert)
                
                let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(fillLabelAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else{
            let alert = UIAlertController(title: "Entrada inválida", message: "Insira um número para prosseguir.", preferredStyle: UIAlertController.Style.alert)
            
            let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(fillLabelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func textDidEndEditing(_ sender: Any) {
        if textField.text == ""{
            
            textField.textColor = #colorLiteral(red: 0.5569834113, green: 0.5566322207, blue: 0.5783061981, alpha: 1)
            textField.text = "Escreva aqui"
            
        } else{
            
            textField.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
        }
    }
    
    @IBAction func textDidBeginEditing(_ sender: Any) {
        
        textField.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
        
        if textField.text == "Escreva aqui"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
