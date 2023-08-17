//
//  PaletteView.swift
//  PaintBoard
//
//  Created by 한현민 on 2023/08/17.
//

import SwiftUI

struct PaletteView: View {
    @Binding var currentColor: Color

    let numberOfRows = 2
    let numberOfCols = 6

    var body: some View {
        Grid {
            ForEach(0..<numberOfRows) { row in
                GridRow {
                    ForEach(row*numberOfCols..<(row + 1)*numberOfCols) { index in
                        Button {
                            currentColor = CanvasColor.colorList[index]
                        } label: {
                            ZStack {
                                // 테두리
                                if currentColor == CanvasColor.colorList[index] {
                                    if currentColor == .black {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 28)
                                    } else {
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: 28)
                                    }
                                }
                                
                                // 컬러
                                Circle()
                                    .fill(CanvasColor.colorList[index])
                                    .frame(width: 24)
                            }
                        }
                        .padding(8)
                    }
                }
            }
        }
        .foregroundColor(Color.gray)
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView(currentColor: .constant(.black))
    }
}
