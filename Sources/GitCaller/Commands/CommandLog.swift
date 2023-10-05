//
//  CommandLog.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

import Foundation

/// Git command for `git log`
public final class CommandLog: ParametrableCommandSpec,
                                HasCommitHashParameter,
                                HasBranchnameParameter,
                                HasNoColorParameter,
                                HasDecorateParameter,
                                HasPrettyParameter,
                                HasTopoOrderParameter,
                                HasAllParameter,
                                HasMinusMinusParameter,
                                HasPatchParameter
{
    public var command: String {
        "log"
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
    public var log: CommandLog {
        return CommandLog(preceeding: self)
    }
}
