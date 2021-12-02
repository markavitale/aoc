// Code inside modules can be shared between pages and other source files.

import Foundation

public func measure(_ title: String, block: () -> ()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    
    block()
    
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    let formattedTime = String(format: "%.3f", timeElapsed * 1000)
    print("\(title):: Time: \(formattedTime) ms")
}
