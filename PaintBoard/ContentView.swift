//
//  ContentView.swift
//  PaintBoard
//
//  Created by 한현민 on 2023/08/17.
//

import SwiftUI

struct ContentView: View {
    @StateObject var canvasStore: CanvasStore = .init()
    
    @State var currentMode: Int = 0
    @State var currentColor: Color = .black
    
    var body: some View {
        VStack(spacing: 16) {
            CanvasView(canvasStore: canvasStore)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                }
                
            ToolSelectView(currentMode: $currentMode)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                }
                
            PaletteView(currentColor: $currentColor)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                }
        }
        .padding()
        .task {
            await canvasStore.initCanvas()
            await canvasStore.importCanvas()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(canvasStore: CanvasStore())
    }
}
