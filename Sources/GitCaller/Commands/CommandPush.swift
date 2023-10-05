//
//  CommandPush.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

/// Git command for `git push`
public final class CommandPush: ParametrableCommandSpec, HasForceParameter, HasSetUpstreamParameter, HasBranchnameParameter, HasRemoteNameParameter, HasTagsParameter
{
    public var command: String {
        "push"
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
    public var push: CommandPush {
        return CommandPush(preceeding: self)
    }
}
