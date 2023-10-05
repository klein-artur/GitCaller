//
//  Parameter.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public protocol Parameter {
    var command: String { get }
    
    func getCommand(forString: Bool) -> String
}

public protocol ParametrableCommandSpec: CommandSpec {
    /// The parameters this command will hold
    var parameter: [Parameter] { get set }
    
    /// Initializer for parametrables.
    init(
        preceeding: (any CommandSpec)?,
        parameter: [Parameter]
    )
}

extension ParametrableCommandSpec {
    internal func withAddedParameter(_ param: Parameter) -> Self {
        var paramList = self.parameter
        paramList.append(param)
        
        return Self.init(preceeding: self.preceeding, parameter: paramList)
    }
    
    public mutating func addParameter(_ param: Parameter) {
        
        self.parameter.append(param)
    }
    
    public func copy() -> Self {
        return Self.init(
            preceeding: self.preceeding, parameter: self.parameter
        )
    }
}
