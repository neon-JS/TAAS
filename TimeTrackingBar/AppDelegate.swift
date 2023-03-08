import Cocoa
import Combine;

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?
    private var tasks: [String]?
    private let communicationPublisher : AnyPublisher<String, Error>;
    private var subscription: AnyCancellable?;

    init(communicationPublisher: AnyPublisher<String, Error>) {
        self.communicationPublisher = communicationPublisher;
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        tasks = [
            "PRs",
            "ABC-123",
            "DEF-234",
        ];

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }

        setupMenus();

        self.subscription = self.communicationPublisher.sink(
            receiveCompletion: ({ completion in return }),
            receiveValue: ({ message in self.updateByTaskName(taskName: message)})
        );
    }

    func setupMenus() {
            let menu = NSMenu()

            let menuItems: [NSMenuItem] = tasks?.enumerated()
            .map({(kv) -> NSMenuItem in NSMenuItem(
                title: kv.element,
                action: #selector(didTapOne(sender:)),
                keyEquivalent: "\(kv.offset)"
            )}) ?? [];

            for(item) in menuItems {
                menu.addItem(item);
            }

            menu.addItem(NSMenuItem.separator())

            menu.addItem(NSMenuItem(title: "Quit",
                                    action: #selector(NSApplication.terminate(_:)),
                                    keyEquivalent: "q"
                                   )
            )

            statusItem?.menu = menu
        }

    private func changeStatusBarButton(number: Int) {
        if let button = statusItem?.button {
            button.title = tasks?[number] ?? "none"
            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
        }
    }

    @objc func didTapOne(sender: Timer) {
        let taskName: String = sender.value(forKey: "title") as! String
        updateByTaskName(taskName: taskName)
    }

    func updateByTaskName(taskName: String) {
        let matchingTask = tasks?.firstIndex(where: { name in taskName == name })

        if (matchingTask != nil) {
            changeStatusBarButton(number: matchingTask!)
        }
    }
}
