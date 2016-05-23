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
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        B_Button.setTooltip(ZGTooltipView(direction: .Bottom, text: "Bottom Text"))
        BL_Button.setTooltip(ZGTooltipView(direction: .BottomLeft, text: "Bottom Left Text"))
        BR_Button.setTooltip(ZGTooltipView(direction: .BottomRight, text: "Bottom Right Text"))
        T_Button.setTooltip(ZGTooltipView(direction: .Top, text: "Top Text"))
        TL_Button.setTooltip(ZGTooltipView(direction: .TopLeft, text: "Top Left Text"))
        TR_Button.setTooltip(ZGTooltipView(direction: .TopRight, text: "Top Right Text"))
        R_Button.setTooltip(ZGTooltipView(direction: .Right, text: "Right Text"))
        L_Button.setTooltip(ZGTooltipView(direction: .Left, text: "Left Text"))
        
        
        for button in buttons {
            button.performSelector(Selector("tooltipGestureHandler:"), withObject: UITapGestureRecognizer())
        }
    }
    
    @IBAction func showAllTooltips(sender: AnyObject) {
        for button in buttons {
            button.showTooltip()
        }
    }
    
    @IBAction func hideAllTooltips(sender: AnyObject) {
        for button in buttons {
            button.dismissTooltip()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

