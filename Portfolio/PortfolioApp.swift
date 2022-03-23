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
                .onReceive(
                    // Automatically save when we detect that we are no longer
                    // the foreground app. Use this rather than the scence phase
                    // API so we can port to macOS, where scence phase won't detect
                    // our app losing focus as of macOS 11.1.
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
        }
    }
    func save(_ note: Notification) {
        dataController.save()
    }
}
