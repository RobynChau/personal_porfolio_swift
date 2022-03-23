//
//  ItemListView.swift
//  Portfolio
//
//  Created by Robyn Chau on 20/03/2022.
//

import SwiftUI

class ArraySliceItems: ObservableObject {
    @Published var items: ArraySlice<Item>

    init(items: ArraySlice<Item>) {
        self.items = items
    }
}

struct ItemListView: View {
    let title: LocalizedStringKey
    @ObservedObject var items: ArraySliceItems

    var body: some View {
        if items.items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            ForEach(items.items) { item in
                NavigationLink {
                    EditItemView(item: item)
                } label: {
                    itemDetail(for: item)
                }
            }
        }
    }

    func itemDetail (for item: Item) -> some View {
        HStack(spacing: 20) {
            Circle()
                .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                .frame(width: 44, height: 44)
            VStack(alignment: .leading) {
                Text(item.itemTitle)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if item.itemDetail.isEmpty == false {
                    Text(item.itemDetail)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
