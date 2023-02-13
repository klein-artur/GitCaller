//
//  Commit.swift
//  
//
//  Created by Artur Hellmann on 03.01.23.
//

import Foundation

public class Commit: HasHash {
    public var objectHash: String
    public var shortHash: String
    public var subject: String
    public var message: String
    public var author: Person
    public var authorDateString: String
    public var committer: Person
    public var committerDateString: String
    public var branches: [String]
    public var tags: [String]
    public var parents: [String]
    public var diff: String
    
    public init(
        objectHash: String,
        shortHash: String,
        subject: String,
        message: String,
        author: Person,
        authorDateString: String,
        committer: Person,
        committerDateString: String,
        branches: [String],
        tags: [String],
        parents: [String],
        diff: String
    ) {
        self.objectHash = objectHash
        self.shortHash = shortHash
        self.subject = subject
        self.message = message
        self.author = author
        self.authorDateString = authorDateString
        self.committer = committer
        self.committerDateString = committerDateString
        self.branches = branches
        self.tags = tags
        self.parents = parents
        self.diff = diff
    }
    
    public var authorDate: Date {
        authorDateString.toDate(format: "EEE, dd MMM yyyy HH:mm:ss ZZZZ") ?? .now
    }
    
    public var committerDate: Date {
        committerDateString.toDate(format: "EEE, dd MMM yyyy HH:mm:ss ZZZZ") ?? .now
    }
    
    public var diffResult: DiffResult? {
        get throws {
            guard !diff.isEmpty else {
                return nil
            }
            
            return try DiffResultParser().parse(result: diff).get()
        }
    }
}
