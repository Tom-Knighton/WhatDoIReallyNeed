//
//  MainPage.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI

struct HomePage: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Home.entity(), sortDescriptors: []) private var homes: FetchedResults<Home>
    
    
#if os(iOS)
    private var layoutGrid: [GridItem] = UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())]
#else
    private var layoutGrid: [GridItem] = [GridItem(.flexible())]
#endif
    
    var body: some View {
        
        VStack {
            Text("Select Your Home:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .font(.callout.bold())
            
            LazyVGrid(columns: layoutGrid) {
                ForEach(homes) { home in
                    VStack {
                        Circle()
                            .fill(Color(hex: home.homeColour))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(home.homeIcon)
                                    .font(.system(size: 25))
                            )
                        Text(home.homeName)
                            .font(.title3.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Color(hex: home.homeColour)
                            .overlay(Material.thin)
                    )
                    .cornerRadius(10)
                    .shadow(color: Color(hex: home.homeColour ), radius: 1)
                    .padding(.vertical, 8)
                }
            }
            Button(action: {
                let home = Home(context: viewContext)
                home.homeName = "Random test \(Int.random(in: 0...100))"
                home.homeColour = "#313131"
                
                do {
                    try viewContext.save()
                } catch {
                    fatalError("oops")
                }
            }) {
                Text("Add test")
            }
            Spacer()
        }
        .navigationTitle("What Do I Really Need?")
        .padding(.horizontal, 16)
        
    }
}
