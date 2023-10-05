//
//  CommandCheckout.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

import Foundation

public final class CommandCheckout: ParametrableCommandSpec, HasLowercaseBParameter, HasBranchnameParameter, HasTrackParameter, HasPathParameter, HasOursParameter, HasTheirsParameter
{
    public var command: String {
        "checkout"
    }
    
    public var parameter: [Parameter]
    
    public var preceeding: (any CommandSpec)?
    
    public init(
        preceeding: (any CommandSpec)?,
        parameter: [Parameter] = []
    ) {
        self.preceeding = preceeding
        self.parameter = parameter
    }
}

extension Git {
    public var checkout: CommandCheckout {
        return CommandCheckout(preceeding: self)
    }
}
