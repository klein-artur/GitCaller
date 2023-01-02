//
//  CommandTestLog.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

@testable import GitCaller

import XCTest

final class CommandTestLog: XCTestCase {
    
    func testGitLog() throws {
        XCTAssertEqual(Git().log.resolve(), "git log")
    }

}
