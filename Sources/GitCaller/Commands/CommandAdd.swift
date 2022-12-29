//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

final class CommandAdd: Command,
                        Allable,
                        Pathable
{
    override var command: String {
        "add"
    }
}

extension Git {
    var add: CommandAdd {
        return CommandAdd(preceeding: self)
    }
}
