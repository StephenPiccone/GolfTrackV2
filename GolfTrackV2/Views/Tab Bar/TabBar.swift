//
//  TabBar.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import SwiftUI

enum Tabs: Int{
    case home = 0
    case records = 1
}
struct TabBar: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        
        HStack{
            
            Button{
                selectedTab = .home
            }label: {
                
                TabBarButton(buttonText: "Home", imageName: "house", isActive: selectedTab == .home)
            }
            .tint(Color(.white))
            
            Button{
                selectedTab = .records
            }label: {
                
                TabBarButton(buttonText: "Records", imageName: "tablecells.fill", isActive: selectedTab == .records)
            }
            .tint(Color(.white))
        }
        
        .frame(height: 82)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.records))
    }
}

