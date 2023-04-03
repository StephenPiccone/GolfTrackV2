//
//  TabBarButton.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import SwiftUI

struct TabBarButton: View {
    
    var buttonText: String
    var imageName: String
    var isActive: Bool
    var body: some View {
        
        GeometryReader{ geo in
            
            if isActive {
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: geo.size.width/2, height: 4)
                    .padding(.leading, geo.size.width/4)
            }
            VStack (alignment: .center, spacing: 4){
                Image(systemName: imageName)
                    .font(.system(size: 30))
                //Text(buttonText)
                    //.font(.system(size: 30))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TabBarButton(buttonText: "Home", imageName: "house", isActive: true)
    }
}
