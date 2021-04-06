//
//  StockObject.swift
//  StocksApp
//
//  Created by Мария Манкевич on 3/29/21.
//

import Foundation
import UIKit


struct StockData : Codable{
    let item: [String : StockObject]
}

struct StockObject: Codable{
    let quote: Quote
    let logo: Logo
}

struct Quote: Codable{
    let companyName: String
    let symbol: String
    let latestPrice: Double
    let change: Double
}

struct Logo: Codable{
    let url: String
}
