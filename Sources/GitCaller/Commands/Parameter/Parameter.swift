//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

protocol Parameter {
    var command: String { get }
}

protocol Copyable {
    /// Copies the current element with a new parameter
    func copy() -> Self
}

protocol Parametrable: CommandSpec, Copyable {
    /// The parameters this command will hold
    var parameter: [Parameter] { get set }
    
    /// Adds the parameter to the parameter list
    mutating func addParameter(_ param: Parameter)
}

extension Parametrable {
    func withAddedParameter(_ param: Parameter) -> Self {
        var result = copy()
        result.addParameter(param)
        return result
    }
    
    mutating func addParameter(_ param: Parameter) {
        self.parameter.append(param)
    }
}
