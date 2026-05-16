//
//  SportsPicker.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 5/12/26.
//
import SwiftUI

struct SportsPickerGrid: View {
    
    @Binding var selection: Sport?
    var columns: Int = 3
    let onSelect: (Sport) -> Void
    
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: columns),
            spacing: 0
        ) {
            ForEach(Array(Sport.allCases.enumerated()), id: \.element.id){ idx, sport in
                Button {onSelect(sport)} label: {
                    VStack(spacing: 6) {
                        Image(systemName: sport.icon)
                            .font(.title3)
                            .frame(height: 24)
                        Text(sport.rawValue).font(.subheadline)
                    }
                    
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    
                    .background(Color.clear)
                    .foregroundStyle(selection == sport ? Color.red : Color.primary)
                    
                    
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(Color.primary.opacity(0.12)).frame(height: 1)
                    }
                    .overlay(alignment: .trailing) {
                        Rectangle().fill(Color.primary.opacity(0.12)).frame(width: 1)
                    }
                    .overlay(alignment: .top) {
                        if idx < columns {
                            Rectangle().fill(Color.primary.opacity(0.12)).frame(height: 1)
                        }
                    }
                    .overlay(alignment: .leading) {
                        if idx % columns == 0 {
                            Rectangle().fill(Color.primary.opacity(0.12)).frame(width: 1)
                        }
                    }
                }
                
                .buttonStyle(.plain)
                
            }
        }
        
//        .overlay{
//            Rectangle().stroke(Color.primary.opacity(0.12), lineWidth: 1)
//        }
    }
}
