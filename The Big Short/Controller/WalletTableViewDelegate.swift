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
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 170
            } else {
                return 210
            }
            
        } else if indexPath.row == 1 {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 145
            } else {
                return 165
            }
        
        } else {
            
            guard let walletVC = walletViewController else {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 220
                } else {
                    return 240
                }
            }
            
            if walletVC.segmented.selectedSegmentIndex == 0 {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 220
                } else {
                    return 240
                }
            } else {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 35
                } else {
                    return 55
                }
            }
        }
    }
    
}
