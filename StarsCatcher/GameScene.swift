//
//  GameScene.swift
//  StarsCatcher
//
//  Created by Dr.Drexa on 23.11.2021.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    let startButton = SKSpriteNode(imageNamed: "start_button")
    let starNode = SKSpriteNode(imageNamed: "star")
    var counterTimer = Timer()
    var countOffTouches = 0
    var resultUrl = ResultUrl(winner: " ", loser: " ")
    let apiUrl = "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod"
    
    
    override func didMove(to view: SKView) {
        startButton.name = "startButton"
        starNode.name = "starNode"
        loadURL(from: apiUrl)
        addStartButton()
    }
    /// downloading loser or winner url from api
    private func loadURL(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, response, error in
            guard let strongSelf = self, let data = data, error == nil else {
                print("Ooops, something failed")
                return
            }
            var result = ResultUrl(winner: " ", loser: " ")
            
            do {
                result = try JSONDecoder().decode(ResultUrl.self, from: data)
            }
            catch {
                print("Failed to convert data: \(error.localizedDescription)")
            }
            strongSelf.resultUrl = result
            
        }
        task.resume()
    }
    
    func startTimer() {
        removeNode(node: starNode)
        counterTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false, block: { _ in
            let url = self.resultUrl.loser
            self.presentResultViewController(url: url, result: "You loose!")
        })
    }
    
    func presentResultViewController(url: String, result: String) {
        let newView = GameOverViewController.fromStoryboard(url: URL(string: url)!, result: result)
        self.view?.window?.rootViewController = UINavigationController(rootViewController: newView)
        
    }
    
    func addStartButton() {
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 250)
        startButton.xScale = 0.6
        startButton.yScale = 0.6
        startButton.zPosition = 10
        self.addChild(startButton)
        pulse(node: startButton)
        
    }
    /// pulse animation
    func pulse(node: SKSpriteNode) {
        let pulseUp = SKAction.scale(to: 0.65, duration: 0.5)
        let pulseDown = SKAction.scale(to: 0.55, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        node.run(repeatPulse)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches  {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            guard let name = touchedNode[0].name else {
                return
            }
            if name == "startButton" {
                if UserDefaults.standard.value(forKey: "didWatchTutorial") == nil {
                    UserDefaults.standard.set("true", forKey: "didWatchTutorial")
                    // show popup tutorial

                } else {
                    removeNode(node: startButton)
                    startTimer()
                    addNodeToRandomPosition(node: starNode)
                }

            }
            else if name == "starNode" {
                starTapped()
            }
        }
    }
    
    func starTapped() {
        countOffTouches += 1
        removeNode(node: starNode)
        guard countOffTouches < 10 else {
            counterTimer.invalidate()
            let url = self.resultUrl.winner
            self.presentResultViewController(url: url, result: "You win!!!")
            return
        }
        addNodeToRandomPosition(node: starNode)
    }
    
    func addNodeToRandomPosition(node: SKSpriteNode) {
        let x = Int.random(in: -320...320)
        let y = Int.random(in: -400...500)
        node.position = CGPoint(x: x, y: y)
        node.setScale(CGFloat(0.2))
        node.zPosition = 10
        self.addChild(node)
        
    }
    
    func removeNode(node: SKSpriteNode) {
        node.removeFromParent()
    }
}

struct ResultUrl: Codable {
    let winner: String
    let loser: String
    
    init(winner: String, loser: String) {
        self.winner = winner
        self.loser = loser
    }
}
