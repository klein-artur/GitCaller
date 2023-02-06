//
//  Pretty.swift
//  
//
//  Created by Artur Hellmann on 06.01.23.
//

import Foundation

public enum PrettyFormat {
    case oneline
    case short
    case medium
    case full
    case fuller
    case raw
    case format(String)
    
    fileprivate func value(forString: Bool) -> String {
        switch self {
        case .oneline: return "oneline"
        case .short: return "short"
        case .medium: return "medium"
        case .full: return "full"
        case .fuller: return "fuller"
        case .raw: return "raw"
        case let .format(formatting):
            if forString {
                return "format:\"\(formatting)\""
            } else {
                return "format:\(formatting)"
            }
        }
    }
}

/// Makes a command able to use the `--pretty=<formatting>` parameter.
public protocol HasPrettyParameter: Parametrable {
    func pretty(_ value: PrettyFormat) -> Self
}

internal class Pretty: Parameter {
    let value: PrettyFormat
    
    init(value: PrettyFormat) {
        self.value = value
    }
    
    var command: String {
        getCommand(forString: false)
    }
    
    func getCommand(forString: Bool) -> String {
        return "--pretty=\(value.value(forString: forString))"
    }
}

extension HasPrettyParameter {
    public func pretty(_ value: PrettyFormat) -> Self {
        return self.withAddedParameter(Pretty(value: value))
    }
}
