//
//  ToolSelectView.swift
//  PaintBoard
//
//  Created by 한현민 on 2023/08/17.
//

import SwiftUI

struct ToolSelectView: View {
    @Binding var currentMode: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Button {
                currentMode = 0
            } label: {
                switch currentMode {
                case 0:
                    Image(systemName: "paintbrush.fill")
                        .font(.system(size: 24))
                case 1:
                    Image(systemName: "paintbrush")
                        .font(.system(size: 24))
                default:
                    Image(systemName: "paintbrush.fill")
                        .font(.system(size: 24))
                }
            }
            
            Button {
                currentMode = 1
            } label: {
                switch currentMode {
                case 0:
                    Image(systemName: "eraser")
                        .font(.system(size: 24))
                case 1:
                    Image(systemName: "eraser.fill")
                        .font(.system(size: 24))
                default:
                    Image(systemName: "eraser.fill")
                        .font(.system(size: 24))
                }
            }
        }
    }
}

struct ToolSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ToolSelectView(currentMode: .constant(0))
    }
}
