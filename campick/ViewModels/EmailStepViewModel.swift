import Foundation

@MainActor
final class EmailStepViewModel: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var timerActive: Bool = false
    @Published var showExpiredNotice: Bool = false

    func startTimer(duration: Int = 180) {
        remainingSeconds = duration
        timerActive = true
        showExpiredNotice = false
    }

    func stopTimer() {
        timerActive = false
        remainingSeconds = 0
    }

    func tick() {
        guard timerActive, remainingSeconds > 0 else { return }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            timerActive = false
        }
    }

    func markExpired() {
        showExpiredNotice = true
    }

    func resetExpiredNotice() {
        showExpiredNotice = false
    }

    func timeString() -> String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

