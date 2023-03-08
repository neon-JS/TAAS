import Foundation
import Combine

class CommunicationService {

    private var websocket: URLSessionWebSocketTask?;
    private let subject: PassthroughSubject<String, Error>;

    init()
    {
        self.subject = PassthroughSubject();
    }

    public func connect()
    {
        if (websocket != nil) {
            print("already listening");
            return;
        }

        let url = URL(string: "ws://127.0.0.1:8080");
        if (url == nil) {
            print("url is not valid")
            return;
        }

        let session = URLSession(configuration:  .default);
        let websocketTask = session.webSocketTask(with: url!)

        self.handleMessage(websocketTask: websocketTask);

        websocketTask.resume();

        self.ping(websocketTask: websocketTask);
    }

    public func getPublisher() -> AnyPublisher<String, Error>
    {
        return self.subject.eraseToAnyPublisher();
    }

    func handleMessage(websocketTask: URLSessionWebSocketTask)
    {
        websocketTask.receive { result in
            switch result {
            case .failure(_):
                print("Failed to receive message");
            case .success(let message):
                switch (message) {
                    case .string (let text):
                        print("Received: \(text)");
                        self.subject.send(text);
                    case .data(let data):
                        print("Received: \(data)");
                    default:
                        print("Unknown result");
                }
                self.handleMessage(websocketTask: websocketTask)
            }
        };
    }

    func ping(websocketTask: URLSessionWebSocketTask)
    {
        websocketTask.sendPing { error in
            if let _ = error {
                print("Ping failed with error")
            } else if(websocketTask.state == .running){
                self.ping(websocketTask: websocketTask)
            }
        }
    }
}
