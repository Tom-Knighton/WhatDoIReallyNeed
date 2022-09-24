//
//  HomePage.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//

import Foundation
import SwiftUI
import Introspect
import CoreData

struct HomePage: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var nc: UINavigationController?
    
    @FetchRequest private var homes: FetchedResults<Home>
    
    init(homeId: String) {
        self._homes = FetchRequest(entity: Home.entity(), sortDescriptors: [], predicate: NSPredicate(format: "homeId = %@", homeId))
    }
    
    var body: some View {
        ZStack {
            if let home = self.homes.first {
                ScrollView {
                    VStack {
                        NavigationLink(value: "STOCK_\(home.homeId)") {
                            VStack {
                                VStack {
                                    Text("See what \(home.homeName) already has:")
                                        .font(.headline.bold())
                                        .padding()
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color("Layer2"))
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .padding(.vertical)
                            }
                        }
                                             
                        Spacer()
                        
                        Button(action: { }) {
                            Text("I've used something")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(hex: home.homeColour).gradient)
                        Button(action: { self.addToHome() }) {
                            Text("Start a new list")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        }
                    .padding(.horizontal, 16)
                }
                .navigationTitle(home.homeName)
                .introspectNavigationController { nc in
                    self.nc = nc
                    nc.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: home.homeColour))]
                    nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: home.homeColour))]
                    
                    
                }
                .onAppear {
                    nc?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: home.homeColour))]
                    nc?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: home.homeColour))]
                }
                .onDisappear {
                    nc?.navigationBar.largeTitleTextAttributes = nil
                    nc?.navigationBar.titleTextAttributes = nil
                }
                .navigationDestination(for: String.self) { value in
                    if value.starts(with: "STOCK_") {
                        StockView(homeId: value.replacingOccurrences(of: "STOCK_", with: ""))
                    }
                }
                
            }
        }
        .background(Color.layer1)
        
        
    }
    
    func testDelete(_ home: Home) {
        do {
            viewContext.delete(home)
            try viewContext.save()
        } catch {
            print("")
            
        }
    }
    
    func addToHome() {
        do {
            if let home = self.homes.first {
                let stockItem = StockItem(context: viewContext)
                stockItem.autoAddWhenLow = false
                stockItem.itemAmount = 1
                stockItem.itemName = "Cheese"
                stockItem.homeId = home.homeId
                
                home.addToStockItems(stockItem)
                try viewContext.save()
            }
            
        } catch {
            fatalError("Uh oh")
        }
    }
}
