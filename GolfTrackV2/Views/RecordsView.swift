//
//  RecordsView.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import SwiftUI
import CoreData

struct RecordsView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var shot: FetchedResults<Shot>
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Recorded Shots")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
            List{
                ForEach(shot) { shot in
                    
                    NavigationLink(destination: Text("\(shot.distance)")){
                        HStack{
                            Text("\(Double(shot.distance), specifier: "%.0f") YD")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                
                            
                            Spacer()
                            
                            Text(shot.club!)
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                            
                            
                                
                                
                            
                            Spacer()
                            
                            Text(shot.date!.formatted(date: .numeric, time: .omitted))
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing, 10)
                        }
                    }
                    
                }
                .onDelete(perform: deleteShot)
                            
                .listRowBackground(LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .topTrailing
                ))
            }
            .listStyle(.plain)
            .overlay(Group {
                if(shot.isEmpty) {
                    ZStack() {
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .topTrailing
                        ).ignoresSafeArea()
                        Text("No Recorded Shots")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            })
        }
        
        
        
    }
    private func deleteShot(offsets: IndexSet){
        for index in offsets {
            let deleteShot = shot[index]
            managedObjContext.delete(deleteShot)
        }
        do {
           try self.managedObjContext.save()
        }
        catch{
            //Update this for user to see
            print("Data not saved")
        }
    }
}


struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView()
    }
}
