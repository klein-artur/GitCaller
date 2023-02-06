//
//  HunkEditorTests.swift
//  
//
//  Created by Artur Hellmann on 05.02.23.
//

@testable import GitCaller

import XCTest

final class HunkEditorTests: XCTestCase {

    func testStageTwoAddedLines() throws {
        // given
        let lines = [4, 7]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
        +
        +
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
         asdf
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkStage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testStageOneRemovedLines() throws {
        // given
        let lines = [3]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
        +
        +
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkStage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testStageOneRemovedOneAddedLines() throws {
        // given
        let lines = [3, 4]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
        +
        +
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkStage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testUnstageTwoAddedLines() throws {
        // given
        let lines = [4, 7]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
        +
        +
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        +asdf
         
         
        +asdf
         asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkUnstage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testUnstageOneRemovedLines() throws {
        // given
        let lines = [3]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
        +
        +
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
         asdf
         
         
         asdf
         asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkUnstage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testUnstageOneRemovedOneAddedLines() throws {
        // given
        let lines = [3, 4]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
        +
        +
        +asdf
        +asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -7,6 +7,12 @@

         import SwiftUI
         import GitCaller
        -asdf
        +asdf
         
         
         asdf
         asdf

         struct LocalChangesView: View {
             @StateObject var viewModel: LocalChangesViewModel
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkUnstage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testSomeSpecialCase() throws {
        // given
        let lines = [3, 4, 9, 10, 14, 15]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -66,16 +72,16 @@ struct LocalChangesView: View {
                         .background(
                             KeyAwareView { event in
                                 var newElement: DiffChange? = nil
        -                        switch event {
        +                        switch event {asdf
                                 case .upArrow:
                                     newElement = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: -1)
                                 case .downArrow:
                                     newElement = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: 1)
        -                        case .enter:
        +                        case .enter:asdf
                                     if let element = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: 1) ?? viewModel.getChangeFor(item:
         path.change, staged: path.staged, offset: -1) {
                                         newElement = element
        -                            }
        +                            }asdf
                                     if path.staged {
                                         viewModel.unstage(change: path.change.leftItem.change)
                                     } else {
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.

        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -66,16 +72,16 @@ struct LocalChangesView: View {
                         .background(
                             KeyAwareView { event in
                                 var newElement: DiffChange? = nil
        -                        switch event {
        +                        switch event {asdf
                                 case .upArrow:
                                     newElement = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: -1)
                                 case .downArrow:
                                     newElement = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: 1)
        -                        case .enter:
        +                        case .enter:asdf
                                     if let element = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: 1) ?? viewModel.getChangeFor(item:
         path.change, staged: path.staged, offset: -1) {
                                         newElement = element
        -                            }
        +                            }asdf
                                     if path.staged {
                                         viewModel.unstage(change: path.change.leftItem.change)
                                     } else {
        # ---
        # To remove '-' lines, make them ' ' lines (context).
        # To remove '+' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for staging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkUnstage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func testSomeSpecialUnstagingCase() throws {
        // given
        let lines = [3, 14]
        let input = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -20,17 +20,15 @@ private func runTask(arguments: [String], inputPipe: Pipe?, onReceive: ((String)

             let outHandle = pipe.fileHandleForReading

        -    if let onReceive = onReceive, let onCompletion = onCompletion {
        -        pipe.fileHandleForReading.readabilityHandler = { handle in
        -            let data = handle.availableData
        -            if data.isEmpty {
        -                handle.readabilityHandler = nil
        -                onCompletion()
        -            } else {
        -                if let str = String(data: data, encoding: .utf8) {
        -                    print(str)
        -                    onReceive(str)
        -                }
        +    pipe.fileHandleForReading.readabilityHandler = { handle in
        +        let data = handle.availableData
        +        if data.isEmpty {
        +            handle.readabilityHandler = nil
        +            onCompletion?()
        +        } else {
        +            if let str = String(data: data, encoding: .utf8) {
        +                print(str)
        +                onReceive?(str)
                     }
                 }
             }
        # ---
        # To remove '+' lines, make them ' ' lines (context).
        # To remove '-' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for unstaging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.

        """
        let expected = """
        # Manual hunk edit mode -- see bottom for a quick guide.
        @@ -20,17 +20,15 @@ private func runTask(arguments: [String], inputPipe: Pipe?, onReceive: ((String)

             let outHandle = pipe.fileHandleForReading

        -    if let onReceive = onReceive, let onCompletion = onCompletion {
        +    pipe.fileHandleForReading.readabilityHandler = { handle in
                 let data = handle.availableData
                 if data.isEmpty {
                     handle.readabilityHandler = nil
                     onCompletion?()
                 } else {
                     if let str = String(data: data, encoding: .utf8) {
                         print(str)
                         onReceive?(str)
                     }
                 }
             }
        # ---
        # To remove '+' lines, make them ' ' lines (context).
        # To remove '-' lines, delete them.
        # Lines starting with # will be removed.
        # If the patch applies cleanly, the edited hunk will immediately be marked for unstaging.
        # If it does not apply cleanly, you will be given an opportunity to
        # edit again.  If all lines of the hunk are removed, then the edit is
        # aborted and the hunk is left unchanged.
        """
        
        // when
        let result = input.editHunkUnstage(lines: lines)
        
        // then
        XCTAssertEqual(result, expected)
    }
}
