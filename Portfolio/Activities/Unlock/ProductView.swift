//
//  ProductView.swift
//  Portfolio
//
//  Created by Robyn Chau on 25/03/2022.
//

import StoreKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Project")
                    .font(.headline)
                    .padding(.top, 10)
                Text("You can add three projects for three, or pay \(product.localizedPrice) to add unlimited projects")
                Text("If you already bought the unlock on another device, please Restore Purchases.")

                Button("Buy: \(product.localizedPrice)", action: unlock)
                    .buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
                    .buttonStyle(PurchaseButton())
            }
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
}
