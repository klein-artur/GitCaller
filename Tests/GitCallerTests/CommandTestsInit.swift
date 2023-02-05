//
//  CommandTestsInit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//
@testable import GitCaller

import XCTest

final class CommandTestsInit: XCTestCase {
    
    func testInitCommand() throws {
        XCTAssertEqual(Git().initialize.toString(), "git init")
    }
    
    func testInitQuietCommand() throws {
        XCTAssertEqual(Git().initialize.quiet().toString(), "git init --quiet")
    }
    
    func testInitInitialBranchName() throws {
        XCTAssertEqual(
            Git().initialize.initialBranch(name: "test_branch").toString(),
            "git init --initial-branch=test_branch"
        )
    }
    
    func testInitInitialBranchNameAndQuiet() throws {
        let command = Git()
            .initialize
            .initialBranch(name: "test_branch")
            .quiet()
        
        XCTAssertEqual(
            command.toString(),
            "git init --initial-branch=test_branch --quiet"
        )
    }

}
