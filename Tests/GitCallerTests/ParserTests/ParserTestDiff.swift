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
    
    func testShouldBeTwoDiffs() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs.count, 2)
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
            XCTAssertEqual(result.diffs[1].hunks[0].leftFileRange.position, 3)
            XCTAssertNil(result.diffs[1].hunks[0].leftFileRange.length)
            XCTAssertEqual(result.diffs[1].hunks[0].rightFileRange.position, 3)
            XCTAssertNil(result.diffs[1].hunks[0].rightFileRange.length)
            XCTAssertEqual(result.diffs[1].hunks[1].leftFileRange.position, 33)
            XCTAssertEqual(result.diffs[1].hunks[1].leftFileRange.length, 7)
            XCTAssertEqual(result.diffs[1].hunks[1].rightFileRange.position, 33)
            XCTAssertEqual(result.diffs[1].hunks[1].rightFileRange.length, 7)
        }
    }
    
    func testLines() {
        // when
        let result = sut.parse(result: Self.simpleTwoFileDiff)
        
        // then
        result.checkSuccess { result in
            XCTAssertEqual(result.diffs[0].hunks[0].lines.count, 6)
            XCTAssertEqual(result.diffs[1].hunks[0].lines.count, 9)
            
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
     
     
     
    """

}
