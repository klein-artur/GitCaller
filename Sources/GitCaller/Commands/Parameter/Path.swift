//
//  Path.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to add a path parameter.
public protocol HasPathParameter: Parametrable {
    func path(_ path: String) -> Self
}

internal class Path: Parameter {
    var command: String
    
    init(_ path: String) {
        let finalPath = path.replacingOccurrences(of: " ", with: "\\ ")
        self.command = finalPath
    }
}

extension HasPathParameter {
    public func path(_ path: String) -> Self {
        return self.withAddedParameter(Path(path))
    }
}
