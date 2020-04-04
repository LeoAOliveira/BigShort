//
//  Company.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 03/04/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CloudKit

class Company {
  
    static let recordType = "Company"
    private let id: CKRecord.ID
    
    let symbol: String
    let name: String
    let sector: String
    let type: String
    let price: Double
    let changePercentage: String
    let image: CKAsset?
    
    let database: CKDatabase
  
    init?(record: CKRecord, database: CKDatabase) {
        
        guard let symbol = record["symbol"] as? String, 
            let name = record["name"] as? String,
            let sector = record["sector"] as? String,
            let type = record["type"] as? String,
            let price = record["price"] as? Double,
            let changePercentage = record["changePercentage"] as? String,
            let image = record["image"] as? CKAsset
            else { 
            return nil 
        }
        
        id = record.recordID
        self.symbol = symbol
        self.name = name
        self.sector = sector
        self.type = type
        self.price = price
        self.changePercentage = changePercentage
        
        self.image = image
        self.database = database
        
    }
    
    func loadLogoImage(completion: @escaping (_ photo: UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            var image: UIImage?
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            guard let logoImage = self.image, let fileURL = logoImage.fileURL else {
              return
            }
            
            let imageData: Data
            
            do {
                imageData = try Data(contentsOf: fileURL)
            } catch {
                return
            }
            
            image = UIImage(data: imageData)
        }
    }
}

extension Company: Hashable {
  static func == (lhs: Company, rhs: Company) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
