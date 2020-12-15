//
//  ViewController.swift
//  Responder
//
//  Created by iWw on 2020/12/15.
//

import UIKit

class View: UIView {
    
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        
        button.setTitle("Tap to responder", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(buttonClickAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = .init(x: (self.frame.width - 160) / 2, y: (self.frame.height - 44) / 2, width: 160, height: 44)
    }
    
    @objc func buttonClickAction(_ sender: Any) {
        self.dispatch(event: "viewButtonTapAction")
    }
}

class ViewController: UIViewController {
    
    let actionView = View()
    
    // MARK:- Respondable
    @Respondable private var viewButtonTapAction = ViewController.viewButtonTapAction
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(actionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        actionView.frame = UIScreen.main.bounds
    }

    func viewButtonTapAction(_ param: ResponderParam?) {
        let alert = UIAlertController(title: "Alert", message: "You tap the button in the view", preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


