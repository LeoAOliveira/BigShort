//
//  CloudModel.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 03/04/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import CloudKit

class Model {
    
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase

    // MARK: - Properties
    private(set) var companies: [Company] = []
    static var currentModel = Model()

    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }

    @objc func refresh(_ completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Company", predicate: predicate)
        companies(forQuery: query, completion)
    }

    
    private func companies(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
    
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
      
            guard let self = self else {
                return 
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let results = results else {
                return 
            }
            
            self.companies = results.compactMap {
                Company(record: $0, database: self.publicDB)
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
}
