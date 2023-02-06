//
//  HunkEditor.swift
//  
//
//  Created by Artur Hellmann on 05.02.23.
//

import Foundation

public extension String {
    func editHunkStage(lines: [Int]) -> String {
        return editHunk(lines: lines, stage: true)
    }
    
    func editHunkUnstage(lines: [Int]) -> String {
        return editHunk(lines: lines, stage: false)
    }
    
    private func editHunk(lines: [Int], stage: Bool) -> String {
        let selfLines = self.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
        
        var result = [String]()
        
        var lineNumber = 0
        var inHunk = false
        
        for string in selfLines {
            guard let firstChar = string.first else {
                result.append("")
                if inHunk {
                    lineNumber += 1
                }
                continue
            }
            switch firstChar {
            case "#":
                result.append(string)
            case "@":
                result.append(string)
                inHunk = true
            case " ":
                result.append(string)
                if inHunk {
                    lineNumber += 1
                }
            case "-":
                if lines.contains(lineNumber) {
                    result.append(string)
                } else {
                    if stage {
                        result.append(" \(string.dropFirst())")
                    }
                }
                if inHunk {
                    lineNumber += 1
                }
            case "+":
                if lines.contains(lineNumber) {
                    result.append(string)
                } else {
                    if !stage {
                        result.append(" \(string.dropFirst())")
                    }
                }
                if inHunk {
                    lineNumber += 1
                }
            default: break
            }
        }
        
        return result.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
