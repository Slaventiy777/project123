
import UIKit

fileprivate var setColors: (normalColor: UIColor?, selectedColor: UIColor?) = (normalColor: nil, selectedColor: nil)

extension UIButton {
  
  @IBInspectable var selectedBackgroundColor: UIColor? {
    get {
      return setColors.selectedColor
    }
    
    set {
      setColors.selectedColor = newValue
    }
  }
  
  private var normalBackgroundColor: UIColor? {
    get {
      return setColors.normalColor
    }
    
    set {
      setColors.normalColor = newValue
    }
  }
  
  func setBackgroundColor() {
    if let selectedBackgroundColor = self.selectedBackgroundColor {
      if isSelected {
        borderWidth = 0
        backgroundColor = selectedBackgroundColor
      } else {
        borderWidth = 1
        backgroundColor = normalBackgroundColor
      }
    }
  }
  
}
