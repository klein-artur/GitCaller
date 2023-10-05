//
//  RemoteName.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

/// Makes a command able to add a remote name parameter.
public protocol HasRemoteNameParameter: ParametrableCommandSpec{
    func remoteName(_ remoteName: String) -> Self
}

internal class RemoteName: Parameter {
    var command: String
    
    init(_ remoteName: String) {
        self.command = remoteName
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasRemoteNameParameter {
    public func remoteName(_ remoteName: String) -> Self {
        return self.withAddedParameter(RemoteName(remoteName))
    }
}
