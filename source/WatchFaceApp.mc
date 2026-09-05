import Toybox.Lang;
using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Complications;
using Toybox.Background;
using Toybox.System;
using Toybox.Time;

(:background)
class WatchFaceApp extends Application.AppBase {

    function initialize() { AppBase.initialize(); }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {}

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {}

    // Return the initial view of your application here
    function getInitialView() { return [new WatchFaceView(), partialDelegateCreate()]; }

    function getServiceDelegate() as [System.ServiceDelegate] {
        return [new WeatherServiceDelegate()]; // Returns the background worker
    }

    // Receives data transmitted from the background process
    function onBackgroundData(data) {
        var weather = data as Dictionary;
        if (data != null) {
            Application.Storage.setValue("temp", weather["temp"]);
            Application.Storage.setValue("cond", weather["cond"]);
            WatchUi.requestUpdate(); // Force watch face redrawing
        }
    }
}

function getApp() as WatchFaceApp { return Application.getApp() as WatchFaceApp; }
