//
//  TagName.swift
//
//
//  Created by Artur Hellmann on 03.01.23.
//

import Foundation

/// Makes a command able to add a tag name parameter.
public protocol HasTagnameParameter: ParametrableCommandSpec{
    func tagName(_ tagName: String) -> Self
}

internal class TagName: Parameter {
    var command: String
    
    init(_ tagName: String) {
        self.command = tagName
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasTagnameParameter {
    public func tagName(_ tagName: String) -> Self {
        return self.withAddedParameter(TagName(tagName))
    }
}
