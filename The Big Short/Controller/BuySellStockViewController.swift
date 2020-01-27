//
//  BuySellStockViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class BuySellStockViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var stockView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
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
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var parentVC: UIViewController!
    
    var selectedStock: String!
    var index = -1
    
    var stockArray = [String]()
    var stockList = ""
    var stockIndex = -1
    
    var operation = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findIndex()
        setStockArray()
        stockIndex = findIndexInStockArray()
        
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
            
            if data2[i].symbol == selectedStock {
                index = i
            }
        }
    }
    
    func setStockArray() {
        
        let stocks = data1[0].stockList
        
        stockArray = stocks?.components(separatedBy: ":") ?? []
    }
    
    func findIndexInStockArray() -> Int {
        
        var indexStock = -1
        
        if stockArray.count > 0 {
            
            for i in 0...stockArray.count-1{
                
                if selectedStock == stockArray[i] {
                    indexStock = i
                }
            }
        }
        
        return indexStock
    }
    
    // MARK: - Modal creation
    
    func createModal(){
        
        modalView.layer.cornerRadius = 10.0
        
        if let image = data2[index].imageName {
            imageLogo.image = UIImage(named: "\(image).png")
        }
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.08235294118, green: 0.1568627451, blue: 0.2941176471, alpha: 1)], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.9647058824, blue: 0.9882352941, alpha: 1)], for: .normal)
        
        stockView.layer.cornerRadius = 10.0
        symbolLabel.text = data2[index].symbol
        
        guard let change = data2[index].changePercentage else {
            return
        }
        
        if change.contains("-") {
            changePercentLabel.textColor = #colorLiteral(red: 0.7725490196, green: 0.06274509804, blue: 0.1254901961, alpha: 1)
        } else {
            if change == "0%" {
                changePercentLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
            } else {
                changePercentLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
            }
        }
        
        changePercentLabel.text = change
        
        priceLabel.text = numberFormatter(value: data2[index].price)
        
        textField.attributedPlaceholder = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 137.0, green: 180.0, blue: 255.0, alpha: 1.0)])
    }
    
    func numberFormatter(value: Float) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        
        let valueString = currencyFormatter.string(from: NSNumber(value: value))
        
        return valueString!
    }
    
    func investedValue() -> Float{
        
        var value: Float = 0.0
        
        if textField.text != ""{
            
            let input: Float = Float(textField.text!)!
            value = data2[index].price * input
        
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
            balanceLabel.text = "Saldo restante"
            balanceNumberLabel.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        
        } else{
            
            let data2 = self.data2[index]
            
            if textField.text! != ""{
                let input: Float = Float(textField.text!)!
                
                let change = investedValue() - ((data2.mediumPrice * input) + (data2.timesBought * 10))
                
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
                balanceNumberLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
            }
        }
        
        return value
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
        if operation == "Buy"{
            investedNumberLabel.text = numberFormatter(value: investedValue())
            costsNumberLabel.text = numberFormatter(value: 10.0)
            totalNumberLabel.text = numberFormatter(value: totalValue(mathOperation: "Buy"))
            balanceNumberLabel.text = numberFormatter(value: balanceValue(mathOperation: "Buy"))
            
        } else{
            investedNumberLabel.text = numberFormatter(value: investedValue())
            costsNumberLabel.text = numberFormatter(value: 10.0)
            totalNumberLabel.text = numberFormatter(value: totalValue(mathOperation: "Sell"))
            balanceNumberLabel.text = numberFormatter(value: balanceValue(mathOperation: "Sell"))
        }
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0{
            operation = "Buy"
            
            investedValueLabel.text = "Valor investido"
            investedNumberLabel.text = numberFormatter(value: investedValue())
            
            costsLabel.text = "Custos"
            costsNumberLabel.text = numberFormatter(value: 10.0)
            
            totalLabel.text = "Total da operação"
            totalNumberLabel.text = numberFormatter(value: totalValue(mathOperation: "Buy"))
            
            balanceLabel.text = "Saldo restante"
            balanceNumberLabel.text = numberFormatter(value: balanceValue(mathOperation: "Buy"))
            buySellBtn.titleLabel?.text = "Comprar"
            
        } else {
            operation = "Sell"
            
            investedValueLabel.text = "Valor resgatado"
            investedNumberLabel.text = numberFormatter(value: investedValue())
            
            costsLabel.text = "Custos"
            costsNumberLabel.text = numberFormatter(value: 10.0)
            
            totalLabel.text = "Total da operação"
            totalNumberLabel.text = numberFormatter(value: totalValue(mathOperation: "Sell"))
            
            balanceLabel.text = " "
            
            buySellBtn.titleLabel?.text = " Vender"
        }
    }
    
    @IBAction func buySellBtnPressed(_ sender: Any) {
        
        guard let symbol = data2[index].symbol else {
            return
        }
        
        if operation == "Buy" && textField.text != ""{
            
            let amount: Float = Float(textField.text!)!
            
            let invested = investedValue()
            let balance = balanceValue(mathOperation: "Buy")
            
            if balance >= 0{
                
                let data1 = self.data1[0]
                
                let data2 = self.data2[index]
                let price = data2.price
                
                if data2.mediumPrice == 0.0 {
                    data2.mediumPrice = price
                
                } else {
                    data2.mediumPrice = (data2.mediumPrice + price)/2.0
                }
                
                data2.amount = data2.amount + amount
                data2.invested = data2.invested + invested
                data2.timesBought += 1
                
                data1.availableBalance = balance
                
                if stockIndex == -1 {
                    stockArray.append(symbol)
                    
                    var removeIndex = -1
                    
                    for i in 0...stockArray.count-1 {
                        if stockArray[i] == "" {
                            removeIndex = i
                        }
                    }
                    
                    if removeIndex != -1 {
                        stockArray.remove(at: removeIndex)
                    }
                    
                    data1.stockList = stockArray.joined(separator: ":")
                }
                
                do{
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

                
            } else{
                
                createAlert(title: "Saldo insuficiente", message: "Não há saldo disponível para essa compra.", actionTitle: "OK")
            }
            
            
        } else if operation == "Sell" && textField.text != ""{
                
            let amount: Float = Float(textField.text!)!
            
            if stockIndex != -1 {
                
                stockArray.remove(at: stockIndex)
                data1[0].stockList = stockArray.joined(separator: ":")
            
                let invested = investedValue()
                let balance = balanceValue(mathOperation: "Sell")
                
                let data1 = self.data1[0]
                let data2 = self.data2[index]
                
                if data2.invested - invested == 0{
                    data2.invested = 0
                    data2.mediumPrice = 0
                
                } else if data2.invested - invested > 0{
                    data2.invested = data2.invested - invested
                
                } else{
                    createAlert(title: "Saldo insuficiente", message: "Não há saldo sufifiente para essa compra.", actionTitle: "OK")
                    return
                }
                
                data2.timesBought -= 1
                data2.amount = data2.amount - amount
                data2.invested = data2.invested - invested
                data1.availableBalance = data1.availableBalance + balance
                
                do{
                    try self.context.save()
                    
                } catch{
                    print("Error when saving context")
                }
                
                createAlert(title: "Sucesso", message: "Simulação de operação realizada.", actionTitle: "OK")
                
                dismiss(animated: true, completion: nil)
                
            } else {
                createAlert(title: "Ação não encontrada", message: "Você não possui essa ação, portanto não há como vender.", actionTitle: "OK")
            }
            
        } else{
            
            createAlert(title: "Falta de dados", message: "Preencha a quantidade de ações para prosseguir.", actionTitle: "OK")
        }
        
    }
    
    func positionPrice() -> Float{
        
        let position: Float = data2[index].price * data2[index].amount
        
        return position
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
