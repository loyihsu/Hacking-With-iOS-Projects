//
//  Person.swift
//  Project 12v2
//
//  Created by Yu-Sung Loyi Hsu on 2022/2/24.
//

import Foundation

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
