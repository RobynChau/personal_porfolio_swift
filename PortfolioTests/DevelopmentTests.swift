//
//  DevelopmentTests.swift
//  PortfolioTests
//
//  Created by Robyn Chau on 21/03/2022.
//

import CoreData
import XCTest
@testable import Portfolio

class DevelopmentTests: BaseTestCase {
    func testSampleDateCreationWorks() throws {
        try dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample sample items.")
    }
    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0,
                       "There should not be any projects after deleting all.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0,
                       "There should not be any items after deleting all.")
    }
    func testExampleProjectClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should be closed.")
    }
    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "The example item should be high priority.")
    }
}
