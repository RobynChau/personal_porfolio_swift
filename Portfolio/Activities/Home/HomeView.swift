//
//  HomeView.swift
//  Portfolio
//
//  Created by Robyn Chau on 17/03/2022.
//
import CoreData
import CoreSpotlight
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"

    @StateObject var viewModel: ViewModel

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                if let item = viewModel.selectedItem {
                    NavigationLink(
                        destination: EditItemView(item: item),
                        tag: item,
                        selection: $viewModel.selectedItem,
                        label: EmptyView.init
                    )
                    .id(item)
                }
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects) {project in
                                ProjectSummaryView(project: project)
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    VStack(alignment: .leading) {
                        ItemListView(title: "Up next", items: ArraySliceItems(items: viewModel.upNext))
                        ItemListView(title: "More to explore", items: ArraySliceItems(items: viewModel.moreToExplore))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data") {
                    viewModel.addSampleData()
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
        }
    }

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectItem(with: uniqueIdentifier)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
