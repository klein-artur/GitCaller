//
//  ParserTestRestore.swift
//  
//
//  Created by Artur Hellmann on 16.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestRestore: XCTestCase {
    
    var sut: RestoreResultParser!

    override func setUpWithError() throws {
        sut = RestoreResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFileNotExists() throws {
        // given
        let input = """
        fatal: pathspec 'GitBuddy/Views/Repository/LocalChanges/LocalChangesViewModel.swif' did not match any file(s) known to git
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkError(messageIfNotError: "should return a parse error file not exists.", type: .fileNotExists)
    }
    
    func testSuccess() throws {
        // given
        let input = """
        
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { _ in }
    }

}
