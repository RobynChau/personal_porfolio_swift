//
//  Award.swift
//  Portfolio
//
//  Created by Robyn Chau on 19/03/2022.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String {name}
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    static var allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
    static var example = allAwards[0]
}
