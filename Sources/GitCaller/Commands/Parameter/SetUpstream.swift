//
//  SetUpstream.swift
//
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

/// Makes a command able to use the `--set-upstream` parameter.
public protocol HasSetUpstreamParameter: Parametrable {
    func setUpstream() -> Self
}

internal class SetUpstream: Parameter {
    var command: String = "--set-upstream"
}

extension HasSetUpstreamParameter {
    public func setUpstream() -> Self {
        return self.withAddedParameter(SetUpstream())
    }
}
