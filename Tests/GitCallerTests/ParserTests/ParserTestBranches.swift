//
//  ParserTestBranches.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.


@testable import GitCaller

import XCTest

final class ParserTestBranches: XCTestCase {

    func testBranchListParsing() throws {
        // given
        let input = """
        * (HEAD detached at fadce24)
          Savebranch
          main
          remotes/origin/HEAD -> origin/main
          remotes/origin/main
        """
        let sut = BranchResultParser()
        
        // when
        let result = try! sut.parse(result: input).get()
        
        // then
        XCTAssertEqual(result.branches?.count, 5)
        XCTAssertEqual(result.branches?[0].name, "HEAD")
        XCTAssertTrue(result.branches?[0].detached == true)
        XCTAssertFalse(result.branches?[3].isLocal == false)
    }

}
