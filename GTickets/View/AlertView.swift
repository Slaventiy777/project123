//
//  AlertView.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/19/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import UIKit

enum AlertType: NSNumber {
    case airplane = 0, doneGreen, donePurple, error, datesError
}

class AlertView: UIView {
  var parent: AlertViewController?
  
    private let images = [
        UIImage.init(named: "AlertAirplane")!,
        UIImage.init(named: "AlertDoneGreen")!,
        UIImage.init(named: "AlertDonePurple")!,
        UIImage.init(named: "AlertError")!,
        UIImage.init(named: "AlertError")!
    ]
    
    private let titles = ["Спасибо!", "Ура!", "Спасибо за оплату!", "Упс...", "Упс..." ]
    
    private let titleColors = [
        UIColor(red: 94/255, green: 40/255, blue: 212/255, alpha: 1),
        UIColor(red: 0, green: 158/255, blue: 11/255, alpha: 1),
        UIColor(red: 94/255, green: 40/255, blue: 212/255, alpha: 1),
        UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 1),
        UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 1)
    ]
    
    private let subtitles = [
        "Ваш запрос обрабатывается.\nВы получите Push-уведомление с результатами подбора",
        "Фото Вашего документа успешно загружено!",
        "Идет оформление билета.\nВы можете отследить статус Вашего заказа в меню приложения",
        "Что-то пошло не так.\nПроверьте правильность введенных данных",
        "Выберите диапазон дат для подбора билета"
    ]
    
    private let buttonColors = [
        [UIColor(red: 144/255, green: 0, blue: 255/255, alpha: 1), UIColor(red: 23/255, green: 97/255, blue: 153/255, alpha: 1)],
        UIColor(red: 0, green: 158/255, blue: 11/255, alpha: 1),
        [UIColor(red: 144/255, green: 0, blue: 255/255, alpha: 1), UIColor(red: 23/255, green: 97/255, blue: 153/255, alpha: 1)],
        UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 1),
        UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 1)
    ] as [Any]
    
    private let buttonTitles = ["ГОТОВО!", "ГОТОВО!", "ГОТОВО!", "ЗАКРЫТЬ", "ЗАКРЫТЬ" ]
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonContainer: GradientView!
    
//    required
    var alertType: AlertType! {
        didSet {
            let index = alertType.rawValue as Int
            icon.image = images[index]
            self.title.text = titles[index]
            self.title.textColor = titleColors[index]
            
            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = -1
            paragraphStyle.maximumLineHeight = 17
            paragraphStyle.alignment = NSTextAlignment.center
            let attrString = NSMutableAttributedString(string: subtitles[index])
            attrString.addAttribute(NSFontAttributeName, value: self.subtitle.font, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            self.subtitle.attributedText = attrString

            self.doneButton.setTitle(buttonTitles[index], for: .normal)
            
            let buttonColor = buttonColors[index]
            if buttonColor is UIColor {
                self.doneButtonContainer.backgroundColor = buttonColor as? UIColor
            } else if buttonColor is [UIColor] {
                self.doneButtonContainer.startColor = ((buttonColor as? [UIColor])![0])
                self.doneButtonContainer.endColor = ((buttonColor as? [UIColor])![1])
            }
        }
    }
  
  @IBAction func done(_ button: UIButton) {
    parent?.close()
  }
  
//    override func updateConstraints() {
//        super.updateConstraints()
//        alertType = AlertType.airplane
//    }
    
}
