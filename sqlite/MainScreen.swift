//
//  MainScreen.swift
//  sqlite
//
//  Created by Nickolay Truhin on 03.11.2021.
//

import SwiftUI

struct MainScreen: View {
    @StateObject var vm: MainScreenModel
    
    var body: some View {
        VStack {
            if vm.state == .topics {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(vm.topics, id: \.self) { name in
                            Button(name) {
                                vm.toggleTopic(name)
                            }.padding().background(vm.selectedTopics.contains(name) ? Color.gray : Color.clear)
                        }
                    }
                }.frame(height: 30)
            }
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(Array(vm.rows.enumerated()), id: \.offset) { index, data in
                        HStack {
                            switch vm.state {
                            case .attachmentsCounts:
                                Text(data["user_id"]!)
                                Spacer()
                                Text(data["COUNT(*)"]!)
                                
                            case .topics:
                                Text(data["user_name"]!)
                                Spacer()
                                Text(data["GROUP_CONCAT(topic_title)"]!)
                                
                            case .diffs:
                                Text(data["first_text"]!).frame(maxWidth: .infinity)
                                Spacer()
                                Text(data["diff"]!)
                                Spacer()
                                Text(data["second_text"]!).frame(maxWidth: .infinity)
                                
                            case .empties:
                                Text(data["id"]!).frame(maxWidth: .infinity)
                                Spacer()
                                Text(data["email"]!)
                            }
                        }.padding()
                        
                    }
                }
            }
        }
    }
}

//struct MainScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        MainScreen()
//    }
//}
