import Cocoa

struct GitCaller {
    
    // MARK: Private
    fileprivate static func run(command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}

extension CommandSpec {
    public func run() -> String {
        GitCaller.run(command: self.resolve())
    }
}
