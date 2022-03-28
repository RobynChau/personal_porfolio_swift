//
//  DataController-StoreKit.swift
//  Portfolio
//
//  Created by Robyn Chau on 28/03/2022.
//

import Foundation
import StoreKit

extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }

        // if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // SKStoreReviewController.requestReview(in: scene)
        // }

        /*
        // Although this code is designed to work on both the iPhones and the iPads, it does not work on iOS 15.4.
            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }

            if let windowScene = scene as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        */
    }
}
