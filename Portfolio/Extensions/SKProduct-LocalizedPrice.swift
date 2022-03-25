//
//  SKProduct-LocalizedPrice.swift
//  Portfolio
//
//  Created by Robyn Chau on 25/03/2022.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
