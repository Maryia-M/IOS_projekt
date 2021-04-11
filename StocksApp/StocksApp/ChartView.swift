//
//  ChartView.swift
//  StocksApp
//
//  Created by Мария Манкевич on 4/11/21.
//

import UIKit
import SwiftUI
import SwiftUICharts

struct ChartView: View {
    var body: some View{
        VStack{
            LineChartView(data: [1, 5, 2, 3, 4], title: "Line chart")
        }
    }  

}
