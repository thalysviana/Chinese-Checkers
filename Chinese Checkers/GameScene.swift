//
//  GameScene.swift
//  Chinese Checkers
//
//  Created by Thalys Viana on 10/08/19.
//  Copyright © 2019 Thalys Viana. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Side: String {
    case nw
    case ne
    case se
    case sw
    case west
    case east
}

class GameScene: SKScene {
    
    var map: SKTileMapNode!
    var reds: [SKSpriteNode]!
    var selectedPiece = SKSpriteNode()
    
    var touchCount = 0
    var totalMoves = -1
    
    var possibleMoves: [(Int, Int)] = []
    
    override func didMove(to view: SKView) {
        map = childNode(withName: "TileMapNode") as? SKTileMapNode
        reds = map.children
            .filter { ($0.userData?["isRed"] as! Bool) == true }
            .map { $0 as! SKSpriteNode }
        
        setupGameBoard()
    }
    
    private func setupGameBoard() {
        let columns = map.numberOfColumns
        let rows = map.numberOfRows
        
        for col in 0..<columns {
            for row in 0..<rows {
                let tile = map.tileGroup(atColumn: col, row: row)
                if let tileGroupName = tile?.name,
                    tileGroupName == "Grass" {
                    let tileDefinition = map.tileDefinition(atColumn: col, row: row)
                    tileDefinition?.userData = NSMutableDictionary()
                    tileDefinition?.userData?.setValue(true, forKey: "isBoard")
                }
            }
        }
    }
    
    private func movePiece(atPos pos: CGPoint) {
        let mapPos = self.convert(pos, to: map)
        let col = map.tileColumnIndex(fromPosition: mapPos)
        let row = map.tileRowIndex(fromPosition: mapPos)
        
        let tileNode = map.nodes(at: mapPos).first
        
        print("row:\(row) | col:\(col)")
        
        if touchCount < 1 {
            if let isPiece = tileNode?.userData?["isPiece"] as? Bool,
                isPiece {
                touchCount += 1
                let pieceNode = tileNode as? SKSpriteNode
                selectedPiece = pieceNode!
            }
        } else {
            let hexTileCenter = map.centerOfTile(atColumn: col, row: row)
            let tileDefinition = map.tileDefinition(atColumn: col, row: row)
            
            if let isBoard = tileDefinition?.userData?["isBoard"] as? Bool,
                tileNode?.userData?["isPiece"] == nil,
                isBoard {
                selectedPiece.run(SKAction.move(to: hexTileCenter, duration: 0.5))
                touchCount += 1
            }
        }
        
        if touchCount == 2 {
            touchCount = 0
            selectedPiece = SKSpriteNode()
        }
    }
    
    private func checkNEMove(atPos pos: CGPoint) {
        let mapPos = self.convert(pos, to: map)
        var col = map.tileColumnIndex(fromPosition: mapPos)
        var row = map.tileRowIndex(fromPosition: mapPos)

        var tileDefinition = map.tileDefinition(atColumn: col, row: row)
        var isBoard = tileDefinition?.userData?["isBoard"]
        
        var columnCounter = row % 2 == 0 ? 0 : 1
        
        totalMoves = -1
    
        while isBoard != nil {
            tileDefinition = map.tileDefinition(atColumn: col, row: row)
            isBoard = tileDefinition?.userData?["isBoard"]

            columnCounter += 1
            row += 1
            
            if columnCounter == 2 {
                col += 1
                columnCounter = 0
            }
            print("row: \(row) | column: \(col)")
            
            let hasPossibleMove = validateMove(col: col, row: row)
            if !hasPossibleMove {
                break
            }
        }
        showPossibleMovesInDirection()
        possibleMoves = []
    }
    
    private func checkNWMove(atPos pos: CGPoint) {
        let mapPos = self.convert(pos, to: map)
        var col = map.tileColumnIndex(fromPosition: mapPos)
        var row = map.tileRowIndex(fromPosition: mapPos)
        
        var tileDefinition = map.tileDefinition(atColumn: col, row: row)
        var isBoard = tileDefinition?.userData?["isBoard"]
        
        var columnCounter = row % 2 == 0 ? 1 : 2
        
        totalMoves = -1
        
        while isBoard != nil {
            tileDefinition = map.tileDefinition(atColumn: col, row: row)
            isBoard = tileDefinition?.userData?["isBoard"]
            
            columnCounter -= 1
            row += 1
            
            if columnCounter == 0 {
                col -= 1
                columnCounter = 2
            }
            print("row: \(row) | column: \(col)")
            
            let hasPossibleMove = validateMove(col: col, row: row)
            if !hasPossibleMove {
                break
            }
        }
        showPossibleMovesInDirection()
        possibleMoves = []
    }
    
    private func checkSEMove(atPos pos: CGPoint) {
        let mapPos = self.convert(pos, to: map)
        var col = map.tileColumnIndex(fromPosition: mapPos)
        var row = map.tileRowIndex(fromPosition: mapPos)
        
        var tileDefinition = map.tileDefinition(atColumn: col, row: row)
        var isBoard = tileDefinition?.userData?["isBoard"]
        
        var columnCounter = row % 2 == 0 ? 0 : 1
        totalMoves = -1
        
        while isBoard != nil {
            tileDefinition = map.tileDefinition(atColumn: col, row: row)
            isBoard = tileDefinition?.userData?["isBoard"]

            columnCounter += 1
            row -= 1
            
            if columnCounter == 2 {
                col += 1
                columnCounter = 0
            }
            print("row: \(row) | column: \(col)")
            
            let hasPossibleMove = validateMove(col: col, row: row)
            if !hasPossibleMove {
                break
            }
        }
        showPossibleMovesInDirection()
        possibleMoves = []
    }
    
    private func checkSWMove(atPos pos: CGPoint) {
        let mapPos = self.convert(pos, to: map)
        var col = map.tileColumnIndex(fromPosition: mapPos)
        var row = map.tileRowIndex(fromPosition: mapPos)
        var tileDefinition = map.tileDefinition(atColumn: col, row: row)
        
        var isBoard = tileDefinition?.userData?["isBoard"]
        var columnCounter = row % 2 == 0 ? 1 : 2
        
        totalMoves = -1
        
        while isBoard != nil {
            tileDefinition = map.tileDefinition(atColumn: col, row: row)
            isBoard = tileDefinition?.userData?["isBoard"]
            
            columnCounter -= 1
            row -= 1
            
            if columnCounter == 0 {
                col -= 1
                columnCounter = 2
            }
            print("row: \(row) | column: \(col)")
            
            let hasPossibleMove = validateMove(col: col, row: row)
            if !hasPossibleMove {
                break
            }
        }
        showPossibleMovesInDirection()
        possibleMoves = []
    }
    
    private func checkSides(atPos pos: CGPoint, side: Side) {
        let mapPos = self.convert(pos, to: map)
        var col = map.tileColumnIndex(fromPosition: mapPos)
        let row = map.tileRowIndex(fromPosition: mapPos)
        
        var tileDefinition = map.tileDefinition(atColumn: col, row: row)
        var isBoard = tileDefinition?.userData?["isBoard"]
        
        totalMoves = -1
        
        while isBoard != nil {
            tileDefinition = map.tileDefinition(atColumn: col, row: row)
            isBoard = tileDefinition?.userData?["isBoard"]
            
            if side == .west {
                col -= 1
            } else if side == .east {
                col += 1
            }
            
            let hasPossibleMove = validateMove(col: col, row: row)
            if !hasPossibleMove {
                break
            }
        }
        
        showPossibleMovesInDirection()
        possibleMoves = []
    }
    
    func showPossibleMovesInDirection() {
        for move in possibleMoves {
            let node = SKShapeNode(circleOfRadius: 10)
            node.fillColor = .blue
            map.addChild(node)
            node.position = map.centerOfTile(atColumn: move.0, row: move.1)
        }
    }
    
    func showPossibleMoves(atPos pos: CGPoint) {
        checkNEMove(atPos: pos)
        checkNWMove(atPos: pos)
        checkSWMove(atPos: pos)
        checkSEMove(atPos: pos)
        checkSides(atPos: pos, side: .west)
        checkSides(atPos: pos, side: .east)
    }
    
    func validateMove(col: Int, row: Int) -> Bool {
        let nodes = map.nodes(at: map.centerOfTile(atColumn: col, row: row))
        let isPiece = checkIfIsPiece(nodes)
        let tileDefinition = map.tileDefinition(atColumn: col, row: row)
        let isBoard = tileDefinition?.userData?["isBoard"]

        if totalMoves == 0 && !isPiece && isBoard != nil {
            possibleMoves.append((col: col, row: row))
            totalMoves = -1
        }
        if isPiece {
            totalMoves += 1
            return true
        } else if !isPiece && totalMoves == -1 && possibleMoves.isEmpty && isBoard != nil {
            possibleMoves.append((col: col, row: row))
            return false
        } else if totalMoves > 1 {
            return false
        }
        return true
    }
    
    private func checkIfIsPiece(_ nodes: [SKNode]) -> Bool {
        let pieceCount = nodes.filter { $0.userData?["isPiece"] != nil }.count
        return pieceCount > 0 ? true : false
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        movePiece(atPos: pos)
        
        if touchCount == 1 {
            showPossibleMoves(atPos: pos)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
