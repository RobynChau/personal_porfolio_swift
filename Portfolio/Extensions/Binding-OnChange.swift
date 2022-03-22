//
//  Binding-OnChange.swift
//  Portfolio
//
//  Created by Robyn Chau on 18/03/2022.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue},
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
