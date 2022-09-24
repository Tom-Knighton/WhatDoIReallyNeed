//
//  MainPage.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI
import Introspect

struct MainPage: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Home.entity(), sortDescriptors: []) private var homes: FetchedResults<Home>
    
    @Binding var selectedHome: Home?
    @Binding var hasInit: Bool
    
    @State private var showingCreateHomeSheet: Bool = false
    
#if os(iOS)
    private var layoutGrid: [GridItem] = UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())]
#else
    private var layoutGrid: [GridItem] = [GridItem(.flexible())]
#endif
    
    init(selectedHome: Binding<Home?>, hasInit: Binding<Bool>) {
        self._selectedHome = selectedHome
        self._hasInit = hasInit
    }
    
    var body: some View {
        let layout: AnyLayout = UIDevice.current.userInterfaceIdiom == .phone ? AnyLayout(VStackLayout(spacing: 8)) : AnyLayout(HStackLayout())
        List(selection: $selectedHome) {
            ForEach(self.homes) { home in
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
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        )
                    Text(home.homeName)
                        .font(.title3.bold())
                        .minimumScaleFactor(0.1)
                }
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 100)
                .padding(8)
                .background(
                    Color(hex: home.homeColour)
                        .overlay(Material.thin)
                )
                .cornerRadius(10)
                .shadow(color: Color(hex: home.homeColour), radius: 1)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .tag(home)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.layer1)
        .navigationTitle("Homes")
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
        .introspectNavigationController { nc in
            nc.navigationBar.largeTitleTextAttributes = nil
        }
        .onAppear {
            if let first = self.homes.first, !hasInit {
                self.hasInit = true
                self.selectedHome = first
                print("XXX: Set")
            }
        }
    }
}
