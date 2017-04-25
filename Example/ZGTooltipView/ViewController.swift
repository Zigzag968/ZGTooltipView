//
//  ViewController.swift
//  ZGTooltipView
//
//  Created by Alexandre Guibert on 22/05/2016.
//  Copyright © 2016 Zigzag. All rights reserved.
//

import UIKit
import ZGTooltipView

class ViewController: UIViewController {
    
    @IBOutlet var B_Button : UIButton!
    @IBOutlet var BL_Button : UIButton!
    @IBOutlet var BR_Button : UIButton!
    @IBOutlet var T_Button : UIButton!
    @IBOutlet var TL_Button : UIButton!
    @IBOutlet var TR_Button : UIButton!
    @IBOutlet var R_Button : UIButton!
    @IBOutlet var L_Button : UIButton!
    
    var buttons : [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [B_Button, BL_Button, BR_Button, T_Button, TL_Button, TR_Button, R_Button, L_Button]
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let t = ZGTooltipView(direction: .bottom, text: "Bottom Text")
        
        B_Button.setTooltip(t)
        BL_Button.setTooltip(ZGTooltipView(direction: .bottomLeft, text: "Bottom Left Text"))
        BR_Button.setTooltip(ZGTooltipView(direction: .bottomRight, text: "Bottom Right Text"))
        T_Button.setTooltip(ZGTooltipView(direction: .top, text: "Top Text"))
        TL_Button.setTooltip(ZGTooltipView(direction: .topLeft, text: "Top Left Text"))
        TR_Button.setTooltip(ZGTooltipView(direction: .topRight, text: "Top Right Text"))
        R_Button.setTooltip(ZGTooltipView(direction: .right, text: "Right Text"))
        L_Button.setTooltip(ZGTooltipView(direction: .left, text: "Left Text"))

    }
    
    @IBAction func showAllTooltips(_ sender: AnyObject) {
        for button in buttons {
            button.showTooltip()
        }
    }
    
    @IBAction func hideAllTooltips(_ sender: AnyObject) {
        for button in buttons {
            button.dismissTooltip()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

