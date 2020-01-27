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
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    
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
    @IBOutlet weak var buySellBtn: CustomButton!
    
    var data1: [Wallet] = []
    var data4: [Currency] = []
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var parentVC: UIViewController!
    
    var selectedCurrency: String!
    var index = -1
    
    var currencyArray = [String]()
    var currencyList = ""
    var currencyIndex = -1
    
    var operation = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findIndex()
        setCurrencyArray()
        currencyIndex = findIndexInCurrencyArray()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        operation = "Buy"
        createModal()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        parentVC.tabBarController?.tabBar.isHidden = false
    }
    
    func findIndex() {
        
        for i in 0...47{
            
            if data4[i].symbol == selectedCurrency {
                index = i
            }
        }
    }
    
    func setCurrencyArray() {
        
        let currencies = data1[0].currencyList
        
        currencyArray = currencies?.components(separatedBy: ":") ?? []
    }
    
    func findIndexInCurrencyArray() -> Int {
        
        var indexCurrency = -1
        
        if currencyArray.count > 0 {
            
            for i in 0...currencyArray.count-1{
                
                if currencyArray[i] == selectedCurrency {
                    indexCurrency = i
                }
            }
        }
        
        return indexCurrency
    }
    
    func setCurrencyString() {
        
        currencyList = currencyArray.joined(separator: ":")
    }
    
    
    // MARK: - Modal creation
    
    func createModal(){
        
        modalView.layer.cornerRadius = 10.0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.08235294118, green: 0.1568627451, blue: 0.2941176471, alpha: 1)], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.9647058824, blue: 0.9882352941, alpha: 1)], for: .normal)
        
        guard let name = data4[index].name else {
            return
        }
        
        guard let symbol = data4[index].symbol else {
            return
        }
        
        let rawPrice = Float(data4[index].price)
        
        let price = MathOperations.currencyFormatter(value: Float(rawPrice))
        
        titleLabel.text = name
        imageLogo.image = UIImage(named: "\(symbol).png")
        
        currencyView.layer.cornerRadius = 10.0
        symbolLabel.text = symbol
        
        priceLabel.text = price
        
        textField.attributedPlaceholder = NSAttributedString(string: "Valor em \(symbol)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 137.0, green: 180.0, blue: 255.0, alpha: 1.0)])
    }
    
    func investedValueBRL() -> Float{
        
        var value: Float = 0.0
        
        if textField.text != ""{
            
            let input: Float = Float(textField.text!)!
            value = input * data4[index].price
        
        }
        
        return value
    }
    
    func totalValue(mathOperation: String) -> Float{
        
        var value: Float = 0.0
        
        if mathOperation == "Buy"{
            value = investedValueBRL() + 10.0
            
        } else{
            value = investedValueBRL() - 10.0
            
        }
        
        return value
    }
    
    func balanceValue(mathOperation: String) -> Float{
        
        var value: Float = 0.0
        
        if mathOperation == "Buy"{
            value = data1[0].availableBalance - totalValue(mathOperation: "Buy")
            balanceLabel.text = "Saldo restante"
            balanceNumberLabel.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            
        } else{
            
            let data4 = self.data4[index]
            
            if textField.text! != ""{
                
                let change = investedValueBRL() - data4.investedBRL
                
                if change < 0 {
                    balanceLabel.text = "Perda"
                    balanceNumberLabel.textColor = #colorLiteral(red: 0.7725490196, green: 0.06274509804, blue: 0.1254901961, alpha: 1)
                    
                } else if change > 0 {
                    balanceLabel.text = "Ganho"
                    balanceNumberLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
                    
                } else{
                    balanceLabel.text = "Ganho"
                    balanceNumberLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
                }
                
                 value = change
            
            } else{
                value = 0
            }
        }
        
        return value
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        if operation == "Buy"{
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValueBRL())
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Buy"))
            balanceNumberLabel.text = MathOperations.currencyFormatter(value: balanceValue(mathOperation: "Buy"))

        } else{
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValueBRL())
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Sell"))
            balanceNumberLabel.text = MathOperations.currencyFormatter(value: balanceValue(mathOperation: "Sell"))
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0{
            operation = "Buy"

            investedValueLabel.text = "Valor investido"
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValueBRL())

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
            investedNumberLabel.text = MathOperations.currencyFormatter(value: investedValueBRL())

            costsLabel.text = "Custos"
            costsNumberLabel.text = MathOperations.currencyFormatter(value: 10.0)

            totalLabel.text = "Total da operação"
            totalNumberLabel.text = MathOperations.currencyFormatter(value: totalValue(mathOperation: "Sell"))

            balanceLabel.text = " "

            buySellBtn.titleLabel?.text = " Vender"
        }
    }
    
    @IBAction func buySellBtnPressed(_ sender: Any) {
        
        guard let symbol = data4[index].symbol else {
            return
        }
        
        let investedBRL = investedValueBRL()
        
        if operation == "Buy" && textField.text != ""{
            
            let invested = Float(textField.text!)!
            let balance = balanceValue(mathOperation: "Buy")
            
            if balance >= 0 {
                
                let data4 = self.data4[index]
                let price = self.data4[index].price
                
                if data4.mediumPrice == 0.0 {
                    data4.mediumPrice = price
                
                } else {
                    data4.mediumPrice = (data4.mediumPrice + price)/2.0
                }
                
                data4.invested = invested
                data4.investedBRL = data4.investedBRL + investedBRL
                data4.timesBought += 1
                
                data1[0].availableBalance = balance
                
                if currencyIndex == -1 {
                    currencyArray.append(symbol)
                    
                    var removeIndex = -1
                    
                    for i in 0...currencyArray.count-1 {
                        if currencyArray[i] == "" {
                            removeIndex = i
                        }
                    }
                    
                    if removeIndex != -1 {
                        currencyArray.remove(at: removeIndex)
                    }
                    
                    data1[0].currencyList = currencyArray.joined(separator: ":")
                }
                
                do {
                    try self.context.save()
                
                } catch{
                    print("Error when saving context")
                }
                
                let alert = UIAlertController(title: "Sucesso", message: "Simulação de operação realizada.", preferredStyle: UIAlertController.Style.alert)
                
                let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alert.addAction(fillLabelAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                createAlert(title: "Saldo insuficiente", message: "Não há saldo disponível para essa compra.", actionTitle: "OK")
            }
        
        } else if operation == "Sell" && textField.text != ""{
            
            let invested = Float(textField.text!)!
            
            if currencyIndex != -1 {
                
                currencyArray.remove(at: currencyIndex)
                data1[0].currencyList = currencyArray.joined(separator: ":")
                
                let balance = balanceValue(mathOperation: "Sell")
                
                let data1 = self.data1[0]
                let data4 = self.data4[index]
                
                if data4.invested - invested == 0{
                    data4.invested = 0
                    data4.mediumPrice = 0
                
                } else if data4.invested - invested > 0{
                    data4.invested = data4.invested - invested
                
                } else{
                    createAlert(title: "Saldo insuficiente", message: "Não há saldo sufifiente para essa compra.", actionTitle: "OK")
                    return
                }
                data4.timesBought -= 1
                data4.invested = data4.invested - invested
                data4.investedBRL = data4.investedBRL - investedBRL
                data4.invested = data4.invested - invested
                data1.availableBalance = data1.availableBalance + balance
                
                do {
                    try self.context.save()
                
                } catch{
                    print("Error when saving context")
                }
                
                createAlert(title: "Sucesso", message: "Simulação de operação realizada.", actionTitle: "OK")
                
                dismiss(animated: true, completion: nil)
            
            } else {
                createAlert(title: "Moeda não encontrada", message: "Você não possui essa moeda, portanto não há como vender.", actionTitle: "OK")
            }
            
        } else{
            createAlert(title: "Falta de dados", message: "Preencha o valor na moeda escolhida para prosseguir.", actionTitle: "OK")
            
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
