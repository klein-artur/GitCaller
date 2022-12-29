//
//  Git.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public class Git: CommandSpec {
    public init() {}
    
    public var preceeding: CommandSpec? = nil
    public var command: String = "git"
}
