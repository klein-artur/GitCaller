//
//  CommandTestStatus.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

@testable import GitCaller

import XCTest

final class CommandTestStatus: XCTestCase {

    func testStatusCommand() throws {
        XCTAssertEqual(Git().status.resolve(), "git status")
    }

}
