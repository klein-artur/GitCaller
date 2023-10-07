//
//  GitRepo+Submodule.swift
//
//
//  Created by Artur Hellmann on 07.10.23.
//

import Foundation

extension GitRepo {
    public var listOfSubmodules: SubmoduleResult {
        get async throws {
            try await Git()
                .submodule()
                .finalResult()
        }
    }
}
