//
//  CommandAdd.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public final class CommandAdd: Command,
                        Allable,
                        Pathable
{
    public override var command: String {
        "add"
    }
}

extension Git {
    public var add: CommandAdd {
        return CommandAdd(preceeding: self)
    }
}
