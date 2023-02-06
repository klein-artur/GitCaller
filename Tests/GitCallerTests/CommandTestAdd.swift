//
//  CommandTestAdd.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

@testable import GitCaller

import XCTest

final class CommandTestAdd: XCTestCase {

    func testGitAdd() throws {
        XCTAssertEqual(
            Git().add.toString(),
            "git add"
        )
    }
    
    func testGitAddWithPath() throws {
        let command = Git().add.path("path/to/file")
        XCTAssertEqual(
            command.toString(),
            "git add path/to/file"
        )
    }
    
    func testGitAddWithAllParam() throws {
        let command = Git().add.all()
        XCTAssertEqual(
            command.toString(),
            "git add --all"
        )
    }
    
    func testGitAddWithPathAndAllParam() throws {
        let command = Git().add.path("path/to/file").all()
        XCTAssertEqual(
            command.toString(),
            "git add path/to/file --all"
        )
    }

}
