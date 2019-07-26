//
//  AppDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 11/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var wallet = [Wallet]()
        var stock = [Stock]()
        
        let context = self.persistentContainer.viewContext
        
        let defaults = UserDefaults()
        let opened = defaults.bool(forKey: "opened")
        
        if !opened{
            
            do {
                
                let registry = Wallet(context: context)
                    
                registry.totalValue = 10000
                registry.availableBalance = 8000
                registry.stocksValue = 1000
                registry.publicTitlesValue = 500
                registry.dollarValue = 300
                registry.savingsValue = 200
                wallet.append(registry)
                
                self.saveContext()
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
            
            do {
                
                let stocks = [["ABEV3","Ambev SA"], ["AZUL4","Azul SA"], ["B3SA3","B3 SA - Brasil Bolsa Balcão"], ["BBAS3","Banco do Brasil SA"], ["BBDC3","Banco Bradesco SA"], ["BBDC4","Banco Bradesco SA"], ["BBSE3","BB Seguridade Participações SA"], ["BRAP4","Bradespar SA"], ["BRDT3","Petrobras Distribuidora SA"], ["BRFS3","BRF SA"], ["BRKM5","Braskem SA"], ["BRML3","BR Malls Participações SA"], ["BTOW3","B2W Cia Digital"], ["CCRO3","CCR SA"], ["CIEL3","Cielo SA"], ["CMIG4","CEMIG"],["CSAN3","Cosan SA"], ["CSNA3","Companhia Siderúrgica Nacional SA"], ["CVCB3","CVC Brasil Operadora e Agência de Viagens SA"], ["CYRE3","Cyrela Brazil Realty SA"], ["ECOR3","EcoRodovias Infraestrutura e Logística SA"], ["EGIE3","Engie Brasil Energia SA"], ["ELET3","Eletrobras"], ["ELET6","Eletrobras"], ["EMBR3","Embraer SA"], ["ENBR3","EDP - Energias do Brasil SA"], ["EQTL3","Equatorial Energia SA"], ["ESTC3","Estácio Participações SA"], ["FLRY3","Fleury SA"], ["GGBR4","Gerdau SA"], ["GOAU4","Metalúrgica Gerdau SA"], ["GOLL4","GOL Linhas Aéreas Inteligentes SA"], ["HYPE3","Hypera SA"], ["IGTA3","Iguatemi Empresa de Shopping Centers SA"], ["IRBR3","IRB Brasil Resseguros S/A"], ["ITSA4","Itaúsa - Investimentos Itaú SA"], ["ITUB4","Itaú Unibanco Holding SA"], ["JBSS3","JBS SA"], ["KLBN11","Klabin SA"], ["KROT3","Kroton Educacional SA"], ["LAME4","Lojas Americanas SA"], ["LREN3","Lojas Renner SA"], ["MGLU3","Magazine Luiza SA"], ["MRFG3","Marfrig Global Foods SA"], ["MRVE3","MRV Engenharia e Participações SA"], ["MULT3","Multiplan Empreendimentos Imobiliários SA"], ["NATU3","Natura Cosmeticos SA"], ["PCAR4","Companhia Brasileira de Distribuição"], ["PETR3","Petrobrás SA"], ["PETR4","Petrobrás SA"], ["QUAL3","Qualicorp Consultoria e Corretora de Seguros SA"], ["RADL3","Raia Drogasil SA"], ["RAIL3","Rumo SA"], ["RENT3","Localiza Rent a Car SA"], ["SANB11","Banco Santander Brasil SA"], ["SBSP3","Sabesp"], ["SMLS3","Smiles Fidelidade SA"], ["SUZB3","Suzano SA"], ["TAEE11","Transmissora Aliança de Energia Elétrica SA"], ["TIMP3","TIM Participações SA"], ["UGPA3","Ultrapar Participações SA"], ["USIM5","Usiminas"], ["VALE3","Vale SA"], ["VIVT4","Telefônica Brasil SA"], ["VVAR3","Via Varejo SA"], ["WEGE3","WEG SA"]]
                
                
                for i in 0...stocks.count-1{
                    
//                    let registry = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: self.persistentContainer.viewContext) as! Stock
//
//                    registry.text = stocks[i][0].symbol
//                    registry.text = stocks[i][1].name
//
//                    self.saveContext()
                
                    
                    let registry = Stock(context: context)

                    registry.symbol = stocks[i][0]
                    registry.name = stocks[i][1]
                    stock.append(registry)

                    self.saveContext()
                }
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
        
            defaults.set(true, forKey: "opened")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "The_Big_Short")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

