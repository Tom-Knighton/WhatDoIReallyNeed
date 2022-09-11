//
//  BigTextField.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import Foundation
import SwiftUI

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
