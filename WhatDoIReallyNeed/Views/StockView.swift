//
//  StockView.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//

import Foundation
import SwiftUI

struct StockView: View {
    
    var home: Home
    
    var body: some View {
        List {
            ForEach(Array(self.home.stockItems), id: \.id) { stockItem in
                Text(stockItem.itemName)
            }
        }
    }
    
}
