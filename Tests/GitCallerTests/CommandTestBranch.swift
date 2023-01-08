//
//  CommandTestBranch.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.
//

@testable import GitCaller

import XCTest

final class CommandTestBranch: XCTestCase {
    
    func testGitBranch() throws {
        XCTAssertEqual(Git().branch.resolve(), "git branch")
    }

}
