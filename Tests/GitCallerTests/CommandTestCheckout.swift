//
//  CommandTestBranch 2.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

@testable import GitCaller

import XCTest

final class CommandTestCheckout: XCTestCase {

    func testBranchCommand() throws {
        XCTAssertEqual(Git().checkout.resolve(), "git checkout")
    }

}
