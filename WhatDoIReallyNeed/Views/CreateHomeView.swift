//
//  CreateHomeView.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI
import Introspect


struct CreateHomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var homeName: String = ""
    @State private var homeIcon: String?
    @State private var homeEmoji: String?
    
    @State private var error: CreateHomeError?
    @State private var presentError: Bool = false
    
    @State private var possibleColours: [Color] = []
    
    private let swatchGrid: [GridItem] = [GridItem(.adaptive(minimum: 50))]
    private let colourSwatches: [Color] = [
        .green, .mint, .teal, .cyan, .blue, .indigo, .yellow, .orange, .pink, .red, .purple, .gray,  .brown,
    ]
    @State private var selectedSwatch: Color = .green
    @State private var showEmojis: Bool = false
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: 12)
                    Button(action: { self.showEmojis.toggle() }) {
                        Circle()
                            .fill(self.selectedSwatch)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Group {
                                    if let icon = self.homeIcon {
                                        Image(systemName: icon)
                                    } else if let emoji = self.homeEmoji {
                                        Text(emoji)
                                    } else {
                                        Image(systemName: "plus.circle")
                                    }
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 32))
                                .shadow(radius: 10)
                                .onTapGesture(perform: {
                                    self.showEmojis.toggle()
                                })
                            )
                            .shadow(radius: 3)
                    }
                    
                    Spacer().frame(height: 16)
                    
                    BigTextField(text: self.$homeName, prompt: "Choose a name for your Home", maxCharacters: 30)
                        .textInputAutocapitalization(.words)
                    
                    Spacer().frame(height: 16)
                    
                    LazyVGrid(columns: self.swatchGrid) {
                        ForEach(self.colourSwatches, id: \.self) { swatch in
                            ZStack {
                                Circle()
                                    .fill(swatch)
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                if let selectedSwatch, selectedSwatch == swatch {
                                    Circle()
                                        .stroke(swatch, lineWidth: 5)
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .onTapGesture {
                                self.selectedSwatch = swatch
                            }
                        }
                    }
                    
                    Spacer().frame(height: 8)
                    
                    Button(action: { self.trySubmit() }) {
                        Text("Create Home")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                .navigationTitle("Create a new Home")
                .padding(.horizontal, 16)
                .sheet(isPresented: self.$showEmojis) {
                    IconPickerView(selectedIcon: self.$homeIcon, selectedEmoji: self.$homeEmoji)
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
            }
        }
        
    }
    
    func trySubmit() {
        let name = self.homeName.trimmingCharacters(in: .whitespacesAndNewlines)
        var icon: String?
        if let homeIcon {
            icon = "SFS_\(homeIcon)"
        } else if let homeEmoji {
            icon = homeEmoji
        }
        let colour: String? = self.selectedSwatch.toHex()
        
        guard !name.isEmpty,
              name != "",
              name.count >= 3 else {
            self.error = CreateHomeError(errorDescription: "Error", failureReason: "You must enter a valid name for this Home", recoverySuggestion: "Ok")
            self.presentError = true
            return
        }
        
        guard let icon else {
            self.error = CreateHomeError(errorDescription: "Error", failureReason: "You must choose an icon for this Home", recoverySuggestion: "Ok")
            self.presentError = true
            return
        }
        
        guard let colour else {
            self.error = CreateHomeError(errorDescription: "Error", failureReason: "You must choose a colour for this Home", recoverySuggestion: "Ok")
            self.presentError = true
            return
        }
        
        let home = Home(context: viewContext)
        home.homeIcon = icon
        home.homeName = name
        home.homeColour = colour
                
        do {
            try viewContext.save()
            self.dismiss()
        } catch {
            self.error = CreateHomeError(errorDescription: "Error", failureReason: "An unknown error occurred saving this Home", recoverySuggestion: "Try again")
            self.presentError = true
        }
    }
}

struct CreatePreview: PreviewProvider {
    
    static var previews: some View {
        CreateHomeView()
    }
}
