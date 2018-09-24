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
    @IBOutlet var B_Button: UIButton!
    @IBOutlet var BL_Button: UIButton!
    @IBOutlet var BR_Button: UIButton!
    @IBOutlet var T_Button: UIButton!
    @IBOutlet var TL_Button: UIButton!
    @IBOutlet var TR_Button: UIButton!
    @IBOutlet var R_Button: UIButton!
    @IBOutlet var L_Button: UIButton!

    var tooltips: [ZGTooltipView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        tooltips = [
            ZGTooltipView(direction: .bottom, text: "Bottom Text", originView: B_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .bottomLeft, text: "Bottom Left Text", originView: BL_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .bottomRight, text: "Bottom Right Text", originView: BR_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .top, text: "Top Text", originView: T_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .topLeft, text: "Top Left Text", originView: TL_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .topRight, text: "Top Right Text", originView: TR_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .right, text: "Right Text", originView: R_Button, removeOnDismiss: false),
            ZGTooltipView(direction: .left, text: "Left Text", originView: L_Button, removeOnDismiss: false),
        ]
    }

    @IBAction func showAllTooltips(_: AnyObject) {
        for tooltip in tooltips {
            tooltip.displayTooltip()
        }
    }

    @IBAction func hideAllTooltips(_: AnyObject) {
        for tooltip in tooltips {
            tooltip.dismiss(remove: false)
        }
    }
}
