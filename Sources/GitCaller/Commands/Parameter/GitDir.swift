//
//  GitDir.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Makes a command able to use the `--git-dir` parameter.
public protocol HasGitDirParameter: Parametrable {
    func gitDir() -> Self
}

internal class GitDir: Parameter {
    var command: String = "--git-dir"
}

extension HasGitDirParameter {
    public func gitDir() -> Self {
        return self.withAddedParameter(GitDir())
    }
}
