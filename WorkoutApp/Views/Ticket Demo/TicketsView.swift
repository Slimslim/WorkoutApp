//
//  TicketsView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/14/24.
//

import SwiftUI
import RealmSwift

struct TicketsView: View {
    /// Fetching data and sort it in a apecific order
    @ObservedResults(Ticket.self, sortDescriptor: SortDescriptor(keyPath: "status", ascending: false)) var tickets
    @Environment(\.realm) var realm
    
    let username: String
    let product: String
    
    /// State variable busy for insicreanous subscition fct
    @State private var busy = false
    @State private var title = ""
    @State private var details = ""
    
    
    var body: some View {
        ZStack{
            VStack{
                List{
                    ForEach(tickets) { ticket in
                        Text(ticket.product)
                    }
                }
                Spacer()
                VStack{
                    TextField("Title", text:$title)
                    TextField("Details", text:$details)
                        .font(.caption)
                    Button("Add Ticket"){
                        addTicket()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty || busy)
                }
            }
            .padding()
            if busy{
                ProgressView()
            }
        }
        .onAppear(perform: { subscribe() })
        .onDisappear(perform: { unsubscribe() })
        .navigationBarTitle(product, displayMode: .inline)
    }
    
    private func addTicket(){
        let ticket = Ticket(
            product: product,
            title: title,
            details: details.isEmpty ? nil : details,
            author: username
        )
        // add new ticket object and upload in Realm
        $tickets.append(ticket)
        
        // clear out values after upload
        title = ""
        details = ""
    }
    
    /// Function to synch the data from the server to the mobile app. It will synch only the specifiy data you want to synch
    private func subscribe(){
        let lastYear = Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate.rounded() - (60 * 60 * 24 * 365))
        let subscriptions = realm.subscriptions
        if subscriptions.first(named: product) == nil {
            busy = true
            subscriptions.update {
                subscriptions.append(QuerySubscription<Ticket>(name: product) { ticket in
                    return ticket.product == product && (
                        ticket.status != .complete || ticket.created > lastYear
                    )
                })
            } onComplete: { error in
                if let error = error {
                    print("Failed to subscribe for \(product): \(error.localizedDescription)")
                }
            }
            busy = false
        }
    }
    
    private func unsubscribe(){
        let subscriptions = realm.subscriptions
        subscriptions.update {
            subscriptions.remove(named: product)
        } onComplete: { error in
            if let error = error{
                print("Failed to unsubscripe for \(product): \(error.localizedDescription)")
            }
        }
    }
}
