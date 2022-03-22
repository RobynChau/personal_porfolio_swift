//
//  ExtensionTests.swift
//  PortfolioTests
//
//  Created by Robyn Chau on 21/03/2022.
//

import XCTest
import SwiftUI
@testable import Portfolio

class ExtensionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
    }
    func testSequenceKeyPathSortingComparable() {
        let names = ["Ron", "Hermione", "Harry", "Draco"]
        let sortedNames = names.sorted(by: \.self) { $0 > $1 }
        XCTAssertEqual(sortedNames, ["Ron", "Hermione", "Harry", "Draco"], "Reverse sorting should yield backwards.")
    }
    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to an non-empty array")
    }
    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data,
                       "The rain in Spain falls mainly on the Spaniards.",
                       "The string must match the content of DecodableString.json."
        )
    }
    func testBindingOnChange() {
        // Given that
        var onChangeFunctionRun = false
        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }
        var storedValue = ""
        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )
        let changedBinding = binding.onChange(exampleFunctionToCall)
        // When
        changedBinding.wrappedValue = "Test"
        // Then
        XCTAssertTrue(onChangeFunctionRun, "The onChange() function must be run when the binding s changed.")
    }
}
