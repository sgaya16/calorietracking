//
//  ProgressBar.swift
//  calorie tracker
//
//  Created by Sara Gaya on 5/31/23.
//

import SwiftUI
import Foundation

struct ProgressBar: View {
    @Binding var progressPercent: CGFloat  //percent as a decimal
    var barFillColor: Color = .green
    
    var body: some View {
        
        VStack {
            Text("Goal: \(1200) cal")
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            GeometryReader { geometry in
                let barWidth = geometry.size.width
                
                ZStack(alignment: .leading) {
                    // gray bar
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                        .opacity(0.3)
                    //marker for recommended min intake
                    Rectangle()
                        .fill(.orange)
                        .frame(width: 2, height: 18)
                        .position(CGPoint(x: 0.83 * barWidth, y: 9))
                    //progress bar
                    RoundedRectangle(cornerRadius: 8)
                        .fill(barFillColor)
                        .frame(width: calculateProgressWidth(barWidth: barWidth))
                }
                //sets height of bar
                .frame(height: 18)
                
            }
            //sets height of everything within geometry reader
            .frame(height: 18)
            
            HStack {
                Text("progress: \(Int(round(progressPercent * 100)))%")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("\(1000) daily min. [\(Image(systemName: "questionmark.circle"))](https://www.health.harvard.edu/staying-healthy/calorie-counting-made-easy)")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
        }
        .padding()
    }
    
    //calculates progress bar width so it won't go past 100% mark even if more calories are input
    func calculateProgressWidth(barWidth: CGFloat) -> CGFloat {
        if ((progressPercent * barWidth) > barWidth) {
            return barWidth
        }
        return (progressPercent * barWidth)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progressPercent: .constant(CGFloat(0.5)))
    }
}
