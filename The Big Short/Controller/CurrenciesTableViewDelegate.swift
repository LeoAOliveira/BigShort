//
//  CurrenciesDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 23/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class CurrenciesTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var currenciesViewController: CurrenciesViewController?
    
    init(viewController: CurrenciesViewController) {
        currenciesViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
            
        } else {
            
            guard let currenciesVC = currenciesViewController else {
                return 165
            }
            
            if indexPath.row == currenciesVC.currencyList.count+1 {
                return 150
            } else if indexPath.row == currenciesVC.currencyList.count+2 {
                return 80
            } else {
                return 165
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currenciesVC = currenciesViewController else {
            return
        }
        
        if indexPath.row != 0 && indexPath.row != currenciesVC.currencyList.count+1 && indexPath.row != currenciesVC.currencyList.count+2 {
            currenciesVC.selectedIndex = currenciesVC.currencyIndex[indexPath.row-1]
            currenciesVC.selectedCurrency = currenciesVC.data4[currenciesVC.currencyIndex[indexPath.row-1]].symbol ?? ""
            
            currenciesVC.performSegue(withIdentifier: "detailCurrencySegue", sender: self)
        }
    }
    
}
