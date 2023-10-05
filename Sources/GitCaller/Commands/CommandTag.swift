//
//  CommandTag.swift
//  
//
//  Created by Artur Hellmann on 07.02.23.
//

import Foundation

public final class CommandTag: ParametrableCommandSpec, HasTagnameParameter, HasMessageParameter, HasCommitHashParameter, HasLowercaseDParameter, HasAnnotateParameter
{
    public var command: String {
        "tag"
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
    public var tag: CommandTag {
        return CommandTag(preceeding: self)
    }
}
