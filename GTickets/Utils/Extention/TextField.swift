//
//  TextField.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 4/1/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

@IBDesignable class TextField: UITextField {
  @IBInspectable var isApplyBorderSettings: Bool = false

  override func layoutSubviews() {
    super.layoutSubviews()
    applyBorderSettings()
  }
  
  private func applyBorderSettings () {
    self.layer.borderWidth = LAYER_BORDER_WIDTH
    self.layer.cornerRadius = LAYER_CORNER_RADIUS
    self.layer.borderColor = LAYER_BORDER_COLOR
  }

}
