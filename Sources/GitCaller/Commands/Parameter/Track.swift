//
//  Track.swift
//  
//
//  Created by Artur Hellmann on 10.01.23.
//

import Foundation

/// Makes a command able to use the `--track` parameter.
public protocol HasTrackParameter: ParametrableCommandSpec{
    func track() -> Self
}

internal class Track: Parameter {
    var command: String = "--track"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasTrackParameter {
    public func track() -> Self {
        return self.withAddedParameter(Track())
    }
}
