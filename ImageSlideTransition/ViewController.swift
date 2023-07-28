//
//  ViewController.swift
//  ImageSlideTransition
//
//  Created by Tiago Pinheiro on 07/03/2022.
//

import UIKit

class ViewController: UIViewController {

    private var slideShowView = PaywallSlideShowView()
    private var slidwShowView1 = SlideShowView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubView()
        setupUI()
        
        slidwShowView1.backgroundImages = [
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "https://i.insider.com/5829f9a2dd08955d6d8b45f4?width=700",
            "https://photographycourse.net/wp-content/uploads/2014/11/Landscape-Photography-steps.jpg",
            "https://www.wallpapertip.com/wmimgs/29-298920_mountain-beautiful-landscape-photography.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Landscape_Arnisee-region.JPG/1200px-Landscape_Arnisee-region.JPG"
        ]
        
        slidwShowView1.fallbackBackgroundImage = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Landscape_Arnisee-region.JPG/1200px-Landscape_Arnisee-region.JPG"
        
        slideShowView.setData(
            backgroundImages: [
                "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
                "https://i.insider.com/5829f9a2dd08955d6d8b45f4?width=700",
                "https://photographycourse.net/wp-content/uploads/2014/11/Landscape-Photography-steps.jpg",
                "https://www.wallpapertip.com/wmimgs/29-298920_mountain-beautiful-landscape-photography.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Landscape_Arnisee-region.JPG/1200px-Landscape_Arnisee-region.JPG"
            ]
        )
        slideShowView.setData(
            fallbackBackgroundImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Landscape_Arnisee-region.JPG/1200px-Landscape_Arnisee-region.JPG"
        )
        
        startListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeListeners()
    }
    
    private func setupSubView() {
        view.addAutoLayoutSubviews(
            //slideShowView
            slidwShowView1
        )
    }

    private func setupUI() {
        NSLayoutConstraint.activate([
            slidwShowView1.topAnchor.constraint(equalTo: view.topAnchor),
            slidwShowView1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slidwShowView1.leftAnchor.constraint(equalTo: view.leftAnchor),
            slidwShowView1.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
    
    // MARK: - Listners
    
    private func startListeners() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    private func removeListeners() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
    }
    
    @objc
    private func applicationWillEnterForeground() {
        slideShowView.resumeAnimation()
    }
    
    @objc
    private func applicationDidEnterBackground() {
        slideShowView.pauseAnimation()
    }
}

