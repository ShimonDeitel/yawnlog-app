import Foundation

struct FatigueEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var severity: Int // 1-5
    var note: String

    init(id: UUID = UUID(), createdAt: Date = Date(), severity: Int = 3, note: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.severity = severity
        self.note = note
    }
}
