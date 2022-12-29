//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--initial-branch=<branch_name>` parameter.
protocol InitialBranchNamable: Parametrable {
    func initialBranch(name: String) -> Self
}

internal class InitialBranchName: Parameter {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var command: String {
        "--initial-branch=\(name)"
    }
}

extension InitialBranchNamable {
    func initialBranch(name: String) -> Self {
        return self.withAddedParameter(InitialBranchName(name: name))
    }
}
