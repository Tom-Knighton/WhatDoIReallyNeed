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
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var selectedHome: Home?
    @State private var path: NavigationPath = NavigationPath()
    @State private var hasInit: Bool = false

    var body: some View {
        
        Group {
            if self.horizontalSize == .regular {
                NavigationSplitView {
                    MainPage(selectedHome: $selectedHome, hasInit: $hasInit)
                } detail : {
                    ZStack {
                        if let id = self.selectedHome?.homeId {
                            HomePage(homeId: id)
                        } else {
                            EmptyView()
                        }
                    }
                }
            } else {
                NavigationStack(path: $path) {
                    MainPage(selectedHome: $selectedHome, hasInit: $hasInit)
                        .navigationTitle("Homes")
                        .navigationDestination(for: Home.self) { home in
                            HomePage(homeId: home.homeId)
                        }
                }
            }
        }
        .onChange(of: self.selectedHome) { newValue in
            self.path.removeLast(self.path.count)
            print("XXX: Remove all")
            if let newValue {
                self.path.append(newValue)
                print("XXX: Pushed path \(newValue.homeName)")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
