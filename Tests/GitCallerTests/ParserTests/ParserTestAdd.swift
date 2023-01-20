//
//  ParserTestAdd.swift
//
//
//  Created by Artur Hellmann on 09.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestAdd: XCTestCase {
    
    var sut: AddResultParser!

    override func setUpWithError() throws {
        sut = AddResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFileNotExists() throws {
        // given
        let input = """
        fatal: pathspec 'GitBuddy/Views/Repository/LocalChanges/LocalChangesViewModel.swif' did not match any files
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkError(messageIfNotError: "should return a parse error file not exists.", type: .fileNotExists)
    }
    
    func testSuccess() throws {
        // given
        let input = """
        anyinput
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { _ in }
    }

}
