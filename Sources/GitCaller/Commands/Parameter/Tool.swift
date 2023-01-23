//
//  Tool.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Makes a command able to use the `--tool=<toolname>` parameter.
public protocol HasToolParameter: Parametrable {
    func tool(_ toolName: String) -> Self
}

internal class Tool: Parameter {
    var command: String
    
    init(_ toolName: String) {
        self.command = "--tool=\(toolName)"
    }
}

extension HasToolParameter {
    public func tool(_ toolName: String) -> Self {
        return self.withAddedParameter(Tool(toolName))
    }
}
