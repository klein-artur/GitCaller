//
//  Git.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public class Git: CommandSpec {
    public let command: String
    
    public init(raw: String? = nil) {
        if let raw = raw {
            self.command = "git \(raw)"
        } else {
            self.command = "git"
        }
    }
    
    public var preceeding: (any CommandSpec)? = nil
}

