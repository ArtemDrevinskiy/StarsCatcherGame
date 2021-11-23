//
//  GameOverViewController.swift
//  StarsCatcher
//
//  Created by Dr.Drexa on 23.11.2021.
//

import UIKit
import WebKit
import SpriteKit
import GameplayKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    public var myUrl = URL(string: "")
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfig)
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backButtonTapped))
        let request = URLRequest(url: myUrl!)
        webView.load(request)
        
    }
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)

    }
    public static func fromStoryboard(url: URL, result: String) -> GameOverViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let view = storyboard.instantiateViewController(identifier: "GameOverViewController") as! GameOverViewController
        view.myUrl = url
        view.title = result
        return view
    }
}
