//
//  StockObject.swift
//  StocksApp
//
//  Created by Мария Манкевич on 3/29/21.
//

import Foundation

struct StockData : Decodable{
    let item: [String : StockObject]
}

struct StockObject: Decodable{
    let quote: Quote
    let logo: Logo
}

struct Quote: Decodable{
    let companyName: String
    let symbol: String
    let latestPrice: Double
    let change: Double
}

struct Logo: Decodable{
    let url: String
}
