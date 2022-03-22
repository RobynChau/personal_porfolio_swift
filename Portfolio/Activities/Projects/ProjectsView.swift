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
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    var projectList: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: project)
                    }
                    if showClosedProjects == false {
                        Button {
                            addItem(to: project)
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
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                Button {
                    addProject()
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
        Button {
            showingSortOrder = true
        } label: {
            Label("Sort Order", systemImage: "arrow.up.arrow.down")
        }
        }
    }
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectList
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) {sortOrder = .optimized},
                    .default(Text("Creation Date")) {sortOrder = .creationDate},
                    .default(Text("Title")) {sortOrder = .title},
                    .cancel()
                ])
            }
            SelectSomethingView()
        }
    }
    func addProject() {
        withAnimation {
            let project = Project(context: moc)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: moc)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        dataController.save()
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
