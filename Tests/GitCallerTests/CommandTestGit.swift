//
//  CommandTestGit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

@testable import GitCaller

import XCTest

final class CommandTestGit: XCTestCase {

    func testGit() throws {
        XCTAssertEqual(Git().resolve(), "git")
    }

}
