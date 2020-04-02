//
//  MainTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 20/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class MainTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var mainViewController: MainViewController?
    
    init(viewController: MainViewController) {
        mainViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 200
            } else {
                return 250
            }
            
        } else {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 155
            } else {
                return 175
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            mainViewController?.performSegue(withIdentifier: "stockSegue", sender: mainViewController)
            
        } else if indexPath.row == 2 {
            mainViewController?.performSegue(withIdentifier: "currencySegue", sender: mainViewController)
            
        }
    }
}
