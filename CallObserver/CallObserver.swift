import CallKit

final class CallStateObserver: NSObject {

    static let shared = CallStateObserver()

    var onCallStateChanged: ((Bool) -> Void)?

    var isOnCall: Bool {
        callObserver.calls.contains { !$0.hasEnded }
    }

    private let callObserver = CXCallObserver()

    override init() {
        super.init()
        callObserver.setDelegate(self, queue: .main)
    }
}

extension CallStateObserver: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        onCallStateChanged?(isOnCall)
    }
}
