//
//  CompanyDescription.swift
//  StocksApp
//
//  Created by Мария Манкевич on 4/5/21.
//

import Foundation

struct CompanyDescription : Codable{
    let companyName: String
    let website: String
    let city: String?
    let country: String?
    let description: String
}
