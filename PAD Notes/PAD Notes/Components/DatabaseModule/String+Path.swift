//
//  String+Path.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 23/12/2023.
//

import Foundation

extension String {
    //
    static func makePath(child: String, parentNodes: String...) throws -> String {
        return try makePath(child: child, parentNodes: parentNodes)
    }
    
    static func makePath(child: String, parentNodes: [String]) throws -> String {
        return try makePath(nodes: (parentNodes + [child]))
    }
    
    //
    static func makePath(nodes: String...) throws -> String {
        return try makePath(nodes: nodes)
    }
    
    static func makePath(nodes: [String]) throws -> String {
        return try nodes.map { child -> String in
            let trimmed = child.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard trimmed != "" && !trimmed.contains("//") else {
                throw RealtimeDatabaseFirebaseModuleError.invalidPath
            }
            return trimmed
            }.joined(separator: "/")
    }
}
