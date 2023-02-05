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
            .conditionalLet(path) { command, path in
                command.path(path)
            }
            .conditionalLet(rightPath) { command, path in
                command.path(path)
            }
            .finalResult()
    }
    
    public func stage(file path: String?, hunk number: Int? = nil, lines: [Int]? = nil) async throws {
        let command = Git()
            .add
            .conditional(path == nil, alternator: { command in
                command.all()
            })
            .conditionalLet(path, alternator: { command, path in
                command
                    .conditional(number != nil, alternator: { command in
                        command.patch()
                    })
                    .minusMinus()
                    .path(path)
            })
                
            if let number = number {
                if let lines = lines {
                    
                } else {
                    let pipe = Pipe()
                    async let result: () = command.ignoreResult(inputPipe: pipe)
                    try pipe.putIn(content: "g\n\(number + 1)\ny\nd")
                    try await result
                }
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
            let pipe = Pipe()
            async let waitingResult = command.finalResult(inputPipe: pipe)
            try pipe.putIn(content: "g\n\(number + 1)\ny\nd")
            result = try await waitingResult
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
