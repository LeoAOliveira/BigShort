//
//  Stock.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 03/04/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import CloudKit

class Share {
    
    private let id: CKRecord.ID
    private(set) var priceLabel: String?
    let companyReference: CKRecord.Reference?
    
    init(record: CKRecord) {
        id = record.recordID
        priceLabel = record["price"] as? String
        companyReference = record["company"] as? CKRecord.Reference
    }
    
    static func fetchStocks(_ completion: @escaping (Result<[Share], Error>) -> Void) {
        
        let query = CKQuery(recordType: "Stock", predicate: NSPredicate(value: true))
        let container = CKContainer.default()
        
        container.privateCloudDatabase.perform(query, inZoneWith: nil) { results, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let results = results else {
                DispatchQueue.main.async {
                    let error = NSError(
                        domain: "com.Big-Short", code: -1,
                        userInfo: [NSLocalizedDescriptionKey:
                            "Could not download stocks"])
                    completion(.failure(error))
                }
                return
            }
            
            let notes = results.map(Share.init)
            DispatchQueue.main.async {
                completion(.success(notes))
            }
        }
    }
    
    static func fetchStocks(for references: [CKRecord.Reference], _ completion: @escaping ([Share]) -> Void) {
        
        let recordIDs = references.map { $0.recordID }
        let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
        operation.qualityOfService = .utility
        
        operation.fetchRecordsCompletionBlock = { records, error in
            let notes = records?.values.map(Share.init) ?? []
            DispatchQueue.main.async {
                completion(notes)
            }
        }
        
        Model.currentModel.privateDB.add(operation)
    }
}

extension Share: Hashable {
    static func == (lhs: Share, rhs: Share) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
