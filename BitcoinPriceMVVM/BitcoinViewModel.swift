//
//  BitcoinViewModel.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 03/06/23.
//

import Foundation
import Combine

class BitcoinViewModel {
    @Published var bitcoinPrice = "0.0"
    @Published var showLoading = false
    @Published var dateLastPrice = ""
    
    var exchangeRate = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    /// CONSUMIR LA API
}
