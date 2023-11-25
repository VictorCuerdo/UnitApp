import GoogleMobileAds
import UIKit

class NativeAdViewFactory: NSObject, GADNativeAdLoaderDelegate {
    private var adLoader: GADAdLoader!
    private weak var rootViewController: UIViewController?

    init(rootViewController: UIViewController) {
        super.init()
        self.rootViewController = rootViewController
        self.adLoader = GADAdLoader(
            adUnitID: "<your_ad_unit_id>", // Replace with your actual Ad Unit ID
            rootViewController: rootViewController,
            adTypes: [.native],
            options: nil)
        self.adLoader.delegate = self
        self.adLoader.load(GADRequest())
    }

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        // Create and configure a view for the native ad
        let nativeAdView = GADNativeAdView(frame: .zero)
        
        // Set the mediaContent
        let mediaView = GADMediaView(frame: CGRect(x: 0, y: 0, width: nativeAdView.frame.width, height: 160))
        nativeAdView.mediaView = mediaView
        
        // Headline
        let headlineLabel = UILabel(frame: .zero)
        headlineLabel.text = nativeAd.headline
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headlineLabel.textColor = .black
        nativeAdView.addSubview(headlineLabel)
        nativeAdView.headlineView = headlineLabel
        
        // Body
        let bodyLabel = UILabel(frame: .zero)
        bodyLabel.text = nativeAd.body
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.textColor = .black
        nativeAdView.addSubview(bodyLabel)
        nativeAdView.bodyView = bodyLabel
        
        // Call to action
        let callToActionButton = UIButton(type: .system)
        callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.addSubview(callToActionButton)
        nativeAdView.callToActionView = callToActionButton
        
        // Icon
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if let icon = nativeAd.icon {
            iconImageView.image = icon.image
            nativeAdView.addSubview(iconImageView)
            nativeAdView.iconView = iconImageView
        }
        
        // Advertiser
        let advertiserLabel = UILabel(frame: .zero)
        if let advertiser = nativeAd.advertiser {
            advertiserLabel.text = advertiser
            advertiserLabel.font = UIFont.italicSystemFont(ofSize: 14)
            advertiserLabel.textColor = .black
            nativeAdView.addSubview(advertiserLabel)
            nativeAdView.advertiserView = advertiserLabel
        }
        
        // Price, Store, Stars, etc. can be added similarly
        // ...
        
        // Assign the native ad to the ad view
        nativeAdView.nativeAd = nativeAd
        
        // Layout constraints and positioning code for all subviews
        // ...

        // Return the configured view
        // ...
    }
    
    // Implement other GADNativeAdLoaderDelegate methods as needed
}
