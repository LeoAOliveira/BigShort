

//
//  TermsViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 04/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class TermsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.text = "Escreva aqui"
        textField.textColor = #colorLiteral(red: 0.5569834113, green: 0.5566322207, blue: 0.5783061981, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func didBegingEditing(_ sender: Any) {
        
        textField.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
        textField.text = ""
        
    }
    
    
    @IBAction func didEndEditing(_ sender: Any) {
        
        if textField.text == ""{
            
            textField.textColor = #colorLiteral(red: 0.5569834113, green: 0.5566322207, blue: 0.5783061981, alpha: 1)
            textField.text = "Escreva aqui"
            
        } else{
            
            textField.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
        }
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        
        if textField.text?.lowercased() == "eu concordo" || textField.text?.lowercased() == "eu concordo "{
            
            performSegue(withIdentifier: "termsSegue", sender: self)
            
        
        } else{
            
            let alert = UIAlertController(title: "Frase incorreta", message: "Leia os Termos de Uso até o final e escreva \"eu concordo\" para prosseguir.", preferredStyle: UIAlertController.Style.alert)
            
            let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(fillLabelAction)
            self.present(alert, animated: true, completion: nil)
            
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
