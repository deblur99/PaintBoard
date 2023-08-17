//
//  CanvasView.swift
//  PaintBoard
//
//  Created by 한현민 on 2023/08/17.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var canvasStore: CanvasStore
    
    @State private var offset: CGSize = .zero
    @State private var location: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            Grid {
                ForEach(0..<canvasStore.canvas.count) { row in
                    GridRow {
                        ForEach(0..<canvasStore.canvas[0].count) { col in
                            Rectangle()
                                .foregroundColor(canvasStore.canvas[row][col].color)
                                .frame(
                                    width: geometry.size.width / CGFloat(canvasStore.canvas[0].count) - 2,
                                    height: geometry.size.height / CGFloat(canvasStore.canvas.count) - 2)
                            
                                // TapGesture, DragGesture 구현하기
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            offset = value.translation
                                            location = value.location
                                        })
                                        .onEnded({ value in
                                            offset = .zero
                                        })
                                )
                                .gesture(
                                    TapGesture()
                                        .onEnded({
                                            geometry.frame(in: .local).origin.x
                                            geometry.frame(in: .local).origin.y
                                        })
                                )
                        }
                    }
                }
            }
//            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(canvasStore: CanvasStore())
    }
}
