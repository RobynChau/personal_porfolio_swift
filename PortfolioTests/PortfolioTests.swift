//
//  PortfolioTests.swift
//  PortfolioTests
//
//  Created by Robyn Chau on 21/03/2022.
//
import CoreData
import XCTest
@testable import Portfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
