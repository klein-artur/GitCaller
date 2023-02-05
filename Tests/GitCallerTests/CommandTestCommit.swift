//
//  CommandTestCommit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

@testable import GitCaller

import XCTest

final class CommandTestCommit: XCTestCase {

    func testGitCommit() throws {
        let command = Git()
            .commit
        
        XCTAssertEqual(command.toString(), "git commit")
    }
    
    func testGitCommitWithPath() throws {
        let command = Git()
            .commit
            .path("some/test way/path")
        XCTAssertEqual(command.toString(), "git commit some/test\\ way/path")
    }
    
    func testGitCommitWithMessage() throws {
        let command = Git()
            .commit
            .message("This is some test")
        XCTAssertEqual(command.toString(), "git commit --message=\"This is some test\"")
    }
    
    func testGitCommitWithMultipleMessages() throws {
        let command = Git()
            .commit
            .message("This is some test")
            .message("This is some other test")
        XCTAssertEqual(command.toString(), "git commit --message=\"This is some test\" --message=\"This is some other test\"")
    }
    
    func testGitCommitWithPathAndMessage() throws {
        let command = Git()
            .commit
            .path("some/test way/path")
            .message("This is some test")
        XCTAssertEqual(command.toString(), "git commit some/test\\ way/path --message=\"This is some test\"")
    }

}
