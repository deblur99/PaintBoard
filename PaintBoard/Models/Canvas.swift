//
//  Canvas.swift
//  PaintBoard
//
//  Created by 한현민 on 2023/08/17.
//

import Firebase
import Foundation
import SwiftUI

enum CanvasColor: Int, Codable {
    case white = 0
    case black
    case red
    case brown
    case blue
    case cyan
    case yellow
    case green
    case indigo
    case purple
    case orange
    case mint
    
    var color: Color {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        case .red:
            return .red
        case .brown:
            return .brown
        case .cyan:
            return .cyan
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .indigo:
            return .indigo
        case .purple:
            return .purple
        case .orange:
            return .orange
        case .mint:
            return .mint
        }
    }
    
    static let colorList: [Color] =
        [.black, .white, .blue, .red, .brown, .cyan,
         .yellow, .green, .indigo, .purple, .orange, .mint]
}

class CanvasStore: ObservableObject {
    // 50x50 픽셀 배열
    @Published var canvas: [[CanvasColor]] = CanvasStore.initData
    
    func importCanvas() async {
        try await Database.database().reference().child("canvas").observe(.value, with: { DataSnapshot in
            if let value = DataSnapshot.value as? String {
                if let jsonData = value.data(using: .utf8) {
                    if let result = try? JSONDecoder().decode([[CanvasColor]].self, from: jsonData) {
                        DispatchQueue.main.async {
                            self.canvas = result
                        }
                    }
                }
            }
        })
    }
    
    // 모든 픽셀을 흰색으로 초기화
    func initCanvas() async {
        for row in 0..<canvas.count {
            for col in 0..<canvas[0].count {
                // canvas[row][col]
                // {"red":0.99999994039535522,"green":0.99999994039535522,"blue":0.99999994039535522}
                if let encodedCanvasArray = try? JSONEncoder().encode(canvas[row][col].rawValue) {
                    let resultString = String(data: encodedCanvasArray, encoding: .utf8) ?? "none"
                    do {
                        // canvas 밑에 row, col 지정하여 저장
                        try await Database.database().reference().child("canvas/row\(row)/col\(col)").setValue(resultString)
                    } catch {
                        debugPrint("Firebase export error")
                    }
                }
            }
        }
    }
    
    func updatePixel(row: Int, col: Int, color: CanvasColor) async {
        // 예외처리
        if row >= canvas.count && row < 0 {
            return
        }
        if col >= canvas[0].count && col < 0 {
            return
        }
        
        // canvas 밑에 row, col 지정하여 바뀐 부분만 저장
        canvas[row][col] = color
        
        if let encodedCanvasArray = try? JSONEncoder().encode(color) {
            let resultString = String(data: encodedCanvasArray, encoding: .utf8) ?? "none"
            do {
                // canvas 밑에 row, col 지정하여 저장
                try await Database.database().reference().child("canvas/row\(row)/col\(col)").setValue(resultString)
            } catch {
                debugPrint("Firebase export error")
            }
        }
    }
}

extension CanvasStore {
    // 50x50 픽셀 배열 초기값 (전부 흰색)
    static let initData: [[CanvasColor]] = [
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .blue, .white, .white, .white, .yellow, .white, .white, .white, .white, .red,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
        [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white,
         .white, .white, .white, .white, .white, .white, .white, .white, .white, .white],
    ]
}
