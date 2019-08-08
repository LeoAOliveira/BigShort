//
//  BuySellStockViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class BuySellStockViewController: UIViewController {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
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
    var context: NSManagedObjectContext?
    
    var parentVC: UIViewController!
    
    var selectedStock: String!
    var index = -1
    
    var operation = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.isHidden = false
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        operation = "Buy"
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
    
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            data2 = try context!.fetch(Stock.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
        
        // Get selected stock data
        do{
            
            for i in 0...65{
                
                if data2[i].symbol == selectedStock{
                    index = i
                }
            }
            
        } catch{
            print(error.localizedDescription)
        }
        
        if data1[0].stock1 == selectedStock || data1[0].stock2 == selectedStock || data1[0].stock3 == selectedStock || data1[0].stock4 == selectedStock || data1[0].stock5 == selectedStock{
            
            self.loadingIndicator.stopAnimating()
            createModal()
            
        } else{
            StockData().alphaVantageFetch(stocksArray: [selectedStock], index: [index]){ isValid in
                
                if isValid == true{
                    self.loadingIndicator.stopAnimating()
                    self.createModal()
                }
            }
        }
    }
    
    
    func createModal(){
        
        modalView.layer.cornerRadius = 10.0
        titleLabel.text = data2[index].name
        imageLogo.image = UIImage(named: "\(data2[index].imageName!).pdf")
        
        stockView.layer.cornerRadius = 10.0
        symbolLabel.text = data2[index].symbol
        
        let change = data2[index].change
        
        if change < 0{
            changePercentLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
            changePercentLabel.text = "\(String(format: "%.2f", change))%"
            
        } else if change > 0{
            changePercentLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
            changePercentLabel.text = "+\(String(format: "%.2f", change))%"
            
        } else{
            changePercentLabel.text = "\(String(format: "%.2f", change))%"
            changePercentLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
        }
        
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
        
        } else{
            value = data1[0].availableBalance + totalValue(mathOperation: "Sell")
            
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
            investedNumberLabel.text = numberFormatter(value: investedValue())
            costsNumberLabel.text = numberFormatter(value: 10.0)
            totalNumberLabel.text = numberFormatter(value: totalValue(mathOperation: "Buy"))
            balanceNumberLabel.text = numberFormatter(value: balanceValue(mathOperation: "Buy"))
            buySellBtn.titleLabel?.text = "Comprar"
            
        } else {
            operation = "Sell"
            investedNumberLabel.text = numberFormatter(value: investedValue())
            costsNumberLabel.text = numberFormatter(value: 10.0)
            totalNumberLabel.text = numberFormatter(value: totalValue(mathOperation: "Buy"))
            balanceNumberLabel.text = numberFormatter(value: balanceValue(mathOperation: "Buy"))
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
                
                let data1 = self.data1[0]
                
                if data1.stock1 == selectedStock{
                    data1.stock1 = selectedStock
                    
                } else if data1.stock2 == selectedStock{
                    data1.stock2 = selectedStock
                    
                } else if data1.stock3 == selectedStock{
                    data1.stock3 = selectedStock
                    
                } else if data1.stock4 == selectedStock{
                    data1.stock4 = selectedStock
                    
                } else if data1.stock5 == selectedStock{
                    data1.stock5 = selectedStock
                }
                
                if data1.stock1 == nil{
                    data1.stock1 = selectedStock
                    
                } else if data1.stock2 == nil{
                    data1.stock2 = selectedStock
                    
                } else if data1.stock3 == nil{
                    data1.stock3 = selectedStock
                    
                } else if data1.stock4 == nil{
                    data1.stock4 = selectedStock
                    
                } else if data1.stock5 == nil{
                    data1.stock5 = selectedStock
                    
                } else{
                    let alert = UIAlertController(title: "Limite de ativos", message: "Você atingiu o limite de 5 ativos diferentes.", preferredStyle: UIAlertController.Style.alert)
                    
                    let fillLabelAction = UIAlertAction(title: "Entendi", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(fillLabelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                let data2 = self.data2[index]
                
                if data2.mediumPrice == 0.0{
                    data2.mediumPrice = data2.price
                
                } else{
                    data2.mediumPrice = (data2.mediumPrice + data2.price)/2.0
                }
                
                data2.amount = data2.amount + amount
                data2.invested = invested
                
                data1.availableBalance = balance
                // data1.stocksValue
                
                do{
                    try self.context!.save()
                    
                } catch{
                    print("Error when saving context")
                }
                
                let alert = UIAlertController(title: "Sucesso", message: "Simulação de operação realizada.", preferredStyle: UIAlertController.Style.alert)
                
                let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(fillLabelAction)
                self.present(alert, animated: true, completion: nil)
                
                dismiss(animated: true, completion: nil)

                
            } else{
                
                let alert = UIAlertController(title: "Saldo insuficiente", message: "Não há saldo disponível para essa compra.", preferredStyle: UIAlertController.Style.alert)
                
                let fillLabelAction = UIAlertAction(title: "Entendi", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(fillLabelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        } else if operation == "Sell" && textField.text != ""{
                
            let amount: Float = Float(textField.text!)!
            
            let invested = investedValue()
            let total = totalValue(mathOperation: "Sell")
            let balance = balanceValue(mathOperation: "Sell")
            
            let data1 = self.data1[0]
            
            if data1.stock1 == selectedStock{
                
                if data2[index].amount - amount == 0{
                    data2[index].amount = 0
                    data1.stock1 = nil
                    
                } else if data2[index].amount - amount > 0{
                    data2[index].amount = data2[index].amount - amount
                
                } else{
                    sendAlert()
                }
                
            } else if data1.stock2 == selectedStock{
                
                if data2[index].amount - amount == 0{
                    data2[index].amount = 0
                    data1.stock2 = nil
                    
                } else if data2[index].amount - amount > 0{
                    data2[index].amount = data2[index].amount - amount
                }else{
                    sendAlert()
                }
                
            } else if data1.stock3 == selectedStock{
                
                if data2[index].amount - amount == 0{
                    data2[index].amount = 0
                    data1.stock3 = nil
                    
                } else if data2[index].amount - amount > 0{
                    data2[index].amount = data2[index].amount - amount
                }else{
                    sendAlert()
                }
                
            } else if data1.stock4 == selectedStock{
                
                if data2[index].amount - amount == 0{
                    data2[index].amount = 0
                    data1.stock4 = nil
                    
                } else if data2[index].amount - amount > 0{
                    data2[index].amount = data2[index].amount - amount
                }else{
                    sendAlert()
                }
                
            } else if data1.stock5 == selectedStock{
                
                if data2[index].amount - amount == 0{
                    data2[index].amount = 0
                    data1.stock5 = nil
                    
                } else if data2[index].amount - amount > 0{
                    data2[index].amount = data2[index].amount - amount
                }else{
                    sendAlert()
                }
            
            } else{
                let alert = UIAlertController(title: "Ativo não encontrado", message: "Você não possui esse ativo, portantro não há como vender.", preferredStyle: UIAlertController.Style.alert)
                
                let fillLabelAction = UIAlertAction(title: "Entendi", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(fillLabelAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let data2 = self.data2[index]
            
            if data2.mediumPrice == 0.0{
                data2.mediumPrice = data2.price
                
            } else{
                data2.mediumPrice = (data2.mediumPrice + data2.price)/2.0
            }
            
            data2.amount = data2.amount + amount
            data2.invested = invested
            
            data1.availableBalance = balance
            // data1.stocksValue
            
            do{
                try self.context!.save()
                
            } catch{
                print("Error when saving context")
            }
            
            let alert = UIAlertController(title: "Sucesso", message: "Simulação de peração realizada.", preferredStyle: UIAlertController.Style.alert)
            
            let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(fillLabelAction)
            self.present(alert, animated: true, completion: nil)
            
            dismiss(animated: true, completion: nil)
            
        } else{
            let alert = UIAlertController(title: "Falta de dados", message: "Preencha a quantidade de ações para prosseguir.", preferredStyle: UIAlertController.Style.alert)
            
            let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(fillLabelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        parentVC.tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func sendAlert(){
        
    }
    
}
