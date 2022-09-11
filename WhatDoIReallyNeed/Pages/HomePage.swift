//
//  HomePage.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//

import Foundation
import SwiftUI

struct HomePage: View {
    
    var home: Home
    
    var body: some View {
        ZStack {
            Text("Hello World \(home.homeName)")
        }
    }
}
