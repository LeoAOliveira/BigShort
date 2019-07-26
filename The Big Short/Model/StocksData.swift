//
//  ViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 11/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class StocksData {
    
    let stock: Dictionary = ["ABEV3":"Ambev SA", "AZUL4":"Azul SA", "B3SA3":"B3 SA - Brasil Bolsa Balcão", "BBAS3":"Banco do Brasil SA", "BBDC3":"Banco Bradesco SA", "BBDC4":"Banco Bradesco SA", "BBSE3":"BB Seguridade Participações SA", "BRAP4":"Bradespar SA", "BRDT3":"Petrobras Distribuidora SA", "BRFS3":"BRF SA", "BRKM5":"Braskem SA", "BRML3":"BR Malls Participações SA", "BTOW3":"B2W Cia Digital", "CCRO3":"CCR SA", "CIEL3":"Cielo SA", "CMIG4":"CEMIG", "CSAN3":"Cosan SA", "CSNA3":"Companhia Siderúrgica Nacional SA", "CVCB3":"CVC Brasil Operadora e Agência de Viagens SA", "CYRE3":"Cyrela Brazil Realty SA", "ECOR3":"EcoRodovias Infraestrutura e Logística SA", "EGIE3":"Engie Brasil Energia SA", "ELET3":"Eletrobras", "ELET6":"Eletrobras", "EMBR3":"Embraer SA", "ENBR3":"EDP - Energias do Brasil SA", "EQTL3":"Equatorial Energia SA", "ESTC3":"Estácio Participações SA", "FLRY3":"Fleury SA", "GGBR4":"Gerdau SA", "GOAU4":"Metalúrgica Gerdau SA", "GOLL4":"GOL Linhas Aéreas Inteligentes SA", "HYPE3":"Hypera SA", "IGTA3":"Iguatemi Empresa de Shopping Centers SA", "IRBR3":"IRB Brasil Resseguros S/A", "ITSA4":"Itaúsa - Investimentos Itaú SA", "ITUB4":"Itaú Unibanco Holding SA", "JBSS3":"JBS SA", "KLBN11":"Klabin SA", "KROT3":"Kroton Educacional SA", "LAME4":"Lojas Americanas SA", "LREN3":"Lojas Renner SA", "MGLU3":"Magazine Luiza SA", "MRFG3":"Marfrig Global Foods SA", "MRVE3":"MRV Engenharia e Participações SA", "MULT3":"Multiplan Empreendimentos Imobiliários SA", "NATU3":"Natura Cosmeticos SA", "PCAR4":"Companhia Brasileira de Distribuição", "PETR3":"Petrobrás SA", "PETR4":"Petrobrás SA", "QUAL3":"Qualicorp Consultoria e Corretora de Seguros SA", "RADL3":"Raia Drogasil SA", "RAIL3":"Rumo SA", "RENT3":"Localiza Rent a Car SA", "SANB11":"Banco Santander Brasil SA", "SBSP3":"Sabesp", "SMLS3":"Smiles Fidelidade SA", "SUZB3":"Suzano SA", "TAEE11":"Transmissora Aliança de Energia Elétrica SA", "TIMP3":"TIM Participações SA", "UGPA3":"Ultrapar Participações SA", "USIM5":"Usiminas", "VALE3":"Vale SA", "VIVT4":"Telefônica Brasil SA", "VVAR3":"Via Varejo SA", "WEGE3":"WEG SA"]
    
//    for (key,value) in someDic {
//    print("key:\(key) value:\(value)")
//    }

    
    struct Stocks{
        
        let lastRefreshed: String
        let close: String
        let open: String
        let dividendAmount: String
        
        init(json: [String: Any]) {
            
            if let metaData = json["Meta Data"] as? [String: Any]{
                
                lastRefreshed = metaData["3. Last Refreshed"] as? String ?? "ERRO1"
                
            } else{
                lastRefreshed = "ERRO 11"
            }
            
            if let timeSeries = json["Time Series (Daily)"] as? [String: Any]{
                
                let dateCurrent = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: dateCurrent)
                
                if let day = timeSeries["\(dateString)"] as? [String: Any]{
                
                    open = day["1. open"] as? String ?? "ERRO2"
                    close = day["4. close"] as? String ?? "ERRO3"
                    dividendAmount = day["7. dividend amount"] as? String ?? "ERRO4"
                
                } else{
                    open = "ERRO22"
                    close = "ERRO33"
                    dividendAmount = "ERRO44"
                }
                
            } else{
                open = "ERRO22"
                close = "ERRO33"
                dividendAmount = "ERRO44"
            }
        }
        
    }
    
    
    func alphaVantageFetch(){
        
        let apiKey = "COR1E5U5AX51SRR7"
        
        let stockString = "ABEV3" + ".SA"
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(stockString)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else{
            print("Erro 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error{
                    print("Erro 2")
                    return
                }
                
                guard let data = data else{
                    print("Erro 3")
                    return
                }
                
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{
                        return
                    }
                    
                    let stock = Stocks(json: json)
                    print(stock.lastRefreshed)
                    print(stock.open)
                    print(stock.close)
                    print(stock.dividendAmount)
                    
                } catch let err{
                    print(err.localizedDescription)
                }
            }
            
        }.resume()
    }
    
    
    func bloombergDataFetch(){
        
        // let bloombergURL = "https://www.bloomberg.com/quote/IBOV:IND/members"
        
        let bloombergURL = URL(string: "https://www.bloomberg.com/quote/IBOV:IND/members")!
        
        let task = URLSession.shared.dataTask(with: bloombergURL) { (data, response, error) in
            
            guard let data = data else{
                print("data was nil")
                return
            }
            
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else{
                print("cannot cast data into string")
                return
            }
            
            // print(htmlString)
            
            let leftSideOfTheValue = """
<a class="security-summary__ticker" href="/quote/ABEV3:BZ">ABEV3:BZ</a><div class="security-summary__head-row-details">  <div class="security-summary__price">
"""
            
            let rightSideOfTheValue = """
</div>  <div class="security-summary__price-change">
"""
            
            guard let leftRange = htmlString.range(of: leftSideOfTheValue) else{
                print("Error left")
                return
            }
            
            guard let rightRange = htmlString.range(of: rightSideOfTheValue) else{
                print("Error right")
                return
            }
            
            let rangeOfTheValue = leftRange.upperBound..<rightRange.lowerBound
            
            print(htmlString[rangeOfTheValue])
        }
        
        task.resume()
    }
    
    
    func b3DataFetch(symbol: String){
        
        let b3URL = URL(string: "http://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/cotacoes/?tvwidgetsymbol=\(symbol)")!
        
        let task = URLSession.shared.dataTask(with: b3URL) { (data, response, error) in
            
            guard let data = data else{
                print("data was nil")
                return
            }
            
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else{
                print("cannot cast data into string")
                return
            }
            
            // print(htmlString)
            
//            let leftSideOfTheValue = """
//"""
//
//            let rightSideOfTheValue = """""
//"""
//
//            guard let leftRange = htmlString.range(of: leftSideOfTheValue) else{
//                print("Error left")
//                return
//            }
//
//            guard let rightRange = htmlString.range(of: rightSideOfTheValue) else{
//                print("Error right")
//                return
//            }
//
//            let rangeOfTheValue = leftRange.upperBound..<rightRange.lowerBound
//
//            print(htmlString[rangeOfTheValue])
        }
        
        task.resume()
    }


}

