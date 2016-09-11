//
//  ViewController.swift
//  PulsewafeTest
//
//  Created by Andreas Neusüß on 19.08.16.
//  Copyright © 2016 Anerma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var gridView : GridView!
    
    var tapGestureRecognizer : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gridView = GridView(frame: view.bounds)
//        gridView.frame = view.bounds
        view.addSubview(gridView)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        gridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestureRecognizerFired(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func viewDidAppear(_ animated: Bool) {
     //   gridView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerFired(_ gr : UITapGestureRecognizer) {
        guard gr.state == .recognized else {return}
        
        let pointInView = gr.location(in: gr.view!)
        let pointGlobal = view.convert(pointInView, to: nil)
        
        gridView.pulseOnce(at: pointGlobal)
        
    }

}

