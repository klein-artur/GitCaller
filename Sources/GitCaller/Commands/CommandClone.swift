//
//  CommandClone.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

import Foundation

/// Git command for `git clone`.
public final class CommandClone: Command, HasUrlParameter {
    public override var command: String {
        "clone"
    }
}

extension Git {
    public func clone(url: String) -> CommandClone {
        return CommandClone(preceeding: self)
            .url(url)
    }
}
