//
//  PathFormat.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

public enum PathFormatValue: String {
    case absolute = "absolute"
    case relative = "relative"
}

/// Makes a command able to use the `--path-format=<absolute|relative>` parameter.
public protocol HasPathFormatParameter: ParametrableCommandSpec{
    func pathFormat(_ value: PathFormatValue) -> Self
}

internal class PathFormat: Parameter {
    let value: PathFormatValue
    
    init(value: PathFormatValue) {
        self.value = value
    }
    
    var command: String {
        "--path-format=\(value.rawValue)"
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasPathFormatParameter {
    public func pathFormat(_ value: PathFormatValue = .absolute) -> Self {
        return self.withAddedParameter(PathFormat(value: value))
    }
}
