//
//  EmojiPickerView.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI

struct IconPickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var systemIcons: [String] = ["house", "building", "building.2", "pencil", "book", "book.closed", "books.vertical", "sun.max", "cloud", "moon.stars", "tray", "menucard", "newspaper", "rosette", "ticket.fill", "link", "tag", "dice", "paintbrush.pointed", "scroll", "cup.and.saucer", "takeoutbag.and.cup.and.straw", "fork.knife", "lightbulb", "person", "person.2", "person.3", "eyes", "face.smiling", "hand.raised", "hands.sparkles"]
    let grid: [GridItem] = [GridItem(.adaptive(minimum: 50))]
    
    @Binding var selectedIcon: String?
    @Binding var selectedEmoji: String?
    
    @FocusState private var focused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 16)
                    Text("Select an icon:")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(height: 8)
                    LazyVGrid(columns: grid) {
                        ForEach(self.systemIcons, id: \.self) { icon in
                            ZStack {
                                Circle()
                                    .fill(Color(uiColor: UIColor.systemGray5))
                                    .frame(width: 45, height: 45)
                                    .overlay(
                                        Text(Image(systemName: icon))
                                    )
                                    .padding(10)
                                if let selectedIcon, selectedIcon == icon {
                                    Circle()
                                        .stroke(.blue, lineWidth: 5)
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .onTapGesture {
                                self.selectedIcon = icon
                                self.selectedEmoji = nil
                                self.focused = false
                                self.dismiss()
                            }
                        }
                    }
                    Spacer().frame(height: 8)

                    Text("Or, pick an emoji:")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ZStack {
                        Circle()
                            .fill(Color(uiColor: UIColor.systemGray5))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(self.selectedEmoji ?? "😀")
                            )
                            .padding(10)
                        
                        EmojiTextField(text: self.$selectedEmoji)
                            .focused($focused)
                            .opacity(0)
                        
                        if let _ = self.selectedEmoji {
                            Circle()
                                .stroke(.blue, lineWidth: 5)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .onTapGesture {
                        self.focused = true
                    }
                    .onChange(of: self.selectedEmoji) { newValue in
                        if let newValue, let last = newValue.last, newValue.allSatisfy({ $0.isEmoji }) {
                            self.focused = false
                            self.selectedEmoji = String(describing: last)
                            self.selectedIcon = nil
                            self.dismiss()
                        }
                        
                        else {
                            self.selectedEmoji = nil
                        }
                    }
                    
                }
                .padding(.horizontal, 16)
            }
        }
        
    }
}
