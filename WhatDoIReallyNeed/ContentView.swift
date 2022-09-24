//
//  ContentView.swift
//  WhatDoIReallyNeed
//
//  Created by Tom Knighton on 10/09/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedHome: Home?
    @StateObject var coordinator: Coordinator = Coordinator()
    @State private var hasInit: Bool = false
    
//    var body: some View {
//
//        Group {
//            if self.horizontalSize == .regular {
//                NavigationSplitView {
//                    MainPage(selectedHome: $selectedHome, hasInit: $hasInit)
//                } detail : {
//                    ZStack {
//                        if let id = self.selectedHome?.homeId {
//                            HomePage(homeId: id)
//                        } else {
//                            EmptyView()
//                        }
//                    }
//                }
//            } else {
//                ZStack {
//
//                    Button(action: { print("XXX: Called \(coordinator.navPath.count)")}) {
//                        Text("Test")
//                    }
//                }
//
//            }
//        }
//        .environmentObject(self.coordinator)
//        .onChange(of: self.selectedHome) { newValue in
//            print("XXX: Remove all")
//            self.coordinator.navPath.removeLast(self.coordinator.navPath.count)
//            if let newValue {
//                self.coordinator.navPath.append(newValue)
//                print("XXX: Pushed path \(newValue.homeName)")
//            }
//        }
//        .onChange(of: self.coordinator.navPath) { newValue in
//            print("XXX: \(newValue.count)")
//        }
//    }
    
    var body: some View {
        
        NavigationSplitView {
            MainPage(selectedHome: $selectedHome, hasInit: $hasInit)
        } detail: {
            ZStack {
                if let home = selectedHome {
                    NavigationStack {
                        HomePage(homeId: home.homeId)
                    }

                }
            }
            
        }

    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
