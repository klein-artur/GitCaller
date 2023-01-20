//
//  CommandDiff.swift
//  
//
//  Created by Artur Hellmann on 20.01.23.
//

import Foundation

public final class CommandDiff: Command, HasPathParameter, HasStagedParameter, HasMinusMinusParameter {
    public override var command: String {
        "diff"
    }
}

extension Git {
    public var diff: CommandDiff {
        return CommandDiff(preceeding: self)
    }
}
