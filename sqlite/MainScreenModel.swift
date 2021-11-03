//
//  MainScreenModel.swift
//  sqlite
//
//  Created by Nickolay Truhin on 03.11.2021.
//

import Foundation
import SwiftUI

class MainScreenModel: ObservableObject {
    let db = DbServiceSingleton.shared
    
    enum State: String, CaseIterable {
        case attachmentsCounts
        case topics
        case diffs
    }
    
    var state: State
    
    @Published var selectedTopics: [String] = []
    
    func toggleTopic(_ topic: String) {
        if let index = selectedTopics.firstIndex(of: topic) {
            selectedTopics.remove(at: index)
        } else {
            selectedTopics.append(topic)
        }
    }
    
    init(_ state: State) {
        self.state = state
    }
    
    lazy var topics: [String] = db.query("SELECT topic_title FROM TOPIC").compactMap { $0["topic_title"] }

    var rows: [[String: String]] {
        switch state {
        case .attachmentsCounts:
            return db.query("SELECT user_id, COUNT(*) FROM users INNER JOIN messages ON users.id == messages.user_id INNER JOIN attachments ON messages.id == attachments.message_id GROUP BY user_id;")
            
        case .topics:
            return db.query("SELECT user_name, GROUP_CONCAT(topic_title) FROM users INNER JOIN profile ON users.id == profile.user_id INNER JOIN profile_topic ON profile_topic.profile_id == profile.id INNER JOIN topic ON topic.id == profile_topic.topic_id WHERE topic.topic_title IN (\(selectedTopics.map { "\"\($0)\"" }.joined(separator: ", "))) GROUP BY user_id;")
            
        case .diffs:
            return db.query("SELECT t1.text as first_text, t2.text as second_text, t1.created_at - t2.created_at as diff FROM messages as t1 INNER JOIN messages as t2 ON t1.created_at - t2.created_at > 0 AND t1.created_at - t2.created_at < 15*60 GROUP BY t1.id HAVING MIN(t2.created_at) ORDER BY t1.created_at")
        }
    }
}
