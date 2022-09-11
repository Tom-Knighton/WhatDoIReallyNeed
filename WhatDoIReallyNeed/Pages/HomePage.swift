//
//  HomePage.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//

import Foundation
import SwiftUI
import Introspect

struct HomePage: View {

    @Environment(\.managedObjectContext) private var viewContext

    var home: Home
    
    @State private var nc: UINavigationController?

    @State private var titleColour: Color?

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    VStack {
                        Text("See \(home.homeName)'s stock")
                            .font(.headline.bold())
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("Layer2"))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.vertical)
                }

                Spacer()

                Button(action: { self.titleColour = nil }) {
                    Text("I've used something")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: home.homeColour).gradient)
                Button(action: { self.titleColour = nil }) {
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
    }
}
