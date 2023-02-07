//
//  Tags.swift
//  
//
//  Created by Artur Hellmann on 07.02.23.
//

import Foundation

/// Makes a command able to use the `--tags` parameter.
public protocol HasTagsParameter: Parametrable {
    func tags() -> Self
}

internal class Tags: Parameter {
    var command: String = "--tags"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasTagsParameter {
    public func tags() -> Self {
        return self.withAddedParameter(Tags())
    }
}
