//
//  CommandLog.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

import Foundation

public final class CommandLog: Command
{
    public override var command: String {
        "log"
    }
}

extension Git {
    public var log: CommandLog {
        return CommandLog(preceeding: self)
    }
}
