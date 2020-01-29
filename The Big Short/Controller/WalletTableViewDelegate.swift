//
//  WalletTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class WalletTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var walletViewController: WalletViewController?
    
    init(viewController: WalletViewController) {
        walletViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 170
            
        } else if indexPath.row == 1 {
            return 145
        
        } else {
            
            guard let walletVC = walletViewController else {
                return 220
            }
            
            if walletVC.segmented.selectedSegmentIndex == 0 {
                return 220
            } else {
                return 35
            }
        }
    }
    
}
