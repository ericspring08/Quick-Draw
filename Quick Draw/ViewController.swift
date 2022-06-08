//
//  ViewController.swift
//  Quick Draw
//
//  Created by Eric Zhang on 6/8/22.
//

import UIKit
import PencilKit

class ViewController: UIViewController, PKCanvasViewDelegate {
    
    private let canvasView: PKCanvasView = {
       let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }()
    
    let toolPicker = PKToolPicker.init()
    
    let drawing = PKDrawing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonClicked))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = trashButton
        
        canvasView.delegate = self
        
        view.addSubview(canvasView)
    }
    var image = UIImageView()
    
    @objc func saveButtonClicked() {
        let saveImageViewRoot = UIViewController()
        let saveImageView = UINavigationController(rootViewController: saveImageViewRoot)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        let saveToCameraRollButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(saveToCameraRollButtonClicked))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        
        saveImageViewRoot.navigationItem.leftBarButtonItem = cancelButton
        saveImageViewRoot.navigationItem.rightBarButtonItems = [shareButton, saveToCameraRollButton]
        
        saveImageView.view.backgroundColor = UIColor.systemBackground
        image = UIImageView(image: canvasView.drawing.image(from: canvasView.frame, scale: 1.0))
        image.frame = CGRect(x: 0, y: saveImageView.navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        saveImageView.view.addSubview(image)
        saveImageView.modalPresentationStyle = .popover
        self.present(saveImageView, animated: true)
    }
    
    @objc func trashButtonClicked() {
        canvasView.drawing = PKDrawing()
    }
    
    @objc func saveToCameraRollButtonClicked() {
        UIImageWriteToSavedPhotosAlbum(image.image!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonClicked() {
        self.dismiss(animated: false, completion: nil)
        let activityViewController = UIActivityViewController(activityItems: [image.image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        canvasView.frame = view.bounds
    }
    
    @objc func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

