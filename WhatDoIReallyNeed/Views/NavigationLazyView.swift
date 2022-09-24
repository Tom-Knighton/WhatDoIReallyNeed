//
//  NavigationLazyView.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 11/09/2022.
//

import Foundation
import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
