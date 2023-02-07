//
//  CommandTag.swift
//  
//
//  Created by Artur Hellmann on 07.02.23.
//

import Foundation

public final class CommandTag: Command, HasTagnameParameter, HasMessageParameter, HasCommitHashParameter, HasLowercaseDParameter, HasAnnotateParameter
{
    public override var command: String {
        "tag"
    }
}

extension Git {
    public var tag: CommandTag {
        return CommandTag(preceeding: self)
    }
}
