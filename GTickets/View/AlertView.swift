//
//  AlertView.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/19/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import UIKit

enum AlertType {
  case airplane
  case doneGreen
  case donePurple
  case error(subtitle: String?)
  
  var image: UIImage? {
    var nameImage = ""
    
    switch self {
    case .airplane:
      nameImage = "AlertAirplane"
    case .doneGreen:
      nameImage = "AlertDoneGreen"
    case .donePurple:
      nameImage = "AlertDonePurple"
    case .error:
      nameImage = "AlertError"
    }
    
    return UIImage(named: nameImage)
  }
  
  var title: String {
    switch self {
    case .airplane:
      return "Спасибо!"
    case .doneGreen:
      return "Ура!"
    case .donePurple:
      return "Спасибо за оплату!"
    case .error:
      return "Упс..."
    }
  }
  
  var titleColor: UIColor {
    switch self {
    case .airplane, .donePurple:
      return UIColor(red: 94 / 255, green: 40 / 255, blue: 212 / 255, alpha: 1)
    case .doneGreen:
      return UIColor(red: 0, green: 158 / 255, blue: 11 / 255, alpha: 1)
    case .error:
      return UIColor(red: 255 / 255, green: 68 / 255, blue: 68 / 255, alpha: 1)
    }
  }
  
  var subtitle: String {
    switch self {
    case .airplane:
      return "Ваш запрос обрабатывается.\nВы получите Push-уведомление с результатами подбора"
    case .doneGreen:
      return "Фото Вашего документа успешно загружено!"
    case .donePurple:
      return "Идет оформление билета.\nВы можете отследить статус Вашего заказа в меню приложения"
    case .error(let subtitle):
      guard let subtitle = subtitle else {
        return "Что-то пошло не так.\nПроверьте правильность введенных данных"
      }
      
      return subtitle
    }
  }
  
  var buttonTitle: String {
    switch self {
    case .airplane, .doneGreen, .donePurple:
      return "ГОТОВО!"
    case .error:
      return "ЗАКРЫТЬ!"
    }
  }
  
  var buttonColor: [UIColor] {
    switch self {
    case .airplane, .donePurple:
      return [UIColor(red: 144/255, green: 0, blue: 255/255, alpha: 1),
              UIColor(red: 23/255, green: 97/255, blue: 153/255, alpha: 1)]
    case .doneGreen:
      return [UIColor(red: 0, green: 158/255, blue: 11/255, alpha: 1)]
    case .error:
      return [UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 1)]
    }
  }
  
}

class AlertView: UIView {
  weak var parent: AlertViewController?
  
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var doneButtonContainer: GradientView!
  
  // Required
  var alertType: AlertType! {
    didSet {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.maximumLineHeight = 17
      paragraphStyle.alignment = NSTextAlignment.center
      
      let attrString = NSMutableAttributedString(string: alertType.subtitle)
      attrString.addAttribute(NSFontAttributeName, value: subtitle.font, range: NSMakeRange(0, attrString.length))
      attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
      
      icon.image = alertType.image
      title.text = alertType.title
      title.textColor = alertType.titleColor
      
      subtitle.attributedText = attrString
      
      doneButton.setTitle(alertType.buttonTitle, for: .normal)
      
      if alertType.buttonColor.count == 1 {
        doneButtonContainer.backgroundColor = alertType.buttonColor[0]
      } else if alertType.buttonColor.count > 1 {
        doneButtonContainer.startColor = alertType.buttonColor[0]
        doneButtonContainer.endColor = alertType.buttonColor[1]
      }
    }
  }
  
  @IBAction func done(_ button: UIButton) {
    parent?.close()
  }
  
}
