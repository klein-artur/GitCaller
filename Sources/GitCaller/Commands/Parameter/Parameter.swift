//
//  Parameter.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public protocol Parameter {
    var command: String { get }
}

public protocol Copyable {
    /// Copies the current element with a new parameter
    func copy() -> Self
}

public protocol Parametrable: CommandSpec, Copyable {
    /// The parameters this command will hold
    var parameter: [Parameter] { get set }
    
    /// Adds the parameter to the parameter list
    mutating func addParameter(_ param: Parameter)
}

extension Parametrable {
    internal func withAddedParameter(_ param: Parameter) -> Self {
        var result = copy()
        result.addParameter(param)
        return result
    }
    
    public mutating func addParameter(_ param: Parameter) {
        self.parameter.append(param)
    }
}
