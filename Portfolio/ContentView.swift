//
//  ContentView.swift
//  Portfolio
//
//  Created by Robyn Chau on 17/03/2022.
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    private let newProjectActivity = "com.RobynChau.Portfolio.newProject"

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ProjectsView(dataController: dataController, showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            ProjectsView(dataController: dataController, showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onContinueUserActivity(newProjectActivity, perform: createProject)
        // This will 
        .userActivity(newProjectActivity) { activity in
            activity.title = "New Project"

            #if os(iOS) || os(watchOS)
            activity.isEligibleForPrediction = true
            #endif
        }
        .onOpenURL(perform: openURL)
    }

    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }

    func openURL(_ url: URL) {
        if url == URL(string: "portfolio://newProject") {
            selectedView = ProjectsView.openTag
        } else if url == URL(string: "portfolio://viewAwards") {
            selectedView = AwardsView.tag
        }

    }

    func createProject(_ userActivity: NSUserActivity) {
        selectedView = ProjectsView.openTag
        _ = dataController.addProject()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
