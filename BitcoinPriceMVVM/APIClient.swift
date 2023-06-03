//
//  APIClient.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 03/06/23.
//

import Foundation

public class APIClient {
    public static let shared = APIClient()
    
    init() {}
    
    ///Le va a devolver al ViewModel los datos decodificados de acuerdo al Model 
    func getPriceBitcoin(currency: String, completion: @escaping (_ price: BitcoinModel?, _ error: Error?) -> ()) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)/?apikey=86F7293F-835F-4675-9993-5EBA8D69A333"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, respuesta, error in
                guard let data = data else {
                    completion(nil, error)
                    return }
                
                let decodificador = JSONDecoder()
                
                do {
                    let dataDecodificada = try decodificador.decode(BitcoinModel.self, from: data)
                    print(dataDecodificada)
                    completion(dataDecodificada, nil)
                } catch {
                    print("Debug: error \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
}
