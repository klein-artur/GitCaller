import Cocoa
import Combine

struct GitCaller {
    
    // MARK: Private
    fileprivate static func run(command: String) -> some Publisher<String, Never> {
        
        let resultPublisher = PassthroughSubject<String, Never>()
        
        let task = Process()
        
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"

        let pipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = pipe
        task.standardError = errorPipe
        let outHandle = pipe.fileHandleForReading
        let errorHandle = errorPipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        errorHandle.waitForDataInBackgroundAndNotify()

        var updateObserver: NSObjectProtocol!
        updateObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil, using: { notification in
            let data = outHandle.availableData
            if !data.isEmpty {
                if let str = String(data: data, encoding: .utf8) {
                    resultPublisher.send(str)
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                resultPublisher.send(completion: .finished)
                NotificationCenter.default.removeObserver(updateObserver!)
            }
        })
        
        var errorObserver: NSObjectProtocol!
        errorObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: errorHandle, queue: nil, using: { notification in
            let data = errorHandle.availableData
            if !data.isEmpty {
                if let str = String(data: data, encoding: .utf8) {
                    resultPublisher.send(str)
                }
                errorHandle.waitForDataInBackgroundAndNotify()
            } else {
                NotificationCenter.default.removeObserver(errorObserver!)
            }
        })
        
        var taskObserver : NSObjectProtocol!
        taskObserver = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil, using: { notification in
            print("terminated")
            NotificationCenter.default.removeObserver(taskObserver!)
        })

        task.launch()
        
        return resultPublisher
    }
    
    actor DataHolder {
        var data: Data? = nil
        
        func setData(data: Data) {
            self.data = data
        }
    }
}

extension CommandSpec {
    
    /// Runs the current command and returns a `Publisher` that emits the states of the process.
    public func run() -> AnyPublisher<String, Never> {
        return GitCaller.run(command: self.resolve())
            .removeDuplicates()
            .scan("", { lastResult, nextResult in
                lastResult + nextResult
            })
            .eraseToAnyPublisher()
    }
}
