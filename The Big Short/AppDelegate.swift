//
//  AppDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 11/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let color = UIColor(red: 137/255, green: 180/255, blue: 255/255, alpha: 1.0)
        UITabBar.appearance().tintColor = color
        
        let options: UNAuthorizationOptions = [.alert,.sound]
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("Notifications not allowed by user")
            }
        }
        
        let defaults = UserDefaults()
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let terms = defaults.string(forKey: "terms")
        
        var tela = storyboard.instantiateViewController(withIdentifier: "firstView")
        if terms == nil || terms == ""{
            tela = storyboard.instantiateViewController(withIdentifier: "firstView")
        }
        else{
            tela = storyboard.instantiateViewController(withIdentifier: "defaultView")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tela
        self.window?.makeKeyAndVisible()
        
        var wallet = [Wallet]()
        var stock = [Stock]()
        var word = [Glossary]()
        
        let context = self.persistentContainer.viewContext
        
        let opened = defaults.bool(forKey: "opened")
        let update1 = defaults.bool(forKey: "update1")
        
        if !opened{
            
            do {
                
                let registry = Wallet(context: context)
                registry.availableBalance = 1000.0
                registry.stocksValue = 0.0
                wallet.append(registry)
                
                self.saveContext()
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
            
            do {
                
                let stocks = [["ABEV3","Ambev SA", "ON", "Ambev", "Bebidas"],
                              ["AZUL4","Azul SA", "PN N2", "Azul", "Transporte aéreo"],
                              ["B3SA3","B3 SA - Brasil Bolsa Balcão", "ON NM", "B3", "Serviços financeiros diversos"],
                              ["BBAS3","Banco do Brasil SA", "ON NM", "BB", "Bancos"],
                              ["BBDC3","Banco Bradesco SA", "ON N1", "Bradesco", "Bancos"],
                              ["BBDC4","Banco Bradesco SA", "PN N1", "Bradesco", "Bancos"],
                              ["BBSE3","BB Seguridade Participações SA", "ON NM", "BB", "Previdência e seguros"],
                              ["BRAP4","Bradespar SA", "PN N1", "Bradespar", "Mineração"],
                              ["BRDT3","Petrobrás Distribuidora SA", "ON NM", "Petrobras", "Petróleo, gás e biocombustíveis"],
                              ["BRFS3","BRF SA", "ON NM", "brf", "Alimentos processados"],
                              ["BRKM5","Braskem SA", "PNA N1", "Braskem", "Petroquímicos"],
                              ["BRML3","BR Malls Participações SA", "ON NM", "brMalls", "Exploração de imóveis"],
                              ["BTOW3","B2W Cia Digital", "ON NM", "B2W", "Comércio"],
                              ["CCRO3","CCR SA", "ON NM", "CCR", "Exploração de rodovias"],
                              ["CIEL3","Cielo SA", "ON NM", "Cielo", "Serviços financeiros diversos"],
                              ["CMIG4","CEMIG", "PN N1", "CEMIG", "Energia elétrica"],
                              ["CSAN3","Cosan SA", "ON NM", "Cosan", "Petróleo, gás e biocombustíveis"],
                              ["CSNA3","Companhia Siderúrgica Nacional SA", "ON", "CSN", "Siderurgia"],
                              ["CVCB3","CVC Brasil Operadora e Agência de Viagens SA", "ON NM", "CVC", "Viagens e Turismo"],
                              ["CYRE3","Cyrela Brazil Realty SA", "ON NM", "Cyrela", "Construção civil"],
                              ["ECOR3","EcoRodovias Infraestrutura e Logística SA", "ON NM", "ecorodovias", "Exploração de rodovias"],
                              ["EGIE3","Engie Brasil Energia SA", "ON NM", "Engie", "Energia elétrica"],
                              ["ELET3","Eletrobras", "ON N1", "Eletrobras", "Energia elétrica"],
                              ["ELET6","Eletrobras", "PNB N1", "Eletrobras", "Energia elétrica"],
                              ["EMBR3","Embraer SA", "ON NM", "Embraer", "Material de transporte"],
                              ["ENBR3","EDP - Energias do Brasil SA", "ON NM", "edp", "Energia elétrica"],
                              ["EQTL3","Equatorial Energia SA", "ON NM", "Equatorial", "Energia elétrica"],
                              ["FLRY3","Fleury SA", "ON EJ NM", "Fleury", "Saúde"],
                              ["GGBR4","Gerdau SA", "PN N1", "Gerdau", "Siderurgia"],
                              ["GOAU4","Metalúrgica Gerdau SA", "PN N1", "Gerdau", "Siderurgia"],
                              ["GOLL4","GOL Linhas Aéreas Inteligentes SA", "PN N2", "GOL", "Transporte aéreo"],
                              ["HYPE3","Hypera SA", "ON NM", "Hypera", "Saúde"],
                              ["IGTA3","Iguatemi Empresa de Shopping Centers SA", "ON NM", "Iguatemi", "Exploração de imóveis"],
                              ["IRBR3","IRB Brasil Resseguros S/A", "ON NM", "IRB", "Previdência e seguros"],
                              ["ITSA4","Itaúsa - Investimentos Itaú SA", "PN N1", "Itausa", "Bancos"],
                              ["ITUB4","Itaú Unibanco Holding SA", "PN ED N1", "Itau", "Bancos"],
                              ["JBSS3","JBS SA", "ON NM", "JBS", "Alimentos processados"],
                              ["KLBN11","Klabin SA", "UNT N2", "Klabin", "Papel e celulose"],
                              ["KROT3","Kroton Educacional SA", "ON NM", "Kroton", "Serviços educacionais"],
                              ["LAME4","Lojas Americanas SA", "PN N1", "Americanas", "Comércio"],
                              ["LREN3","Lojas Renner SA", "ON NM", "Renner", "Comércio"],
                              ["MGLU3","Magazine Luiza SA", "ON NM", "magazineluiza", "Comércio"],
                              ["MRFG3","Marfrig Global Foods SA", "ON NM", "Marfrig", "Alimentos processados"],
                              ["MRVE3","MRV Engenharia e Participações SA", "ON NM", "MRV", "Construção civil"],
                              ["MULT3","Multiplan Empreendimentos Imobiliários SA", "ON N2", "Multiplan", "Exploração de imóveis"],
                              ["NATU3","Natura Cosmeticos SA", "ON NM", "Natura", "Produtos de uso pessoal e de limpeza"],
                              ["PCAR4","Companhia Brasileira de Distribuição", "PN N1", "GPA", "Comércio"],
                              ["PETR3","Petrobrás SA", "ON N2", "Petrobras", "Petróleo, gás e biocombustíveis"],
                              ["PETR4","Petrobrás SA", "PN N2", "Petrobras", "Petróleo, gás e biocombustíveis"],
                              ["QUAL3","Qualicorp Consultoria e Corretora de Seguros SA", "ON ED NM", "Qualicorp", "Saúde"],
                              ["RADL3","Raia Drogasil SA", "ON NM", "Raia", "Saúde"],
                              ["RAIL3","Rumo SA", "ON NM", "Rumo", "Transporte ferroviário"],
                              ["RENT3","Localiza Rent a Car SA", "ON NM", "Localiza", "Aluguel de carros"],
                              ["SANB11","Banco Santander Brasil SA", "UNT", "Santander", "Bancos"],
                              ["SBSP3","Sabesp", "ON NM", "Sabesp", "Água e saneamento"],
                              ["SMLS3","Smiles Fidelidade SA", "ON NM", "Smiles", "Programas de fidelização"],
                              ["SUZB3","Suzano SA", "ON NM", "Suzano", "Papel e celulose"],
                              ["TAEE11","Transmissora Aliança de Energia Elétrica SA", "UNT N2", "taesa", "Energia elétrica"],
                              ["TIMP3","TIM Participações SA", "ON NM", "TIM", "Telecomunicações"],
                              ["UGPA3","Ultrapar Participações SA", "ON NM", "Ultrapar", "Petróleo, gás e biocombustíveis"],
                              ["USIM5","Usiminas", "PNA N1", "Usiminas", "Siderurgia"],
                              ["VALE3","Vale SA", "ON NM", "Vale", "Mineração"],
                              ["VIVT4","Telefônica Brasil SA", "PN", "Telefonica", "Telecomunicações"],
                              ["VVAR3","Via Varejo SA", "ON NM", "Viavarejo", "Comércio"],
                              ["WEGE3","WEG SA", "ON ED NM", "WEG", "Máquinas e equipamentos"],
                              ["YDUQ3","Estácio Participações SA", "ON NM", "Estacio", "Serviços educacionais"]]
                
                
                for i in 0...stocks.count-1{
                
                    let registry = Stock(context: context)

                    registry.symbol = stocks[i][0]
                    registry.name = stocks[i][1]
                    registry.type = stocks[i][2]
                    registry.imageName = stocks[i][3]
                    registry.sector = stocks[i][4]
                    stock.append(registry)

                    self.saveContext()
                }
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
            
            do {
                
                let words = [["Ação","\"Ações representam uma fração do capital social de uma empresa. Ao comprar uma ação o investidor se torna sócio da empresa, ou seja, de um negócio. Passa a correr os riscos deste negócio bem como participa dos lucros e prejuízos como qualquer empresário.\"", "XP Investimentos", "https://www.xpi.com.br/investimentos/acoes/o-que-sao-acoes/"],
                    
                    ["Ação Ordinária (ON)", "\"Sua principal característica é conferir ao seu titular direito a voto nas Assembleias de acionistas.\"", "Portal do Investidor", "https://www.investidor.gov.br/menu/Menu_Investidor/valores_mobiliarios/Acoes/especies_de_acoes.html"],
                    
                    ["Ação Preferencial (PN)", "\"A Lei das S.A. permite que uma sociedade emita ações preferenciais, que podem ter seu direito de voto suprimido ou restrito, por disposição do estatuto social da companhia. Em contrapartida, tais ações deverão receber uma vantagem econômica em relação às ações ordinárias.\"\n\"As vantagens econômicas a serem conferidas às ações preferenciais em troca dos direitos políticos suprimidos, conforme dispõe a Lei, poderão consistir em prioridade de distribuição de dividendo, fixo ou mínimo, prioridade no reembolso do capital, com prêmio ou sem ele, ou a cumulação destas vantagens.\"", "Portal do Investidor", "https://www.investidor.gov.br/menu/Menu_Investidor/acionistas/participacao_nos_resultados.html"],
                    
                    ["Bolsa de Valores","\"A bolsa de valores é um ambiente de negociação no qual investidores podem comprar ou vender seus títulos emitidos por empresas, sejam elas com capitais públicos, mistos ou privados. Esse processo é intermediado com auxílio de correspondentes de negociações através de corretoras.\"", "BTG Pactual", "https://www.btgpactualdigital.com/blog/investimentos/tudo-sobre-bolsa-de-valores"],
                    
                    ["B3 - Brasil, Bolsa, Balcão","\"Em 2008, a Bovespa integrou-se operacionalmente com a BM&F - principal bolsa de mercadorias e contratos futuros do Brasil - criando a BMF&Bovesp. Fruto da combinação entre a BM&FBOVESPA e a Cetip, nasce a B3. É o principal mercado de negociação de valores mobiliários no Brasil, com mais de meio milhão de investidores individuais cadastrados.\"", "Corretora Rico", "https://blog.rico.com.vc/investir-na-bolsa-de-valores"],
                    
                    ["CDI","\"O CDI, ou Certificado de Depósito Interbancário, é uma taxa que determina o rendimento anual de diversos tipos de investimento. Em 2018, por exemplo, a taxa CDI do ano foi de 6,40%. Portanto, entender o que é a taxa CDI é importante na hora de escolher o melhor lugar para deixar o seu dinheiro rendendo – o que, no fim das contas, influencia o quanto pode entrar no seu bolso.\"", "Nubank", "https://blog.nubank.com.br/cdi-o-que-e/"],
                    
                    ["Corretora de Valores","\"As Corretoras de Valores são instituições financeiras membros das Bolsas de Valores habilitadas, com exclusividade, para negociar valores mobiliários no pregão das Bolsas. Sua função é intermediar as operações financeiras (compra e venda de valores mobiliários), entre os investidores nas Bolsas de Valores, agindo como agente canalizador das operações de compra e venda de ações para o ambiente de negociação, que é o pregão da Bolsa de Valores.\"", "Bússola do Investidor", "https://www.bussoladoinvestidor.com.br/abc_do_investidor/corretora_de_valores/"],
                    
                    ["Dividendos", "\"O dividendo é a parte do lucro de uma empresa que é dividida com seus acionistas, como uma forma de bonificação ao investimento feito. Ao adquirir uma ação, o acionista passa a ter parte da empresa e os direitos acerca dos lucros que esta tiver. Os dividendos podem ser pagos em dinheiro, como também em forma de ações adicionais, ou seja, uma 'parte adicional' da empresa aos acionistas.\"", "Dicionário Financeiro", "https://www.dicionariofinanceiro.com/dividendos/"],
                    
                    ["Horário de negociação", "Início: 9:45\nFim: 16:55", "B3 - Brasil, Bolsa, Balcão", "http://www.b3.com.br/pt_br/solucoes/plataformas/puma-trading-system/para-participantes-e-traders/horario-de-negociacao/acoes/"],
                    
                    ["Índice Bovespa (Ibovespa)", "\"O Ibovespa é o principal indicador de desempenho das ações negociadas na B3 e reúne as empresas mais importantes do mercado de capitais brasileiro. Foi criado em 1968 e, ao longo desses 50 anos, consolidou-se como referência para investidores ao redor do mundo. Reavaliado a cada quatro meses, o índice é resultado de uma carteira teórica de ativos. É composto pelas ações e units de companhias listadas na B3 que atendem aos critérios descritos na sua metodologia, correspondendo a cerca de 80% do número de negócios e do volume financeiro do nosso mercado de capitais.\"", "B3 - Brasil, Bolsa, Balcão", "http://www.b3.com.br/pt_br/market-data-e-indices/indices/indices-amplos/ibovespa.htm"],
                    
                    ["Investimento","\"Investimento é, de forma resumida, pegar uma quantia hoje e tentar transformá-la em mais dinheiro no futuro. Investir é gerar riqueza a partir de recursos financeiros excedentes. Investir pressupõe o entendimento de que existem opções melhores, ou mais eficientes, para alocar o excedente de recursos. Isso passa pela ideia de comprar barato e vender caro. Bons investidores extraem o maior lucro possível dentro da estratégia estabelecida e dos objetivos a serem atingidos.\"", "BTG Pactual", "https://www.btgpactualdigital.com/blog/coluna-gustavo-cerbasi/o-que-significa-investir"],
                    
                    ["IOF","\"São contribuintes do IOF as pessoas físicas e as pessoas jurídicas que efetuarem operações de crédito, câmbio e seguro ou relativas a títulos ou valores mobiliários. A cobrança e o recolhimento do imposto são efetuados pelo responsável tributário: a pessoa jurídica que conceder o crédito; as instituições autorizadas a operar em câmbio; as seguradoras ou as instituições financeiras a quem estas encarregarem da cobrança do prêmio de seguro; as instituições autorizadas a operar na compra e venda de títulos ou valores mobiliários.\"", "Receita Federal", "http://receita.economia.gov.br/acesso-rapido/tributos/IOF"],
                    
                    ["Liquidez","\"Liquidez é a facilidade de um ativo ser transformado em dinheiro sem perdas significativas em seu valor. Esse conceito se refere à agilidade com que um investidor consegue se desfazer de um investimento para voltar a ter dinheiro na mão sem que, para isso, precise ter prejuízo.\"", "Dicionário Financeiro", "https://www.dicionariofinanceiro.com/liquidez/"],
                    
                    ["Lote","\"Um lote é equivalente a 100 ações. Isso significa que se a ação que você pretende comprar está cotada em R$ 1, o preço mínimo do aporte é R$100.\"", "Corretora Rico", "https://blog.rico.com.vc/investir-na-bolsa-de-valores"],
                    
                    ["Lucro bruto","\"O resultante da diferença entre o preço da aquisição e o atingido na venda, sem dedução das despesas.\"", "Dicionário Michaelis", "http://michaelis.uol.com.br/moderno-portugues/busca/portugues-brasileiro/lucro/"],
                    
                    ["Lucro líquido","\"Diferença entre o preço de venda e o total dos gastos na realização da operação.\"", "Dicionário Michaelis", "http://michaelis.uol.com.br/moderno-portugues/busca/portugues-brasileiro/lucro/"],
                    
                    ["Mercado de Ações","\"O mercado de ações é um ambiente onde são negociados ativos financeiros tais como ações, opções de ações, contratos futuros (BM&F) e Fundos de Investimento Imobiliário. As negociações de compra e venda ocorrem na Bolsa de Valores. Todas as operações e seus participantes são regulados e fiscalizados pela Comissão de Valores Mobiliários (CVM).\"", "Corretora Rico", "https://blog.rico.com.vc/investir-na-bolsa-de-valores"],
                    
                    ["Pregão","\"O Pregão é uma das modalidades de licitação veiculadas no Brasil. Esta modalidade possibilita o incremento da competitividade e ampliação das oportunidades de participação nas operações de compra e venda de ativos financeiros, por Pessoas Jurídicas ou Físicas. Assim o Pregão se constitui como a janela, ou sessão, de transações feitas em lances de compra e venda das ações negociadas numa bolsa de valores, que pode ser feito diretamente na sala de negociações ou por via eletrônica através dos sistemas de negociação da BMF&Bovespa.\"", "Bússola do Investidor", "https://www.bussoladoinvestidor.com.br/abc_do_investidor/pregao/"],
                    
                    ["Prejuízo","\"Perda de lucro, certo e positivo, que se deixou de obter.\"", "Dicionário Michaelis", "https://michaelis.uol.com.br/moderno-portugues/busca/portugues-brasileiro/preju%C3%ADzo/"],
                    
                    ["Rentabilidade","\"A rentabilidade é um dos termos mais importantes usados no mercado financeiro. Ela nada mais é do que o retorno que você tem sobre o investimento que foi realizado. Assim, ela pode ser definida através de taxas tanto pré quanto pós-fixadas, de vínculos com índices de inflação ou baseadas apenas na valorização, como acontece no mercado de ações. \"", "Corretora Rico", "https://blog.rico.com.vc/termo-mercado-financeiro/"],
                    
                    ["Risco","\"O risco é inerente a qualquer atividade de investimento e constitui o outro lado da moeda do ponto de vista da recompensa. Em termos genéricos, quanto maior o risco do investimento, maior a recompensa, desde que seja positivo. O risco pode ser gerido, mas, primeiro, deve ser rigorosamente identificado.\"", "Capital.com", "https://capital.com/pt/risco-definicao"],
                    
                    ["Risco de liquidez","\"Ele é, basicamente, o risco de você não conseguir vender suas ações, caso compre títulos de empresas que são pouco negociadas na bolsa. Por isso, é sempre bom estar atento às tendências e movimentações no mercado antes de investir.\"", "BTG Pactual", "https://www.btgpactualdigital.com/blog/investimentos/tudo-sobre-bolsa-de-valores"],
                    
                    ["Risco de desvalorização do ativo","\"Você compra uma ação, a empresa vai mal, as ações caem e você não recupera o investimento\"", "BTG Pactual", "https://www.btgpactualdigital.com/blog/investimentos/tudo-sobre-bolsa-de-valores"],
                    
                    ["Taxa de custódia","\"Essa taxa é mensal e cobrada pela BM&FBovespa para a guarda dos títulos\"", "Corretora Rico", "https://blog.rico.com.vc/investir-na-bolsa-de-valores"],
                    
                    ["Taxa Selic","\"​A Selic é a taxa básica de juros da economia. É o principal instrumento de política monetária utilizado pelo Banco Central (BC) para controlar a inflação. Ela influencia todas as taxas de juros do país, como as taxas de juros dos empréstimos, dos financiamentos e das aplicações financeiras. A taxa Selic refere-se à taxa de juros apurada nas operações de empréstimos de um dia entre as instituições financeiras que utilizam títulos públicos federais como garantia. O BC opera no mercado de títulos públicos para que a taxa Selic efetiva esteja em linha com a meta da Selic definida na reunião do Comitê de Política Monetária do BC (Copom).\"", "Banco Central do Brasil", "https://www.bcb.gov.br/controleinflacao/taxaselic"]]
            
                for i in 0...words.count-1{
                    
                    let registry = Glossary(context: context)
                    
                    registry.word = words[i][0]
                    registry.meaning = words[i][1]
                    registry.source = words[i][2]
                    registry.sourceURL = words[i][3]
                    word.append(registry)
                    
                    self.saveContext()
                }
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
        
            defaults.set(true, forKey: "opened")
            defaults.set(true, forKey: "update1")
        }
        
        if !update1{
            
            do {
                
                var data1: [Wallet] = []
                var data2: [Stock] = []
                
                data1 = try context.fetch(Wallet.fetchRequest())
                data2 = try context.fetch(Stock.fetchRequest())
                
                var inicialInvestment: Float = data1[0].availableBalance
                
                var stockList: [String] = []
                
                if data1[0].stock1 != nil{
                    stockList.append(data1[0].stock1!)
                }
                
                if data1[0].stock2 != nil{
                    stockList.append(data1[0].stock2!)
                }
                
                if data1[0].stock3 != nil{
                    stockList.append(data1[0].stock3!)
                }
                
                if data1[0].stock4 != nil{
                    stockList.append(data1[0].stock4!)
                }
                
                if data1[0].stock5 != nil{
                    stockList.append(data1[0].stock5!)
                }
                
                data1[0].stock1 = nil
                data1[0].stock2 = nil
                data1[0].stock3 = nil
                data1[0].stock4 = nil
                data1[0].stock5 = nil
                
                for i in 0...65{
                    
                    inicialInvestment += data2[i].invested
                    
                    data2[i].income = 0.0
                    data2[i].invested = 0.0
                    data2[i].amount = 0.0
                    data2[i].change = 0.0
                    data2[i].close = 0.0
                    data2[i].price = 0.0
                    data2[i].mediumPrice = 0.0
                    
                }
                
                let cost: Float = Float(stockList.count) * 10.0
                
                data1[0].availableBalance = inicialInvestment + cost
                
                do{
                    try context.save()
                    
                } catch{
                    print("Error when saving context")
                }
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
            
            
            defaults.set(true, forKey: "update1")
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

