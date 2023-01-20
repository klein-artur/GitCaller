//
//  CommandRestore.swift
//
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public final class CommandRestore: Command, HasPathParameter, HasStagedParameter, HasMinusMinusParameter, HasPatchParameter {
    public override var command: String {
        "restore"
    }
}

extension Git {
    public var restore: CommandRestore {
        return CommandRestore(preceeding: self)
    }
}
