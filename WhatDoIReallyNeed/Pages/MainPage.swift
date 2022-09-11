//
//  MainPage.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI

struct MainPage: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Home.entity(), sortDescriptors: []) private var homes: FetchedResults<Home>
    
    @Binding var selectedHome: Home?
    @State private var showingCreateHomeSheet: Bool = false
    
#if os(iOS)
    private var layoutGrid: [GridItem] = UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())]
#else
    private var layoutGrid: [GridItem] = [GridItem(.flexible())]
#endif
    
    init(selectedHome: Binding<Home?>) {
        self._selectedHome = selectedHome
    }
    
    var body: some View {
        
        ScrollView {
            let layout = UIDevice.current.userInterfaceIdiom == .phone ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
            Text("Select Your Home:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .font(.callout.bold())
            
            LazyVGrid(columns: layoutGrid) {
                ForEach(homes) { home in
                    layout {
                        Circle()
                            .fill(Color(hex: home.homeColour))
                            .frame(width: 50, height: 50)
                            .shadow(radius: 1)
                            .overlay(
                                Group {
                                    if home.homeIcon.starts(with: "SFS_") {
                                        Image(systemName: home.homeIcon.replacingOccurrences(of: "SFS_", with: ""))
                                    } else {
                                        Text(home.homeIcon)
                                    }
                                }
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            )
                        Text(home.homeName)
                            .font(.title3.bold())
                            .minimumScaleFactor(0.1)
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 100)
                    .padding()
                    .background(
                        Color(hex: home.homeColour)
                            .overlay(Material.thin)
                    )
                    .cornerRadius(10)
                    .shadow(color: Color(hex: home.homeColour ), radius: 1)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        self.selectedHome = home
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle("What Do I Really Need?")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { self.showingCreateHomeSheet.toggle() }) {
                    Label("New Home", systemImage: "plus.circle")
                        .labelStyle(.titleAndIcon)
                }
            }
        })
        .sheet(isPresented: self.$showingCreateHomeSheet) {
            CreateHomeView()
        }
        
    }
}
