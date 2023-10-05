//
//  Decorate.swift
//  
//
//  Created by Artur Hellmann on 06.01.23.
//

import Foundation

public enum DecorateValue: String {
    case short = "short"
    case full = "full"
    case auto = "auto"
}

/// Makes a command able to use the `--decorate=<type>` parameter.
public protocol HasDecorateParameter: ParametrableCommandSpec{
    func decorate(_ value: DecorateValue) -> Self
}

internal class Decorate: Parameter {
    let value: DecorateValue
    
    init(value: DecorateValue) {
        self.value = value
    }
    
    var command: String {
        "--decorate=\(value.rawValue)"
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasDecorateParameter {
    public func decorate(_ value: DecorateValue = .auto) -> Self {
        return self.withAddedParameter(Decorate(value: value))
    }
}
