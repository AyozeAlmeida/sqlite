//
//  Product.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 5/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//


import Foundation

class Baliza: CustomStringConvertible {
    let id: Int64?
    var name: String
    var imageName: String
    
    init(id: Int64, name: String, imageName: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
    }
    var description: String {
        return "id = \(self.id ?? 0), name = \(self.name), imageName = \(self.imageName)"
    }
}
