//
//  SymbolTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class SymbolTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var symbolViewController: SymbolViewController?
    
    init(viewController: SymbolViewController) {
        symbolViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 140
            } else {
                return 210
            }
        
        } else if indexPath.row == 1 {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 110
            } else {
                return 130
            }
        
        } else if indexPath.row == 2 {
           if UIDevice.current.userInterfaceIdiom == .phone {
               return 160
           } else {
               return 180
           }
            
        } else if indexPath.row == 3 {
           if UIDevice.current.userInterfaceIdiom == .phone {
               return 160
           } else {
               return 180
           }
            
        } else{
            return 190
        }
    }
}
