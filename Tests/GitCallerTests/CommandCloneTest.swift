//
//  CommandCloneTest.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

@testable import GitCaller

import XCTest

final class CommandCloneTest: XCTestCase {

    func testClone() throws {
        XCTAssertEqual(Git().clone(url: "someurl").toString(), "git clone someurl")
    }

}
