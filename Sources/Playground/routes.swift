import Vapor
import Files

public func routes(_ router: Router) throws {

    // TODO: Extract into methods and structs.
    router.post("run") { req -> Future<HTTPResponse> in
        
        let promise: EventLoopPromise<HTTPResponse> = req.eventLoop.newPromise()
        
        if let count = req.http.body.count, count == 0 {
            promise.succeed(result: HTTPResponse(status: HTTPResponseStatus.badRequest, body: "No Content"))
        }
        
        let body: String = req.http.body.description
        
        let file = try Folder.temporary.createFile(named: "main.swift")
        
        try file.write(string: body)
        
        // Create a Task instance
        let task = Process()
        
        // Set the task parameters
        task.executableURL = URL(string: "/usr/bin/swift") 
        task.arguments = [file.path]
        
        // Create a Pipe and make the task
        // put all the output there
        let pipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardError = errorPipe
        task.standardOutput = pipe
        
        // Launch the task
        try task.run()
        
        // Get the data
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        
        if let output = String(data: data, encoding: String.Encoding.utf8), !output.isEmpty {
            promise.succeed(result: HTTPResponse(status: HTTPResponseStatus.ok, body: output))
        }
        
        if let error = String(data: errorData, encoding: String.Encoding.utf8), !error.isEmpty {
            if error.hasPrefix(file.path) {
                promise.succeed(result: HTTPResponse(status: HTTPResponseStatus.ok, body: error.replacingOccurrences(of: file.path, with: "main.swift")))
            }
            promise.succeed(result: HTTPResponse(status: HTTPResponseStatus.ok, body: error))
        }
        
        return promise.futureResult
    }

    // router.post("format") { req -> Future<HTTPResponse> in

    // }
}