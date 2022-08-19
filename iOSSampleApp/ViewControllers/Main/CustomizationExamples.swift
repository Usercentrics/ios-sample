import Foundation
import UIKit
import UsercentricsUI

func customizationExample1() -> BannerSettings {
    return BannerSettings(
        generalStyleSettings: GeneralStyleSettings(
            font: BannerFont(
                regularFont: UIFont(name: "Arial", size: 14)!,
                boldFont: UIFont(name: "Avenir-Heavy", size: 14)!
            ),
            links: .both
        ),
        firstLayerStyleSettings: FirstLayerStyleSettings(
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
    )
}

private let lightGray = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00)
private let gray = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
private let dark = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.00)

func customizationExample2() -> BannerSettings {
    return BannerSettings(
        generalStyleSettings: GeneralStyleSettings(
            font: BannerFont(
                regularFont: UIFont(name: "Arial", size: 14)!,
                boldFont: UIFont(name: "Avenir-Heavy", size: 14)!
            ),
            logo: UIImage(named: "logo"),
            links: .secondLayerOnly,
            textColor: lightGray,
            layerBackgroundColor: dark,
            layerBackgroundSecondaryColor: gray,
            linkColor: UIColor.white,
            tabColor: UIColor.white,
            bordersColor: gray
        ),
        firstLayerStyleSettings: FirstLayerStyleSettings(
            headerImage: .logo(settings: LogoSettings(image: UIImage(named: "logo"), position: .center)),
            title: TitleSettings(
                font: UIFont(name: "Avenir-Heavy", size: 22.0),
                textColor: UIColor.white,
                textAlignment: .center
            ),
            message: MessageSettings(
                font: UIFont(name: "Arial", size: 14),
                textColor: lightGray,
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
            backgroundColor: dark
        )
    )
}
