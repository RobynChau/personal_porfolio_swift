//
//  PlatformAdjustment.swift
//  PortfolioMac
//
//  Created by Robyn Chau on 28/03/2022.
//

import SwiftUI

typealias InsetGroupedListStyle = SidebarListStyle
typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActive = NSApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0, content: content)
    }
}
