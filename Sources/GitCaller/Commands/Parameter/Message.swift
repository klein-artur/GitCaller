//
//  Message.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--message=<msg>` parameter.
public protocol HasMessageParameter: ParametrableCommandSpec{
    func message(_ msg: String) -> Self
}

internal class Message: Parameter {
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    var command: String {
        getCommand(forString: false)
    }
    
    func getCommand(forString: Bool) -> String {
        if forString {
            return "--message=\"\(message)\""
        } else {
            return "--message=\(message)"
        }
    }
}

extension HasMessageParameter {
    public func message(_ msg: String) -> Self {
        return self.withAddedParameter(Message(message: msg))
    }
}
