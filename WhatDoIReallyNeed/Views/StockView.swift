//
//  StockView.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//

import Foundation

import SwiftUI

struct StockView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var stockItems: FetchedResults<StockItem>
    @State private var searchText: String = ""
    @State private var showAddSheet: Bool = false
    @State private var error: CreateHomeError?
    @State private var presentError: Bool = false
    private var homeId: String
    
    init(homeId: String) {
        self.homeId = homeId
        self._stockItems = FetchRequest(entity: StockItem.entity(), sortDescriptors: [], predicate: NSPredicate(format: "homeId = %@", homeId))
    }
    
    var body: some View {
        List {
            if self.stockItems.count > 0 {
                ForEach(self.searchResults.filter { $0.itemAmount > 0 }.sorted(by: { $0.itemName < $1.itemName }), id: \.id) { stockItem in
                    HStack {
                        Text(stockItem.itemName + ":")
                        Text("\(stockItem.itemAmount)")
                        Spacer()
                        Stepper("") {
                            modifyAmount(stockItem, modifier: 1)
                        } onDecrement: {
                            modifyAmount(stockItem, modifier: -1)
                        }
                        .labelsHidden()
                    }
                }
            }
        }
        .navigationTitle("Available:")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .scrollContentBackground(.hidden)
        .background(Color.layer1)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { self.showAddSheet.toggle() }) {
                    Label("Add To Stock", systemImage: "plus.circle")
                    
                }
            }
            
        }
        .alert(isPresented: $presentError, error: self.error, actions: { error in
            if let suggestion = error.recoverySuggestion {
                Button(suggestion, action: {})
            }
        }, message: { error in
            if let failureReason = error.failureReason {
                Text(failureReason)
            } else {
                Text("Something went wrong")
            }
        })
        .sheet(isPresented: self.$showAddSheet) {
            AddItemToStockView(stockItems: self.stockItems, onAdd: { newItems in
                let items = Array(Set(newItems.compactMap { $0.name }))
                
                items.forEach { newItemName in
                    if let existing = stockItems.first(where: { $0.itemName == newItemName }) {
                        existing.itemAmount += newItems.filter({ $0.name == newItemName }).compactMap({ $0.amount }).reduce(0, +)
                    } else {
                        let item = StockItem(context: viewContext)
                        item.itemName = newItemName
                        item.itemAmount = newItems.filter({ $0.name == newItemName }).compactMap({ $0.amount }).reduce(0, +)
                        item.homeId = self.homeId
                    }
                }
                
                do {
                    try viewContext.save()
                    self.showAddSheet = false
                } catch {
                    self.error = CreateHomeError(errorDescription: "Error", failureReason: "An unknown error occurred saving this Home", recoverySuggestion: "Try again")
                    self.presentError = true
                }
                
            })
            .presentationDetents([.medium])
        }
    }
    
    func modifyAmount(_ stockItem: StockItem, modifier: Int) {
        stockItem.itemAmount += modifier
        if stockItem.itemAmount < 0 {
            stockItem.itemAmount = 0
        }
        
        do {
            try viewContext.save()
        }catch {
            print("Error!")
        }
    }
    
    var searchResults: [StockItem] {
        if searchText.isEmpty {
            return self.stockItems.compactMap({ $0 })
        }
        
        return self.stockItems.filter { $0.itemName.contains(self.searchText)}
    }
}
