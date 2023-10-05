//
//  TopoOrder.swift
//  
//
//  Created by Artur Hellmann on 23.01.23.
//

import Foundation

/// Makes a command able to use the `--topo-order` parameter.
public protocol HasTopoOrderParameter: ParametrableCommandSpec{
    func topoOrder() -> Self
}

internal class TopoOrder: Parameter {
    var command: String = "--topo-order"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasTopoOrderParameter {
    public func topoOrder() -> Self {
        return self.withAddedParameter(TopoOrder())
    }
}
