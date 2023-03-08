import Foundation
import AppKit

let communicationService = CommunicationService();
communicationService.connect();

let app = NSApplication.shared
let delegate = AppDelegate(communicationPublisher: communicationService.getPublisher())
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
