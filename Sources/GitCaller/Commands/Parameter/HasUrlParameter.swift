//
//  HasUrlParameter.swift
//  
//
//  Created by Artur Hellmann on 07.02.23.
//

import Foundation

/// Makes a command able to add an url parameter.
public protocol HasUrlParameter: ParametrableCommandSpec {
    func url(_ url: String) -> Self
}

internal class Url: Parameter {
    var command: String
    
    init(_ url: String) {
        self.command = url
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasUrlParameter {
    public func url(_ url: String) -> Self {
        return self.withAddedParameter(Url(url))
    }
}
