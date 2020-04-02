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
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 200
            } else {
                return 250
            }
            
        } else {
            
            guard let currenciesVC = currenciesViewController else {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 165
                } else {
                    return 250
                }
            }
            
            if indexPath.row == currenciesVC.currencyList.count+1 {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 150
                } else {
                    return 170
                }
            } else if indexPath.row == currenciesVC.currencyList.count+2 {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 80
                } else {
                    return 100
                }
            } else {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 165
                } else {
                    return 185
                }
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
