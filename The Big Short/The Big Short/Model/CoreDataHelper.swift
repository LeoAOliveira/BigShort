//
//  File.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 28/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper{
    
    init(){
        
        let container = NSPersistentContainer(name: "The_Big_Short")
        
        container.loadPersistentStores { (storeDescription, error) in
            
            if let error = error{
                
                print("\(error)")
                
            } else {
                
                print("CoreData fine!")
                
            }
        }
    }
    
    
    
    func saveContext(){
        
        do{
            
            try getContext().save()
            print("Context Coredata saved!")
            
        } catch{
            
            print("Saved failed!")
            
        }
        
    }
    
    
    
    func getContext() -> NSManagedObjectContext{ // Context = um rascunho basicamente que agrupa os dados armazenamos
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
        
    }
    
    
    
//    func storeStock (symbol: String, textFileUrlString: String, name: String){ // aqui é onde tudo ocorre
//        
//        let context = getContext()
//        
//        let entity = NSEntityDescription.entity(forEntityName: "Stock", in: context)
//        
//        let stock = NSManagedObject(entity: entity!, insertInto: context)
//        stock.setValue(audioFileUrlString, forKey: "audioFileUrlString")
//        stock.setValue(textFileUrlString, forKey: "textFileUrlString")
//        stock.setValue(name, forKey: "name")
//        
//        saveContext()
//        
//    }
    
    
    
    func getStocks() -> [NSManagedObject]?{
        
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do{
            
            let searchResults = try getContext().fetch(fetchRequest)
            
            print("Leo number of results: \(searchResults.count)")
            
            /*for transcription in searchResults as! [NSManagedObject]{
             
             print("Leo Result: \(transcription.value(forKey:"audioFileUrlString"))")
             
             }*/
            
            return searchResults as [NSManagedObject]
            
        } catch{
            
            print("Error with request")
            
        }
        
        return nil
    }
    
    
    
    func getById(id: NSManagedObjectID) -> Stock? {
        
        return getContext().object(with: id) as? Stock
        
    }
    
    
    
    func updateStock(stock: Stock){
        
        if let savedStock = getById(id: stock.objectID){
            
            savedStock.name = stock.name
            
            saveContext()
            
        }
        
        
        func getName() -> String{
            
            let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
            
            do{
                
                let searchResults = try getContext().fetch(fetchRequest)
                
                for stock in searchResults as [NSManagedObject]{
                    
                    print("Leo Result: \(stock.value(forKey:"name"))")
                    
                }
                
                return "\(searchResults as [NSManagedObject])"
                
            } catch{
                
                print("Error with request")
                
            }
            
            return ""
            
            
            
        }
        
        
        func getOneSpecificStock() -> URL? { //aqui
            
            let context = CoreDataHelper().getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Stock", in: context)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
            let stockFile = NSManagedObject(entity: entity!, insertInto: context)
            
            do{
                
                let searchResults = try context.fetch(fetchRequest)
                
                //print("Leo number of results: \(searchResults.count)")
                
                for stock in searchResults as! [NSManagedObject]{
                    
                    
                    stockFile.value(forKey: "audioFileUrlString")
                    
                    //print("Leo Result: \(transcription.value(forKey:"audioFileUrlString"))")
                    
                    print("Olá")
                    
                }
                
                return stockFile as? URL
                
            } catch{
                
                print("ERROOO")
                
                return nil
            }
            
            
        }
        
        
        
        
        /*func getOneTranscription (audioFileURL: URL, textFileURL: URL){
         
         let context = getContext()
         
         let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
         
         let transcription = NSManagedObject(entity: entity!, insertInto: context)
         
         //transcription.setValue(audioFileUrlString, forKey: "audioFileUrlString")
         //transcription.setValue(textFileURL, forKey: "textFileUrlString")
         
         transcription.didAccessValue(forKey: "audioFileUrlString")
         transcription.didAccessValue(forKey: "textFileUrlString")
         
         }*/
        
        
        /*getTextFileUrl() -> URL? {
         
         
         do{
         
         var textUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".txt")
         
         return textUrl
         
         }
         
         catch _ {
         
         return nil
         
         }
         
         }*/
        
        
    }
    
}
