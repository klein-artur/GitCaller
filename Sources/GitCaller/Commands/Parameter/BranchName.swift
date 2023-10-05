//
//  BranchName.swift
//  
//
//  Created by Artur Hellmann on 03.01.23.
//

import Foundation

/// Makes a command able to add a branch name parameter.
public protocol HasBranchnameParameter: ParametrableCommandSpec{
    func branchName(_ branchName: String) -> Self
}

internal class BranchName: Parameter {
    var command: String
    
    init(_ branchName: String) {
        self.command = branchName
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasBranchnameParameter {
    public func branchName(_ branchName: String) -> Self {
        return self.withAddedParameter(BranchName(branchName))
    }
}
