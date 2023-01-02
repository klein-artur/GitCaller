//
//  CommandClone.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

import Foundation

/// Git command for `git clone`.
public final class CommandClone: Command {
    let url: String
    
    init(preceeding: CommandSpec?, parameter: [Parameter] = [], url: String) {
        self.url = url
        super.init(preceeding: preceeding)
    }
    
    required init(preceeding: CommandSpec?, parameter: [Parameter] = []) {
        fatalError("init(preceeding:parameter:) has not been implemented")
    }
    
    public override func copy() -> Self {
        return Self.init(
            preceeding: preceeding,
            parameter: parameter,
            url: url
        )
    }
    
    public override var command: String {
        "clone \(url)"
    }
}

extension Git {
    public func clone(url: String) -> CommandClone {
        return CommandClone(preceeding: self, url: url)
    }
}
