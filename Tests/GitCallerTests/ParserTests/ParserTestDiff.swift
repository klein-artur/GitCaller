//
//  ParserTestDiff.swift
//  
//
//  Created by Artur Hellmann on 19.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestDiff: XCTestCase {
    var sut: DiffResultParser!

    override func setUpWithError() throws {
        self.sut = DiffResultParser()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testShouldBeThreeDiffs() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs.count, 3)
        }
    }
    
    func testNamesOfFirstDiffShouldBeSet() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs.first?.leftName, "diffFile")
            XCTAssertEqual(result.diffs.first?.rightName, "diffFile2")
        }
    }
    
    func testIdentsOfFirstDiff() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs.first?.leftIdent, "-")
            XCTAssertEqual(result.diffs.first?.rightIdent, "+")
        }
    }
    
    func testChangeShouldHaveTwoChunks() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs[1].hunks.count, 2)
        }
    }
    
    func testChunkLengths() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs[1].hunks[0].header, "@@ -3 +3 @@")
            XCTAssertEqual(result.diffs[1].hunks[1].header, "@@ -33,7 +33,7 @@")
        }
    }
    
    func testLines() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs[0].hunks[0].lines.count, 6)
            XCTAssertEqual(result.diffs[1].hunks[0].lines.count, 8)
            
            XCTAssertEqual(result.diffs[0].hunks[0].lines[0].type, LineType.both)
            XCTAssertEqual(result.diffs[0].hunks[0].lines[2].type, LineType.left)
            XCTAssertEqual(result.diffs[0].hunks[0].lines[3].type, LineType.right)
        }
    }
                                        
    
    static let simpleTwoFileDiff: String = """
    diff --git a/diffFile b/diffFile2
    index 2959c86..1f2aa9f 100644
    --- a/diffFile
    +++ b/diffFile2
    @@ -1,5 +1,5 @@
     asdf
     
    -asdf
    +asdfasdf
     
     asdf
    diff --git a/diffFile2 b/diffFile2
    index 2959c86..91b7927 100644
    --- a/diffFile2
    +++ b/diffFile2
    @@ -3 +3 @@ asdf
     
     asdf
     
    -
    +asdf
     
     @@ -1,5 +1,5 @@
     asdf
    @@ -33,7 +33,7 @@ asdf
     
     
     
    -asdf
    +asdffdsa
     
     
    diff --cc testfile
    index 6cfbc88,a3f5983..0000000
    --- a/testfile
    +++ b/testfile
    @@@ -1,6 -1,6 +1,11 @@@
      asdf
      
      
    ++<<<<<<< HEAD
     +fdsa
     +
    ++=======
    + asdf
    +
    ++>>>>>>> main
      asdf
    """

}
