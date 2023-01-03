//
//  CommitHash.swift
//  
//
//  Created by Artur Hellmann on 03.01.23.
//

import Foundation

/// Makes a command able to add a commit hash parameter.
public protocol CommitHashable: Parametrable {
    func commitHash(_ hash: String) -> Self
}

internal class CommitHash: Parameter {
    var command: String
    
    init(_ hash: String) {
        self.command = hash
    }
}

extension CommitHashable {
    public func commitHash(_ hash: String) -> Self {
        return self.withAddedParameter(CommitHash(hash))
    }
}
