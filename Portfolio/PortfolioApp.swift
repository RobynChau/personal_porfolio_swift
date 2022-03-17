//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Robyn Chau on 17/03/2022.
//

import SwiftUI

@main
struct PortfolioApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
