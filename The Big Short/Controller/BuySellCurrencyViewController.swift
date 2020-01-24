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
        
        for i in 0...31{
            
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
                
                for n in 0...31 {
                    if data4[n].symbol == currencyArray[i] {
                        indexCurrency = i
                    }
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
    
    func investedValueBRL() -> Float{
        
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
        
        } else{
            
            let data4 = self.data4[index]
            
            if textField.text! != ""{
                
                let change = investedValueBRL() - data4.investedBRL
                
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
            let total = totalValue(mathOperation: "Buy")
            let balance = balanceValue(mathOperation: "Buy")
            
            if balance >= 0 {
                
                let data4 = self.data4[index]
                let price = 1.0 / data4.proportion
                
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
                
                let total = totalValue(mathOperation: "Sell")
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
                data1.availableBalance = balance
                
                do {
                    try self.context.save()
                
                } catch{
                    print("Error when saving context")
                }
                
                createAlert(title: "Sucesso", message: "Simulação de peração realizada.", actionTitle: "OK")
                
                dismiss(animated: true, completion: nil)
            
            } else {
                createAlert(title: "Moeda não encontrada", message: "Você não possui essa moeda, portanto não há como vender.", actionTitle: "OK")
            }
            
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