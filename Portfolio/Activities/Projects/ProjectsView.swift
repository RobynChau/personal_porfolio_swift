//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Robyn Chau on 17/03/2022.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    var projectList: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }
                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
        Menu {
            Button("Optimized") {viewModel.sortOrder = .optimized}
            Button("Creation Date") {viewModel.sortOrder = .creationDate}
            Button("Title") {viewModel.sortOrder = .title}
        } label: {
            Label("Sort Order", systemImage: "arrow.up.arrow.down")
        }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectList
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
        .onOpenURL(perform: viewModel.showClosedProjects ? openURL : emptyFunc(_:))
    }

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)

        _viewModel = StateObject(wrappedValue: viewModel)
    }

    func openURL(_ url: URL) {
        if url == URL(string: "portfolio://newProject") {
            viewModel.addProject()
        }
    }

    func emptyFunc (_ url: URL) {
        // This function was created due to a bug
        // It happens due to both Open and Closed Projects View can create a new Project
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
