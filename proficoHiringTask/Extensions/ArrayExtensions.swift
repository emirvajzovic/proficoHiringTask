//
//  Array+Extensions.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//


extension Array where Element == String {
    var commaSeparated: String {
        return joined(separator: ", ")
    }
}