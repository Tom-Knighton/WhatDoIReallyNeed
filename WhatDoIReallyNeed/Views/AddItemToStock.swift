//
//  AddItemToStock.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 12/09/2022.
//

import Foundation
import SwiftUI

struct AddItemToStockView: View {
    
    var stockItems: FetchedResults<StockItem>
    
    @State private var itemName: String = ""
    @State private var amount: Int = 1
    var onAdd: (_ newItems: [NewStockItem]) -> ()
    
    @State private var newStockItems: [NewStockItem] = [NewStockItem(name: "", id: UUID().uuidString)]
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach($newStockItems, id: \.id) { $item in
                    BigTextField(text: $item.name, amount: $item.amount, prompt: "What to add, e.g. Toilet Paper or Cheese", maxCharacters: 30)
                        .shadow(radius: 3)
                        .background()
                        .onSubmit {
                            if item.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false &&
                                item.id == newStockItems.last?.id {
                                self.newStockItems.append(NewStockItem(name: "", id: UUID().uuidString))
                            }
                        }
                        .onChange(of: item.name) { value in
                            if newStockItems.count > 1 && item.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                self.newStockItems.removeAll(where: { $0.id == item.id })
                            }
                        }
                        .onChange(of: item.amount) { newValue in
                            if newValue < 0 {
                                item.amount = 0
                            }
                        }
                }
                Spacer()
                Button(action: { self.onAdd(newStockItems) }) {
                    Text("Add Items")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                Spacer().frame(height: 8)
            }
            
            .padding(.horizontal, 16)
            .navigationTitle("Add Items")
        }
    }
}
