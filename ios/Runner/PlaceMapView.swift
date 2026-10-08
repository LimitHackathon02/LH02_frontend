import Flutter
import MapKit
import UIKit

final class PlaceMapFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return PlaceMapView(frame: frame, arguments: args)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

private final class PlaceMapView: NSObject, FlutterPlatformView {
  private let mapView: MKMapView

  init(frame: CGRect, arguments: Any?) {
    mapView = MKMapView(frame: frame)
    super.init()
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.showsCompass = true
    mapView.isRotateEnabled = false
    mapView.accessibilityLabel = "추천 장소 지도"

    guard let params = arguments as? [String: Any],
      let latitude = params["latitude"] as? NSNumber,
      let longitude = params["longitude"] as? NSNumber
    else { return }

    let coordinate = CLLocationCoordinate2D(
      latitude: latitude.doubleValue,
      longitude: longitude.doubleValue
    )
    guard CLLocationCoordinate2DIsValid(coordinate) else { return }

    let pin = MKPointAnnotation()
    pin.coordinate = coordinate
    pin.title = params["name"] as? String
    pin.subtitle = params["address"] as? String
    mapView.addAnnotation(pin)
    mapView.setRegion(
      MKCoordinateRegion(
        center: coordinate,
        latitudinalMeters: 800,
        longitudinalMeters: 800
      ),
      animated: false
    )
    mapView.selectAnnotation(pin, animated: false)
  }

  func view() -> UIView {
    return mapView
  }
}
