//
//  GitDir.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Makes a command able to use the `--git-dir` parameter.
public protocol HasGitDirParameter: ParametrableCommandSpec{
    func gitDir() -> Self
}

internal class GitDir: Parameter {
    var command: String = "--git-dir"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasGitDirParameter {
    public func gitDir() -> Self {
        return self.withAddedParameter(GitDir())
    }
}
