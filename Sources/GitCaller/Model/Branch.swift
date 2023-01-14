//
//  Branch.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

import Foundation

public class Branch {
    public let name: String
    public let isCurrent: Bool
    public let isLocal: Bool
    public let behind: Int
    public let ahead: Int
    public let upstream: Branch?
    public let detached: Bool
    
    public var cleanName: String {
        guard let lastElement = name.split(separator: "/").last else {
            return ""
        }
        return String(lastElement)
    }
    
    public var upToDate: Bool {
        return behind == 0 && ahead == 0
    }
    
    init(
        name: String,
        isCurrent: Bool,
        isLocal: Bool = true,
        behind: Int = 0,
        ahead: Int = 0,
        upstream: Branch? = nil,
        detached: Bool = false
    ) {
        self.name = name
        self.isCurrent = isCurrent
        self.isLocal = isLocal
        self.behind = behind
        self.ahead = ahead
        self.upstream = upstream
        self.detached = detached
    }
}

public enum BranchTreeItemType {
    case branch(Branch)
    case directory(String)
    
    public var isRemoteDir: Bool {
        if case let .directory(name) = self, name == "remotes" {
            return true
        }
        return false
    }
}

public class BranchTreeItem {
    public let type: BranchTreeItemType
    public let fullPath: String
    public var children: [BranchTreeItem]
    
    public weak var parent: BranchTreeItem?
    
    init(
        type: BranchTreeItemType,
        children: [BranchTreeItem],
        parent: BranchTreeItem? = nil,
        fullPath: String
    ) {
        self.type = type
        self.children = children
        self.parent = parent
        self.fullPath = fullPath
    }
}

public extension BranchTreeItem {
    var depth: Int {
        (parent?.depth ?? -1) + 1
    }
}

extension Array where Element == Branch {
    func parseIntoTree() -> BranchTreeItem {
        let root = BranchTreeItem(type: .directory("root"), children: [], fullPath: "")
        var currentParent = root
        for branch in self {
            var currentPath = [String]()
            let pathComponents = branch.name.split(separator: "/")
            for component in pathComponents {
                let componentName = String(component)
                currentPath.append(componentName)
                if let matchingChild = currentParent.children.first(where: {
                    if case let .directory(name) = $0.type, name == componentName {
                        return true
                    }
                    return false
                }) {
                    currentParent = matchingChild
                } else if branch.name.hasSuffix(componentName) {
                    let newBranch = BranchTreeItem(type: .branch(branch), children: [], parent: currentParent, fullPath: branch.name)
                    currentParent.children.append(newBranch)
                } else {
                    let newDirectory = BranchTreeItem(type: .directory(componentName), children: [], parent: currentParent, fullPath: currentPath.joined(separator: "/"))
                    currentParent.children.append(newDirectory)
                    currentParent = newDirectory
                }
            }
            
            currentParent = root
        }
        return root
    }
}

public extension BranchTreeItem {
    var flatten: [BranchTreeItem] {
        self.children.flatMap { item in
            var result = [item]
            result.append(contentsOf: item.flatten)
            return result
        }
    }
}

