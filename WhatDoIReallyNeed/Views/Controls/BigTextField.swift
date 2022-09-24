//
//  BigTextField.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI
import Introspect

struct BigTextField: View {
    
    @Binding var text: String
    var amount: Binding<Int>?

    var prompt: String = ""
    var isSecure: Bool = false
    var maxCharacters: Int?
    
    init(text: Binding<String>, amount: Binding<Int>, prompt: String = "", isSecure: Bool = false, maxCharacters: Int? = nil) {
        self._text = text
        self.amount = amount
        self.prompt = prompt
        self.isSecure = isSecure
        self.maxCharacters = maxCharacters
    }
    
    init(text: Binding<String>, prompt: String = "", isSecure: Bool = false, maxCharacters: Int? = nil) {
        self._text = text
        self.prompt = prompt
        self.isSecure = isSecure
        self.maxCharacters = maxCharacters
        
        self.amount = nil
    }
    
    var body: some View {
        Group {
            HStack {
                if isSecure {
                    SecureField(prompt, text: $text)
                } else {
                    TextField(prompt, text: $text)
                }
                if let amount {
                    TextField("", value: amount, formatter: NumberFormatter())
                        .labelsHidden()
                        .frame(minWidth: 70, maxWidth: 70)
                        .keyboardType(.numberPad)
                    Stepper(value: amount) {
                        Text("\(amount.wrappedValue)")
                    }
                    .labelsHidden()
                    .fixedSize()
                    .padding(.leading, 4)
                    .introspectTextField { textField in
                        textField.adjustsFontSizeToFitWidth = true
                    }
                }
            }
            
        }
        .textFieldStyle(BigTextFieldStyle())
        .onReceive(self.text.publisher.collect()) { newVal in
            if let maxCharacters, newVal.count > maxCharacters {
                self.text = String(newVal.prefix(maxCharacters))
            }
        }
    }
}
struct BigTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) private var colourScheme

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.title3.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(16)
            .background(self.colourScheme == .dark ? Color.layer2 : Color(uiColor: UIColor.systemGray6))
            .cornerRadius(10)
    }
}
