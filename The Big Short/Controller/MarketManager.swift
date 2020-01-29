//
//  MarketManager.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

public class MarketManager: NSObject {
    
    static func verifyMarket(purpose: String) -> String{
        
        // Current date and last update
        let dateCurrent = Date()
        
        // Hour
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH.mm"
        hourFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let hourString = hourFormatter.string(from: dateCurrent)
        
        // Weekend
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        dayFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let dayString = dayFormatter.string(from: dateCurrent)
        
        if dayString == "Saturday" || dayString == "Sunday"{
            
            if purpose == "keepTracking"{
                
                return "Market closed"
                
            } else{
                
                return "Market closed alert 2"
            }
            
        } else{
            
            if hourString < "10.00" || hourString > "17.00"{
                
                if purpose == "keepTracking"{
                    return "Market closed"
                    
                } else{
                    return "Market closed alert"
                }
                
            } else{
                
                if purpose == "keepTracking"{
                    return "Market open"
                    
                } else{
                    return "Operations avilable"
                }
            }
        }
    }
    
}
