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
            let pipe = Pipe()
            async let result: () = command.ignoreResult(inputPipe: pipe)
            
            try await self.handleLineStaging(
                pipe: pipe,
                number: number,
                lines: lines,
                staging: true
            )
            
            try await result
        } else {
            try await command.ignoreResult()
        }
        objectWillChange.send()
    }
    
    public func unstage(file path: String, hunk number: Int? = nil, lines: [Int]? = nil) async throws -> RestoreResult {
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
            
            try await self.handleLineStaging(
                pipe: pipe,
                number: number,
                lines: lines,
                staging: false
            )
            
            result = try await waitingResult
        } else {
            result = try await command.finalResult()
        }
        
        objectWillChange.send()
                
        return result
    }
    
    private func handleLineStaging(pipe: Pipe, number: Int, lines: [Int]?, staging: Bool) async throws {
        
        try await Task.sleep(for: .milliseconds(30))
        try pipe.putIn(content: "g")
        try await Task.sleep(for: .milliseconds(30))
        try pipe.putIn(content: "\(number + 1)")
        
        guard let lines = lines else {
            try await Task.sleep(for: .milliseconds(30))
            try pipe.putIn(content: "y")
            try await Task.sleep(for: .milliseconds(10))
            try pipe.putIn(content: "q")
            return
        }
        try await Task.sleep(for: .milliseconds(10))
        try pipe.putIn(content: "e")
        
        try await Task.sleep(for: .milliseconds(10))
        
        let gitPath = try await Git().revParse.pathFormat(.absolute).gitDir().runAsync()
        let filePath = "\(gitPath.trimmingCharacters(in: .whitespacesAndNewlines))/addp-hunk-edit.diff"
        
        let content = try String(contentsOfFile: filePath)
        try FileManager.default.removeItem(atPath: filePath)
        let newHunk = staging ? content.editHunkStage(lines: lines) : content.editHunkUnstage(lines: lines)
        try newHunk.write(toFile: filePath, atomically: false, encoding: .utf8)
        
        try await Task.sleep(for: .milliseconds(10))
        
        try pipe.putIn(content: "done")
        
        try await Task.sleep(for: .milliseconds(10))
        
        try pipe.putIn(content: "q")
    }
    
    public func commit(message: String) async throws {
        try await Git().commit.message(message).ignoreResult()
        objectWillChange.send()
    }
    
    
}
