//
//  BuySellCurrencyViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 23/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class BuySellCurrencyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var investedValueLabel: UILabel!
    @IBOutlet weak var investedNumberLabel: UILabel!
    
    @IBOutlet weak var costsLabel: UILabel!
    @IBOutlet weak var costsNumberLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalNumberLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceNumberLabel: UILabel!
    
    @IBOutlet weak var buySellBtn: UIButton!
    
    var data1: [Wallet] = []
    var data4: [Currency] = []
    var context: NSManagedObjectContext?
    
    var parentVC: UIViewController!
    
    var selectedStock: String!
    var index = -1
    
    var operation = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        operation = "Buy"
        createModal()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        parentVC.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Modal creation
    
    func createModal(){
        
        modalView.layer.cornerRadius = 10.0
        
        guard let name = data4[index].name else {
            return
        }
        
        guard let symbol = data4[index].symbol else {
            return
        }
        
        let proportion = Float(data4[index].proportion)
        
        let price = MathOperations.currencyFormatter(value: Float(1.0/proportion))
        
        titleLabel.text = name
        imageLogo.image = UIImage(named: "\(symbol).png")
        
        currencyView.layer.cornerRadius = 10.0
        symbolLabel.text = symbol
        
        priceLabel.text = price
        
        textField.attributedPlaceholder = NSAttributedString(string: "Valor em \(symbol)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 137.0, green: 180.0, blue: 255.0, alpha: 1.0)])
    }
    
    func investedValue() -> Float{
        
        var value: Float = 0.0
        
        if textField.text != ""{
            
            let input: Float = Float(textField.text!)!
            value = input / data4[index].proportion
        
        }
        
        return value
    }
    
    func totalValue(mathOperation: String) -> Float{
        
        var value: Float = 0.0
        
        if mathOperation == "Buy"{
            value = investedValue() + 10.0
            
        } else{
            value = investedValue() - 10.0
            
        }
        
        return value
    }
    
    func balanceValue(mathOperation: String) -> Float{
        
        var value: Float = 0.0
        
        if mathOperation == "Buy"{
            value = data1[0].availableBalance - totalValue(mathOperation: "Buy")
        
        } else{
            
            let data4 = self.data4[index]
            
            if textField.text! != ""{
                let input: Float = Float(textField.text!)!
                
                // let change = investedValue() - ((data2.mediumPrice * input) + (data2.timesBought * 10))
                
//                if change < 0{
//                    balanceLabel.text = "Perda"
//                    balanceNumberLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
//                    balanceNumberLabel.text = "\(String(format: "%.2f", change))%"
//
//                } else if change > 0{
//                    balanceLabel.text = "Ganho"
//                    balanceNumberLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
//                    balanceNumberLabel.text = "+\(String(format: "%.2f", change))%"
//
//                } else{
//                    balanceLabel.text = "Histórico"
//                    balanceNumberLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
//                    balanceNumberLabel.text = "\(String(format: "%.2f", change))%"
//                }
                
                // value = change
            
            } else{
                value = 0
            }
        }
        
        return value
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
        if operation == "Buy"{
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValue())
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Buy"))
            balanceNumberLabel.text = MathOperations.currencyFormatter(value: balanceValue(mathOperation: "Buy"))
            
        } else{
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValue())
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Sell"))
            balanceNumberLabel.text = MathOperations.currencyFormatter(value: balanceValue(mathOperation: "Sell"))
        }
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0{
            operation = "Buy"
            
            investedValueLabel.text = "Valor investido"
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValue())
            
            costsLabel.text = "Custos"
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)
            
            totalLabel.text = "Total da operação"
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Buy"))
            
            balanceLabel.text = "Saldo restante"
            balanceNumberLabel.text = MathOperations.currencyFormatter(value: balanceValue(mathOperation: "Buy"))
            buySellBtn.titleLabel?.text = "Comprar"
            
        } else {
            operation = "Sell"
            
            investedValueLabel.text = "Valor resgatado"
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValue())
            
            costsLabel.text = "Custos"
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)
            
            totalLabel.text = "Total da operação"
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Sell"))
            
            balanceLabel.text = " "
            
            buySellBtn.titleLabel?.text = " Vender"
        }
    }
    
    @IBAction func buySellBtnPressed(_ sender: Any) {
        
        if operation == "Buy" && textField.text != ""{
            
            let amount: Float = Float(textField.text!)!
            
            let invested = investedValue()
            let total = totalValue(mathOperation: "Buy")
            let balance = balanceValue(mathOperation: "Buy")
            
            if balance >= 0{
                
                let data4 = self.data4[index]
                let price = 1.0 / data4.proportion
                
                if data4.mediumPrice == 0.0{
                    data4.mediumPrice = price
                
                } else{
                    data4.mediumPrice = (data4.mediumPrice + price)/2.0
                }
                
                data4.invested = data4.invested + invested
                data4.timesBought += 1
                
                data1[0].availableBalance = balance
                
                // data1.stocksValue
                
                do{
                    try self.context!.save()
                    
                } catch{
                    print("Error when saving context")
                }
                
                let alert = UIAlertController(title: "Sucesso", message: "Simulação de operação realizada.", preferredStyle: UIAlertController.Style.alert)
                
                let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alert.addAction(fillLabelAction)
                self.present(alert, animated: true, completion: nil)

                
            } else{
                
                createAlert(title: "Saldo insuficiente", message: "Não há saldo disponível para essa compra.", actionTitle: "OK")
            }
            
            
        } else if operation == "Sell" && textField.text != ""{
                
            let invested = investedValue()
            let total = totalValue(mathOperation: "Sell")
            let balance = balanceValue(mathOperation: "Sell")
            
            let data1 = self.data1[0]
            let data4 = self.data4[index]
            
            if data4.invested - invested == 0{
                data4.invested = 0
                data4.mediumPrice = 0
                data1.stock1 = nil
                
            } else if data4.invested - invested > 0{
                data4.invested = data4.invested - invested
            
            } else{
                createAlert(title: "Saldo insuficiente", message: "Não há saldo sufifiente para essa compra.", actionTitle: "OK")
                return
            }
            
            data4.invested = data4.invested - invested
            
            data1.availableBalance = balance
            
            do{
                try self.context!.save()
                
            } catch{
                print("Error when saving context")
            }
            
            createAlert(title: "Sucesso", message: "Simulação de peração realizada.", actionTitle: "OK")
            
            dismiss(animated: true, completion: nil)
            
        } else{
            
            createAlert(title: "Falta de dados", message: "Preencha a quantidade de ações para prosseguir.", actionTitle: "OK")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createAlert(title: String, message: String, actionTitle: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let fillLabelAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(fillLabelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
