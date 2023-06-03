//
//  BitcoinViewModel.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 03/06/23.
//

import Foundation
import Combine

class BitcoinViewModel {
    @Published var bitcoinPrice = "$0.0"
    @Published var showLoading = false
    @Published var dateLastPrice = "\(Date.now)"
    
    var exchangeRate = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    /// CONSUMIR LA API
    let apiclient : APIClient
    
    init(apiclient: APIClient) {
        self.apiclient = apiclient
    }
    
    ///Utilizar el apiclient para pedirle el price
    func getPrice(with currency: String){
        apiclient.getPriceBitcoin(currency: currency) { price, error in
            guard let price = price else { return }
            
            DispatchQueue.main.async {
                self.bitcoinPrice = "$\(price.rate)"
                self.dateLastPrice = price.time
            }
        }
    }
}
