import Foundation
import SwiftData

@Model
final class CatalogItem {
    var id: UUID
    @Attribute(.unique) var activityNomenclature: String

    init(activityNomenclature: String) {
        self.id = UUID()
        self.activityNomenclature = activityNomenclature
    }
}
