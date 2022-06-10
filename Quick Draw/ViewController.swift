//
//  ViewController.swift
//  Quick Draw
//
//  Created by Eric Zhang on 6/8/22.
//

import UIKit
import PencilKit
import OnboardKit

class ViewController: UIViewController, PKCanvasViewDelegate {
    
    let isFirstLaunch = UserDefaults.isFirstLaunch()
    
    private let canvasView: PKCanvasView = {
       let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }()
    
    let toolPicker = PKToolPicker.init()
    
    var undoedStrokes = [PKStroke]()
    
    func launchOnBoarding() {
        let page1 = OnboardPage(title: "Welcome to Quick Draw",
                               description: "Quick Draw is a simple app for quickly drawing pictures")
        
        let page2 = OnboardPage(title: "Quick Draw is lightweight",
                               description: "Quick Draw is only 5mb")
        
        let page3 = OnboardPage(title: "Quick Draw is easy to use",
                               description: "Quick Draw has a simple interface that isn't cluttered with useless features")
        
        let page4 = OnboardPage(title: "Lets get Started", description: "")
        
        let onboardingViewController = OnboardViewController(pageItems: [page1, page2, page3, page4])
        
        onboardingViewController.modalPresentationStyle = .fullScreen
        onboardingViewController.presentFrom(self, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(isFirstLaunch) {
            launchOnBoarding()
        }
        let saveToCameraRollButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(saveToCameraRollButtonClicked))
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonClicked))
        
        let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left"), style: .plain, target: self, action: #selector(undoButtonClicked))
        
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.right"), style: .plain, target: self, action: #selector(forwardButtonClicked))
        
        let copyButton = UIBarButtonItem(image: UIImage(systemName: "doc.on.clipboard"), style: .plain, target: self, action: #selector(copyButtonClicked))
        
        self.navigationItem.rightBarButtonItems = [saveToCameraRollButton, shareButton, trashButton]
        self.navigationItem.leftBarButtonItems = [forwardButton, undoButton, copyButton]
        
        canvasView.delegate = self
        
        view.addSubview(canvasView)
    }
    var image = UIImageView()
    
    @objc func copyButtonClicked() {
        UIPasteboard.general.image = canvasView.drawing.image(from: self.view.bounds, scale: 1.0)
    }
    
    @objc func undoButtonClicked() {
        if(canvasView.drawing.strokes.isEmpty == false) {
            undoedStrokes.append(canvasView.drawing.strokes.popLast()!)
        }
    }
    
    @objc func forwardButtonClicked() {
        if(undoedStrokes.isEmpty == false) {
            canvasView.drawing.strokes.append(undoedStrokes.popLast()!)
        }
    }
    
    @objc func trashButtonClicked() {
        canvasView.drawing.strokes.removeAll()
        undoedStrokes.removeAll()
    }
    
    @objc func saveToCameraRollButtonClicked() {
        let photo = canvasView.drawing.image(from: self.view.bounds, scale: 1.0)
        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        self.dismiss(animated: true, completion: {
            let alert = UIAlertController(title: nil, message: "Drawing Saved to Camera Roll", preferredStyle: .alert)
            alert.popoverPresentationController?.sourceView = self.view;
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
              alert.dismiss(animated: true)
            }
        })
    }
    
    @objc func shareButtonClicked() {
        self.dismiss(animated: false, completion: nil)
        let activityViewController = UIActivityViewController(activityItems: [canvasView.drawing.image(from: self.view.bounds, scale: 1.0)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        canvasView.frame = view.bounds
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayToolPicker()
    }
    
    func displayToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        
    }
}

