//
//  ParserTestCommit.swift
//
//
//  Created by Artur Hellmann on 09.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestCommit: XCTestCase {
    
    var sut: CommitResultParser!

    override func setUpWithError() throws {
        sut = CommitResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFileNotExists() throws {
        // given
        let input = """
        fatal: some error
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkError(messageIfNotError: "should return a parse some error.", type: .issueParsing)
    }
    
    func testSuccess() throws {
        // given
        let input = """
        [other 91e3588] Testcommit with
         1 file changed, 1 insertion(+), 1 deletion(-)
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { _ in }
    }

}
