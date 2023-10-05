//
//  CommandClone.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

import Foundation

/// Git command for `git clone`.
public final class CommandClone: ParametrableCommandSpec, HasUrlParameter {
    public var command: String {
        "clone"
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
    public func clone(url: String) -> CommandClone {
        return CommandClone(preceeding: self)
            .url(url)
    }
}
