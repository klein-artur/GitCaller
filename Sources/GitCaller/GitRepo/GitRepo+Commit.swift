//
//  File.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

extension GitRepo {
    
    public func diff(path: String?, staged: Bool = false, rightPath: String? = nil) async throws -> DiffResult {
        try await Git().diff
            .conditional(staged) { command in
                command.staged()
            }
            .ifLet(path) { command, path in
                command.path(path)
            }
            .ifLet(rightPath) { command, path in
                command.path(path)
            }
            .finalResult()
    }
    
    public func stage(file path: String?, hunk number: Int? = nil) async throws {
        let command = Git()
            .add
            .conditional(path == nil, alternator: { command in
                command.all()
            })
            .ifLet(path, alternator: { command, path in
                command
                    .conditional(number != nil, alternator: { command in
                        command.patch()
                    })
                    .minusMinus()
                    .path(path)
            })
                
                if let number = number {
                    let input = "g\n\(number + 1)\ny\nd\n"
                
                try await command.ignoreResult(predefinedInput: input)
            } else {
                try await command.ignoreResult()
            }
        objectWillChange.send()
    }
    
    public func unstage(file path: String, hunk number: Int? = nil) async throws -> RestoreResult {
        let command = Git()
            .restore
            .staged()
            .conditional(number != nil, alternator: { command in
                command.patch()
            })
            .minusMinus()
            .path(path)
                
        let result: RestoreResult
                
        if let number = number {
            let input = "g\n\(number + 1)\ny\nd\n"
            
            result = try await command.finalResult(predefinedInput: input)
        } else {
            result = try await command.finalResult()
        }
        
        objectWillChange.send()
                
        return result
    }
    
    public func commit(message: String) async throws {
        try await Git().commit.message(message).ignoreResult()
        objectWillChange.send()
    }
    
    
}
