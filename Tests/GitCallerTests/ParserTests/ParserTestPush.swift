//
//  ParserTestPush.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestPush: XCTestCase {

    var sut: PushResultParser!

    override func setUpWithError() throws {
        sut = PushResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNothingChanged() throws {
        // given
        let input = """
        Everything up-to-date
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
        Enumerating objects: 6, done.
        Counting objects: 100% (6/6), done.
        Delta compression using up to 8 threads
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { success in
            XCTAssertTrue(success.didChange)
        }
    }

}

