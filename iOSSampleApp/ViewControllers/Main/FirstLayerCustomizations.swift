import Foundation
import UIKit
import UsercentricsUI

func firstLayerCustomizationOne() -> FirstLayerStyleSettings {
    return FirstLayerStyleSettings(
        headerImage: .extended(image: UIImage(named: "logoExtended")),
        title: TitleSettings(
            font: UIFont(name: "Avenir-Heavy", size: 16),
            textColor: UIColor.black,
            textAlignment: .left
        ),
        message: MessageSettings(
            font: UIFont(name: "Arial", size: 14),
            textColor: UIColor.darkGray,
            textAlignment: .left,
            linkTextColor: UIColor.black
        ),
        buttonLayout: .row(buttons: [
            ButtonSettings(
                type: .more,
                font: UIFont(name: "Avenir", size: 14),
                textColor: UIColor.black,
                backgroundColor: UIColor.clear
            ),
            ButtonSettings(
                type: .acceptAll,
                font: UIFont(name: "Avenir-Heavy", size: 14),
                cornerRadius: 20.0
            )
        ]),
        cornerRadius: 16.0
    )
}

func firstLayerCustomizationTwo() -> FirstLayerStyleSettings {
    return FirstLayerStyleSettings(
        headerImage: .logo(settings: LogoSettings(image: UIImage(named: "logo"), position: .center)),
        title: TitleSettings(
            font: UIFont(name: "Avenir-Heavy", size: 22.0),
            textColor: UIColor.white,
            textAlignment: .center
        ),
        message: MessageSettings(
            font: UIFont(name: "Arial", size: 14),
            textColor: UIColor.lightGray,
            textAlignment: .left,
            linkTextColor: UIColor.white
        ),
        buttonLayout: .column(buttons: [
            ButtonSettings(
                type: .more,
                font: UIFont(name: "Avenir", size: 14),
                textColor: UIColor.white,
                backgroundColor: UIColor.clear
            ),
            ButtonSettings(
                type: .acceptAll,
                font: UIFont(name: "Avenir-Heavy", size: 14),
                textColor: UIColor.black,
                backgroundColor: UIColor.white
            )
        ]),
        backgroundColor: UIColor.black
    )
}
