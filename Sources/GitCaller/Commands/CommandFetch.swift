//
//  CommandFetch.swift
//  
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

public final class CommandFetch: Command, HasAllParameter {
    public override var command: String {
        "fetch"
    }
}

extension Git {
    public var fetch: CommandFetch {
        return CommandFetch(preceeding: self)
    }
}
