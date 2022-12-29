//
//  CommandStatus.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public final class CommandStatus: Command
{
    public override var command: String {
        "status"
    }
}

extension Git {
    public var status: CommandStatus {
        return CommandStatus(preceeding: self)
    }
}
