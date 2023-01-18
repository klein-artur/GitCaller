//
//  ParserTestPull.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//
@testable import GitCaller

import XCTest

final class ParserTestPull: XCTestCase {

    var sut: PullResultParser!

    override func setUpWithError() throws {
        sut = PullResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNothingChanged() throws {
        // given
        let input = """
        Already up to date.
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { success in
            XCTAssertFalse(success.didChange)
        }
    }
    
    func testSuccess() throws {
        // given
        let input = """
        Updating 6f4dee37f..210ae9a44
        Fast-forward
        file1
        file2
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { success in
            XCTAssertTrue(success.didChange)
        }
    }

}
