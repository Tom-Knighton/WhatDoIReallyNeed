//
//  BigTextField.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI

struct BigTextField: View {
    
    @Binding var text: String

    var prompt: String = ""
    var isSecure: Bool = false
    var maxCharacters: Int?
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(prompt, text: $text)
            } else {
                TextField(prompt, text: $text)
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
        
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.title3.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(16)
            .background(Color(uiColor: UIColor.systemGray6))
            .cornerRadius(10)
    }
}
