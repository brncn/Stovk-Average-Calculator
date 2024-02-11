//
//  APIService.swift
//  Stock Average Calculator
//
//  Created by Apollo on 6.02.2024.
//

import Foundation
import Combine

struct APIService {
    
    var API_KEY: String {
        
       return keys.randomElement() ?? ""
    }
    
    let keys = ["TR40JZLUFUOB0EMK","7W5RFK6RBDJPI4AT","UZZI9TCCQ49JIT4Z"]
    
    func fetchSYmbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
