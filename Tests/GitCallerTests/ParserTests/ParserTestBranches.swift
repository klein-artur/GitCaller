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
          Savebranch                             8667982e1 fixed issue
          main                                   8667982e1 [ahead 2] fixed issue
          main                                   8667982e1 [behind 2] fixed issue
          main                                   8667982e1 [ahead 3, behind 2] fixed issue
          remotes/origin/HEAD -> origin/main
          remotes/origin/main
        """
        let sut = BranchResultParser()
        
        // when
        let result = try! sut.parse(result: input).get()
        
        // then
        
        XCTAssertEqual(result.branches?.count, 6)
        XCTAssertEqual(result.branches?[0].name, "HEAD")
        XCTAssertTrue(result.branches?[0].detached == true)
        XCTAssertEqual(result.branches?[2].name, "main")
        XCTAssertEqual(result.branches?[2].isLocal, true)
        XCTAssertEqual(result.branches?[2].ahead, 2)
        XCTAssertEqual(result.branches?[3].behind, 2)
        XCTAssertEqual(result.branches?[4].ahead, 3)
        XCTAssertEqual(result.branches?[4].behind, 2)
        XCTAssertTrue(result.branches?[5].isLocal == false)
    }
    
    func testParseDeletion() throws {
        // given
        let input = """
        Deleted branch fix/some (was cdc58a5).
        """
        let sut = BranchResultParser()
        
        // when
        let result = try! sut.parse(result: input).get()
        
        // then
        XCTAssertTrue(result.deletionSuccessfull)
    }

}
