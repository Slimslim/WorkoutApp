//
//  TicketModel.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/14/24.
//

import SwiftUI
import RealmSwift

class Ticket: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id:ObjectId
    @Persisted var product: String
    @Persisted var title: String
    @Persisted var details: String?
    @Persisted var author: String
    @Persisted var created = Date()
    @Persisted var status = TicketStatus.notStarted
    
    var color: Color{
        switch status{
        case .notStarted:
            return .red
        case .inProgress:
            return .yellow
        case .complete:
            return .green
        }
    }
    
    enum TicketStatus: String, PersistableEnum {
        case notStarted, inProgress, complete
    }
    
    convenience init(product: String, title: String, details: String? = nil, author: String, created: Date? = nil, status: TicketStatus = .notStarted){
        self.init()
        self.product = product
        self.title = title
        self.details = details
        self.author = author
        if let created = created {
            self.created = created
        }
        self.status = status
    }
}
