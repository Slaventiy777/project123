//
//  Global.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 4/24/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

func getActualFont(_ font: UIFont) -> UIFont! {
  let fontName = font.fontName
  return UIFont(name: fontName, size: getActualSize(font.pointSize) )!
}

func getActualSize(_ size: CGFloat) -> CGFloat {
  return size / 414 * UIScreen.main.bounds.size.width
}


