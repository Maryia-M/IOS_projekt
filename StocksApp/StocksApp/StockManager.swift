//
//  StockManager.swift
//  StocksApp
//
//  Created by Мария Манкевич on 4/5/21.
//

import Foundation
import UIKit

class StockManager{
    
    private var tickers = [
            "AAPL",
            "MSFT",
            "GOOG",
            "AMZN",
            "FB",
            "INTC",
            "YNDX",
            "CSCO",
            "ORCL",
            "BKNG",
            "UBER",
            "FDX",
            "BIDU"
        ]
    
    init(){
    }
}

extension StockManager{
    
    struct StockManagerAPI{
        static let scheme = "https"
        static let host = "cloud.iexapis.com"
    }
    
    func search() -> URLComponents{
        let companies = tickers.joined(separator: ",")
        print(companies)
        var components = URLComponents()
        components.scheme = StockManagerAPI.scheme
        components.host = StockManagerAPI.host
        components.path = "/stable/stock/market/batch"
        components.queryItems = [URLQueryItem(name: "token", value: "pk_2daee599f0244e859f0a0f11989760c4"),
                                 URLQueryItem(name: "symbols", value: companies),
                                 URLQueryItem(name: "types", value: "quote,logo")
        ]
        return components;
    }
    
    
}
