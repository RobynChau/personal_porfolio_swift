//
//  ProjectHeaderView.swift
//  Portfolio
//
//  Created by Robyn Chau on 18/03/2022.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                ProgressView(value: project.completionAmount)
                    .accentColor(Color(project.projectColor))
            }

            Spacer()

            NavigationLink {
                EditProjectsView(project: project)
            } label: {
                Label("\(project.projectTitle)", systemImage: "square.and.pencil")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
