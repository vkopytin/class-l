import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Application;
import Toybox.Graphics;
using Toybox.Time.Gregorian as Date;

const WEEK_DAYS = ["", "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
const MONTHS = { Date.MONTH_JANUARY => "JAN", Date.MONTH_FEBRUARY => "FEB", Date.MONTH_MARCH => "MAR",
                 Date.MONTH_APRIL => "APR",   Date.MONTH_MAY => "MAY",      Date.MONTH_JUNE => "JUN",
                 Date.MONTH_JULY => "JUL",    Date.MONTH_AUGUST => "AUG",   Date.MONTH_SEPTEMBER => "SEP",
                 Date.MONTH_OCTOBER => "OCT", Date.MONTH_NOVEMBER => "NOV", Date.MONTH_DECEMBER => "DEC" };
const EPOCH = 2440587.5;
const SYNODIC_MONTH = 29.53058770576;

class WatchFaceView extends WatchUi.WatchFace {
    private const ONE_RAD = Math.PI * 2.0 / 60.0;
    private const timer = MainTimer.create(self);
    private var sleepMode = false;
    private var isBurnInProtection = false;
    private const initBufferOptions = {
        :width => 260,
        :height => 260,
    };
    private var width = 260;
    private var height = 260;
    private var seconds = 0;
    private var minutes = 0;
    private var quota = 1010;

    private var sunriseTime = 0;
    private var sunsetTime = 0;
    private var batteryLevel = 0;
    private var barometerLevel = 0;

    private var backLayout = [] as Array<Toybox.WatchUi.Drawable>;
    private var analogClock = null as AnalogClockView;

    private var hand = null as WatchUi.BitmapResource;
    private var handDisk = null as WatchUi.BitmapResource;
    private var moonPhaseTiles = null as WatchUi.BitmapResource;
    private var twilightTiles = null as WatchUi.BitmapResource;
    private var batteryLevelBitmap = null as WatchUi.BitmapResource;
    private var batteryLevelTexture = null as Graphics.BitmapTexture;
    private var drawBuffer = [null as Graphics.BufferedBitmap, null as Graphics.BufferedBitmap];
    private var currentDrawBuffer = 0;
    private var buffer = null as Graphics.BufferedBitmap;
    private var buffer2 = null as Graphics.BufferedBitmap;

    private const transform = new Graphics.AffineTransform();
    private const transform2 = new Graphics.AffineTransform();
    private const transformMove = new Graphics.AffineTransform();
    private const transformDayNight = new Graphics.AffineTransform();
    private const transformMoonPhase = new Graphics.AffineTransform();

    private const drawBitmapOptions = { :transform => self.transform };
    private const drawBitmapOptions2 = { :transform => self.transform2 };
    private const initBufferOptions1 = {
        :width => 11,
        :height => 76,
    };
    private const initBufferOptions2 = {
        :width => 260,
        :height => 260,
    };
    private const drawDayNightOptions = { :transform => self.transformDayNight };

    private const initClip = [[1.0, 78.0], [1.0, 0.0], [12.0, 0.0], [12.0, 78.0]];
    private const clearRange = [156, 183, 25, 20];
    private const emptyOpts = {};
    private var lastTime = 0;
    private var clockTime = null as System.ClockTime ? ;

    private var currentTime = null as Toybox.WatchUi.Text;
    private var weekDay = null as Toybox.WatchUi.Text;
    private var month = null as Toybox.WatchUi.Text;
    private var date = null as Toybox.WatchUi.Text;
    private var stepsCount = null as Toybox.WatchUi.Text;
    private var solarCharging = null as Toybox.WatchUi.Text;
    private var bluetooth = null as Toybox.WatchUi.Text;
    private var alarm = null as Toybox.WatchUi.Text;
    private var vibrate = null as Toybox.WatchUi.Text;
    private var background = null as Toybox.WatchUi.Drawable;
    private var secondsClock = null as SecondsClockView;
    private var infoWeather = null as InfoWeather;
    private var heartRate = null as Toybox.WatchUi.Text;
    private var energyLevel = null as Toybox.WatchUi.Text;
    private var barometer = null as Toybox.WatchUi.Text;
    private var battery = null as Toybox.WatchUi.Text;
    private var barometerData = new[52] as Array<Graphics.Point2D>;
    private var heartRateData = new[52] as Array<Graphics.Point2D>;
    private var stepsData = new[28] as Array<Graphics.Point2D>;
    private var moonPhaseTile = [15, 15] as Graphics.Point2D;
    private var twilightTile = [133, 0] as Graphics.Point2D;
    private var renderPhase = false;

    function initialize() {
        Complications.registerComplicationChangeCallback(method(:updateComplication));
        self.subscribeToComplications();

        WatchFace.initialize();
        self.transformMove.translate(130.0, 111.0);
        for (var i = 0; i < 52; i++) {
            self.barometerData[i] = [0, 0];
            self.heartRateData[i] = [0, 0];
        }
        for (var i = 0; i < 28; i++) {
            self.stepsData[i] = [0, 0];
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        self.width = dc.getWidth();
        self.height = dc.getHeight();
        self.initBufferOptions[:width] = self.width;
        self.initBufferOptions[:height] = self.height;
        dc.setAntiAlias(true);
        self.backLayout = Rez.Layouts.main(dc);
        setLayout(self.backLayout);

        self.moonPhaseTiles = WatchUi.loadResource(@Rez.Drawables.moonPhaseTiles);
        self.batteryLevelBitmap = WatchUi.loadResource(Rez.Drawables.batteryLevel);
        self.twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
        self.background = View.findDrawableById("background");
        self.currentTime = View.findDrawableById("currentTime") as Toybox.WatchUi.Text;
        self.weekDay = View.findDrawableById("weekDay");
        self.stepsCount = View.findDrawableById("stepsCount");
        self.month = View.findDrawableById("month");
        self.date = View.findDrawableById("date");
        self.analogClock = View.findDrawableById("analogClock") as AnalogClockView;
        self.secondsClock = View.findDrawableById("secondsClock") as SecondsClockView;
        self.infoWeather = View.findDrawableById("infoWeather") as InfoWeather;
        self.heartRate = View.findDrawableById("heartRate");
        self.energyLevel = View.findDrawableById("energyLevel");
        self.barometer = View.findDrawableById("barometer");
        self.battery = View.findDrawableById("battery") as Toybox.WatchUi.Text;
        self.solarCharging = View.findDrawableById("solarCharging") as Toybox.WatchUi.Text;
        self.bluetooth = View.findDrawableById("bluetooth") as Toybox.WatchUi.Text;
        self.alarm = View.findDrawableById("alarm") as Toybox.WatchUi.Text;
        self.vibrate = View.findDrawableById("vibrate") as Toybox.WatchUi.Text;
        self.hand = WatchUi.loadResource(@Rez.Drawables.SecondsHand);

        // self.currentTime.setFont(Graphics.getVectorFont({:face => "BionicBold", :size => 50}));
        self.drawBuffer = [
            Graphics.createBufferedBitmap(self.initBufferOptions).get(),
            Graphics.createBufferedBitmap(self.initBufferOptions).get()
        ];
        self.buffer = Graphics.createBufferedBitmap(self.initBufferOptions1).get();

        self.batteryLevelTexture = new Graphics.BitmapTexture({ :bitmap => self.batteryLevelBitmap });

        self.solarCharging.setFont(WatchUi.loadResource(Rez.Fonts.system12));
        self.bluetooth.setFont(WatchUi.loadResource(Rez.Fonts.system12));
        self.alarm.setFont(WatchUi.loadResource(Rez.Fonts.system12));
        self.vibrate.setFont(WatchUi.loadResource(Rez.Fonts.system12));
        // self.battery.setFont(WatchUi.loadResource(Rez.Fonts.lcdDisplay9));

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        self.secondsClock.setSeconds(100);
        self.syncData();
        self.timer.nextTick();
        if (self.sleepMode == false) {
            self.timer.start();
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { self.timer.stop(); }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        self.sleepMode = false;
        var settings = System.getDeviceSettings();
        if (settings has :requiresBurnInProtection && settings.requiresBurnInProtection) {
            isBurnInProtection = false;
        }
        self.secondsClock.setSeconds(100);
        self.syncData();
        self.timer.nextTick();
        self.timer.start();
        self.subscribeToComplications();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        self.sleepMode = true;
        var settings = System.getDeviceSettings();
        if (settings has :requiresBurnInProtection && settings.requiresBurnInProtection) {
            isBurnInProtection = true;
        }
        self.timer.stop();
        Complications.unsubscribeFromAllUpdates();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        if (isBurnInProtection) {
            dc.clearClip();
            dc.clear();
            return;
        }
        if (self.renderPhase) {
            self.renderPhase = false;
        } else {
            self.syncData();
        }
        dc.clearClip();
        if (self.sleepMode) {
            self.syncData();
            self.engineTick(1000);
            self.currentDrawBuffer = self.currentDrawBuffer ^ 1;
        }

        self.clockTime = System.getClockTime();
        self.seconds = self.clockTime.sec;

        self.currentTime.setText(
            Lang.format("$1$:$2$", [self.clockTime.hour.format("%02d"), self.clockTime.min.format("%02d")]));

        self.secondsClock.setSeconds(clockTime.sec);

        var buffer = self.drawBuffer[self.currentDrawBuffer];
        dc.drawBitmap2(0, 0, buffer, self.emptyOpts);

        self.secondsClock.drawSecondsHand(dc, buffer, buffer);
    }

    // Handle the partial update event
    function onPartialUpdate(dc as Dc) {
        self.lastTime = System.getTimer();
        var angle = self.seconds * self.ONE_RAD;

        // self.transform2.initialize();
        // self.transform2.rotate(-angle);
        // self.transform2.translate(-130.0, -130.0);
        // dc.setClip(self.clearRange[0], self.clearRange[1], self.clearRange[2], self.clearRange[3]);
        // dc.setColor(0x55AAAA, Graphics.COLOR_BLACK);
        // dc.drawText(168, 177, Graphics.FONT_TINY, self.seconds.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);

        if (self.quota < 999) {
            // self.seconds++;
            self.quota += 2 - (System.getTimer() - self.lastTime);
            // return;
        }

        var clip = self.transformMove.transformPoints(self.transform.transformPoints(self.initClip));
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // var minX = clip[0][0] < clip[1][0] ? clip[0][0] : clip[2][0] < clip[1][0] ? clip[2][0] : clip[1][0];
        var minX = self.min(clip[0][0], self.min(clip[1][0], self.min(clip[2][0], clip[3][0])));
        var minY = self.min(clip[0][1], self.min(clip[1][1], self.min(clip[2][1], clip[3][1])));
        var maxX = self.max(clip[0][0], self.max(clip[1][0], self.max(clip[2][0], clip[3][0])));
        var maxY = self.max(clip[0][1], self.max(clip[1][1], self.max(clip[2][1], clip[3][1])));
        dc.setClip(minX, minY, maxX - minX, maxY - minY);

        // if (seconds < 16) {
        //     dc.setClip(clip[0][0], clip[1][1], clip[2][0] - clip[0][0], clip[3][1] - clip[1][1]);
        // } else if (seconds < 31) {
        //     dc.setClip(clip[3][0], clip[0][1], clip[1][0] - clip[3][0], clip[2][1] - clip[0][1]);
        // } else if (seconds < 46) {
        //     dc.setClip(clip[2][0], clip[3][1], clip[0][0] - clip[2][0], clip[1][1] - clip[3][1]);
        // } else {
        //     dc.setClip(clip[1][0], clip[2][1], clip[3][0] - clip[1][0], clip[0][1] - clip[2][1]);
        // }

        self.transform.initialize();
        self.transform.rotate(angle);
        self.transform.translate(-4.0, -54.0);
        dc.drawBitmap2(0, 0, self.drawBuffer[self.currentDrawBuffer], self.emptyOpts);
        // dc.fillPolygon(clip);
        // dc.drawRectangle(minX, minY, maxX - minX, maxY - minY);
        dc.drawBitmap2(130, 111, self.buffer, self.drawBitmapOptions);

        self.seconds++;
        self.quota += 1 - (System.getTimer() - self.lastTime);
    }

    function updateBackBuffer(backBufferdc as Dc, refresh as Boolean) as Void {
        if (!refresh) {
            return;
        }

        // backBufferdc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        // backBufferdc.clear();

        self.background.draw(backBufferdc);

        backBufferdc.drawBitmap2(cfg.moonPhaseX - self.moonPhaseTile[0], cfg.moonPhaseY - self.moonPhaseTile[1],
                                 self.moonPhaseTiles,
                                 { :bitmapX => self.moonPhaseTile[0], :bitmapY => self.moonPhaseTile[1],
                                   :bitmapWidth => cfg.moonPhaseTileSize,
                                   :bitmapHeight => cfg.moonPhaseTileSize });
        backBufferdc.drawBitmap2(cfg.twilightX - self.twilightTile[0], cfg.twilightY - self.twilightTile[1],
                                 self.twilightTiles,
                                 { :bitmapX => self.twilightTile[0], :bitmapY => self.twilightTile[1],
                                   :bitmapWidth => cfg.twilightTileSize,
                                   :bitmapHeight => cfg.twilightTileSize });
    }

    function updateFrontBuffer(frontBufferdc as Dc, refresh as Boolean) as Void {
        if (!refresh) {
            return;
        }

        // frontBufferdc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        // frontBufferdc.clear();

        frontBufferdc.setAntiAlias(true);

        // self.stepsComplication.draw(frontBufferdc);
        self.analogClock.draw(frontBufferdc);
        self.secondsClock.draw(frontBufferdc);
        frontBufferdc = null;
    }

    function updateInfoBuffer(infoBufferdc as Dc) as Void {
        // infoBufferdc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        // infoBufferdc.clear();

        infoBufferdc.setAntiAlias(true);

        self.weekDay.draw(infoBufferdc);
        self.infoWeather.draw(infoBufferdc);
        self.stepsCount.draw(infoBufferdc);
        self.month.draw(infoBufferdc);
        self.date.draw(infoBufferdc);
        self.currentTime.draw(infoBufferdc);
        self.heartRate.draw(infoBufferdc);
        self.energyLevel.draw(infoBufferdc);
        self.barometer.draw(infoBufferdc);
        self.battery.draw(infoBufferdc);
        self.solarCharging.draw(infoBufferdc);
        self.bluetooth.draw(infoBufferdc);
        self.alarm.draw(infoBufferdc);
        self.vibrate.draw(infoBufferdc);
        // self.bg.draw(bufferdc);
        // self.infoWeekDay.draw(bufferdc);
        // self.infoStress.draw(bufferdc);
        // self.bodyBattery.draw(bufferdc);
        // self.infoWeather.draw(bufferdc);
        // self.infoMoon.draw(bufferdc);
        // infoBufferdc.drawBitmap(0, 0, self.frontBuffer);
        // self.infoDateStatus.draw(bufferdc);
        // self.analogClock.draw(bufferdc);

        // buttery level bar
        var barWidth = cfg.batteryWidth * self.batteryLevel / 100.0;
        infoBufferdc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        infoBufferdc.setFill(self.batteryLevelTexture);
        infoBufferdc.fillRectangle(cfg.batteryX, cfg.batteryY, barWidth, cfg.batteryHeight);

        infoBufferdc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
        infoBufferdc.fillPolygon(self.barometerData);
        infoBufferdc.fillPolygon(self.stepsData);
        infoBufferdc.setColor(0xFF5500, Graphics.COLOR_TRANSPARENT);
        infoBufferdc.fillPolygon(self.heartRateData);

        infoBufferdc = null;
    }

    function engineTick(deltaTime) as Void {
        if (self.renderPhase) {
            WatchUi.requestUpdate();
            return;
        }
        self.clockTime = System.getClockTime();
        self.seconds = self.clockTime.sec;
        // self.secondsDisk.setSeconds(clockTime.sec);
        self.analogClock.setTime(self.clockTime.hour, self.clockTime.min, self.clockTime.sec);
        var currentDrawBuffer = self.currentDrawBuffer;
        self.currentDrawBuffer = self.currentDrawBuffer ^ 1;
        var buffer = self.drawBuffer[currentDrawBuffer];

        var dc = buffer.getDc();
        dc.setAntiAlias(true);

        try {
            self.quota = 1030;

            var refresh = self.minutes != self.clockTime.min;
            self.updateBackBuffer(dc, true);
            self.updateFrontBuffer(dc, true);
            self.updateInfoBuffer(dc);
            self.minutes = self.clockTime.min;

            dc.drawBitmap(0, 0, buffer);
            dc.drawBitmap(0, 0, buffer);
            dc.drawBitmap(0, 0, buffer);

            var bufferdc = self.buffer.getDc();
            bufferdc.drawBitmap(0, 0, self.hand);
        } catch (ex) {
            var message = ex.getErrorMessage();
            System.println(message);
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(10, 120, Graphics.FONT_TINY, message,
                        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        self.renderPhase = true;
        if (!self.sleepMode) {
            WatchUi.requestUpdate();
        }
    }

    function syncData() as Void {
        try {
            var activityMonitor = ActivityMonitor.getInfo();
            if (activityMonitor != null && activityMonitor.steps != null) {
                var steps = activityMonitor.steps;
                self.stepsCount.setText(steps.format("%d"));
            }

            var now = Time.now();
            var date = Date.info(now, Time.FORMAT_SHORT);

            var stats = System.getSystemStats();
            if (stats.solarIntensity != null) {
                if (stats.solarIntensity > 49) {
                    self.solarCharging.setText("\uE1AC");
                    self.solarCharging.setColor(0x55AAAA);
                } else if (stats.solarIntensity > 24) {
                    self.solarCharging.setText("\uE1AE");
                    self.solarCharging.setColor(0x55AAAA);
                } else if (stats.solarIntensity > 0) {
                    self.solarCharging.setText("\uE1AD");
                    self.solarCharging.setColor(0x55AAAA);
                } else {
                    self.solarCharging.setText("\uE1AD");
                    self.solarCharging.setColor(0x000055);
                }
            } else {
                if (stats.charging) {
                    self.solarCharging.setText("\uE3E5");
                    self.solarCharging.setColor(0x55AAAA);
                } else {
                    self.solarCharging.setText("\uE3E5");
                    self.solarCharging.setColor(0x000055);
                }
            }
            self.batteryLevel = stats.battery;

            var phase = self.moonPhase(now);
            self.moonPhaseTile = cfg.moonTileCoords[phase];

            var sunriseTime1 = self.min(self.sunriseTime, self.sunsetTime);
            var sunsetTime1 = self.max(self.sunriseTime, self.sunsetTime);
            var time = date.hour * 60 * 60 + date.min * 60 + date.sec;
            var beforeSunriseTime = sunriseTime1 - 60 * 60;
            var afterSunriseTime = sunriseTime1 + 60 * 60;
            var beforeSunsetTime = sunsetTime1 - 60 * 60;

            if (time < beforeSunriseTime) {
                self.twilightTile = cfg.twilightCoords[3];
            } else if (time < sunriseTime1) {
                self.twilightTile = cfg.twilightCoords[1];
            } else if (time < afterSunriseTime) {
                self.twilightTile = cfg.twilightCoords[0];
            } else if (time < beforeSunsetTime) {
                self.twilightTile = cfg.twilightCoords[0];
            } else if (time < sunsetTime1) {
                self.twilightTile = cfg.twilightCoords[2];
            } else {
                self.twilightTile = cfg.twilightCoords[3];
            }

            self.infoWeather.updateData();

            var settings = Toybox.System.getDeviceSettings();
            if (settings.phoneConnected) {
                self.bluetooth.setText("\uE1A8");
                self.bluetooth.setColor(0x55AAAA);
            } else {
                self.bluetooth.setText("\uE1A9");
                self.bluetooth.setColor(0x000055);
            }

            if (settings.alarmCount > 0) {
                self.alarm.setColor(0x55AAAA);
            } else {
                self.alarm.setColor(0x000055);
            }

            if (settings.vibrateOn) {
                self.vibrate.setColor(0x55AAAA);
            } else {
                self.vibrate.setColor(0x000055);
            }

            if (Toybox has :SensorHistory) {
                var bodyBatteryIterator = Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
                var sample = bodyBatteryIterator.next();
                if (sample != null && sample.data != null) {
                    self.energyLevel.setText(Lang.format("$1$%", [sample.data.format("%d")]));
                }
                if (Toybox.SensorHistory has :getPressureHistory) {
                    sample = Toybox.SensorHistory.getPressureHistory( {});
                    var value = self.graphDataToArray(cfg.barometerX, cfg.barometerY, sample, self.barometerData);
                    self.barometerLevel = value;
                    self.barometer.setText((value / 100).format("%d"));
                }
                if (Toybox.SensorHistory has :getHeartRateHistory) {
                    sample = Toybox.SensorHistory.getHeartRateHistory( {});
                    self.graphDataToArray(cfg.heartRateX, cfg.heartRateY, sample, self.heartRateData);
                }
                self.stepsHistoryToArray(cfg.stepsX, cfg.stepsY, self.stepsData);
            }
            var activityInfo = Activity.getActivityInfo();
            if (activityInfo != null && activityInfo.currentHeartRate != null) {
                self.heartRate.setText(activityInfo.currentHeartRate.format("%d"));
            }

            self.battery.setText(Lang.format("$1$%", [self.batteryLevel.format("%d")]));

            self.clockTime = System.getClockTime();
            self.seconds = self.clockTime.sec;

            self.currentTime.setText(
                Lang.format("$1$:$2$", [self.clockTime.hour.format("%02d"), self.clockTime.min.format("%02d")]));
            self.weekDay.setText(WEEK_DAYS[date.day_of_week]);
            self.weekDay.setColor(date.day_of_week == Date.DAY_SUNDAY ? 0xFF5500 : 0x55AAAA);
            self.month.setText(MONTHS[date.month]);
            self.date.setText(date.day.format("%02d"));

            self.secondsClock.setSeconds(clockTime.sec);

            var dayNightPosition = (self.clockTime.hour + self.clockTime.min / 60.0) / 24.0 * 240.0 - 200.0;
            self.transformDayNight.initialize();
            self.transformDayNight.translate(dayNightPosition, 70.0);
        } catch (ex) {
        }
    }

    function subscribeToComplications() as Void {
        Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_SUNRISE));
        Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_SUNSET));
        Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_BATTERY));
    }

    function updateComplication(complicationId as Toybox.Complications.Id) as Void {
        var complication = Complications.getComplication(complicationId);
        switch (complicationId.getType()) {
            case Complications.COMPLICATION_TYPE_SUNRISE:
                var sunriseTime = complication.value;
                if (sunriseTime != null) {
                    self.sunriseTime = sunriseTime;
                }
                break;
            case Complications.COMPLICATION_TYPE_SUNSET:
                var sunsetTime = complication.value;
                if (sunsetTime != null) {
                    self.sunsetTime = sunsetTime;
                }
                break;
            case Complications.COMPLICATION_TYPE_BATTERY:
                self.batteryLevel = complication.value;
                break;
        }
    }

    function arraySumm(array, def) {
        var sum = 0;
        for (var i = 0; i < array.size(); i++) {
            if (array[i] == null || array[i].data == null) {
                array[i] = def;
            } else {
                array[i] = array[i].data;
            }
            sum += array[i];
        }
        return sum;
    }

    function summ14(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, def) {
        return (a1 == null || a1.data == null ? def : a1.data) + (a2 == null || a2.data == null ? def : a2.data) +
               (a3 == null || a3.data == null ? def : a3.data) + (a4 == null || a4.data == null ? def : a4.data) +
               (a5 == null || a5.data == null ? def : a5.data) + (a6 == null || a6.data == null ? def : a6.data) +
               (a7 == null || a7.data == null ? def : a7.data) + (a8 == null || a8.data == null ? def : a8.data) +
               (a9 == null || a9.data == null ? def : a9.data) + (a10 == null || a10.data == null ? def : a10.data) +
               (a11 == null || a11.data == null ? def : a11.data) + (a12 == null || a12.data == null ? def : a12.data) +
               (a13 == null || a13.data == null ? def : a13.data) + (a14 == null || a14.data == null ? def : a14.data);
    }

    function stepsHistoryToArray(offsetX, offsetY, items) {
        var history = ActivityMonitor.getHistory();
        var max = 10000;
        var length = self.min(items.size() / 4, history.size());
        var height = 10.0;

        if (history != null) {
            for (var i = 0; i < length; i++) {
                var value = self.min(history[i].steps, max);
                value = value * height / max;
                var x = offsetX - i;
                var y = offsetY - value;
                items[4 * i] = [cfg.graphBarWidth * x, offsetY];
                items[4 * i + 1] = [cfg.graphBarWidth * x, offsetY - value];
                items[4 * i + 2] = [cfg.graphBarWidth * x + cfg.graphBarGap, offsetY - value];
                items[4 * i + 3] = [cfg.graphBarWidth * x + cfg.graphBarGap, offsetY];
            }
            for (var i = length; i < items.size() / 4; i++) {
                items[4 * i] = [offsetX, offsetY];
                items[4 * i + 1] = [offsetX, offsetY];
                items[4 * i + 2] = [offsetX, offsetY];
                items[4 * i + 3] = [offsetX, offsetY];
            }
        }
    }

    function graphDataToArray(offsetX, offsetY, sample, items) {
        var max = sample.getMax();
        var min = sample.getMin();
        var diff = max - min;
        var length = 13;
        var height = cfg.graphHeight;
        var result = 0.0;
        if (sample != null) {
            // iterate over the samples and draw the graph
            var data = sample.next();
            var value = data.data;
            result = value;
            value = self.summ14(data, sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                sample.next(), sample.next(), sample.next(), min) /
                    14.0;
            for (var i = 0; i < length; i++) {
                value = (value - min) * height / diff;
                var x = offsetX - i;
                var y = offsetY - value;
                items[4 * i] = [cfg.graphBarWidth * x, offsetY];
                items[4 * i + 1] = [cfg.graphBarWidth * x, offsetY - value];
                items[4 * i + 2] = [cfg.graphBarWidth * x + cfg.graphBarGap, offsetY - value];
                items[4 * i + 3] = [cfg.graphBarWidth * x + cfg.graphBarGap, offsetY];
                value = self.summ14(sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                    sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                    sample.next(), sample.next(), sample.next(), sample.next(), min) /
                        14.0;
            }
        }
        return result;
    }

    function moonPhase(now as Toybox.Time.Moment) {
        var time = (now.value() * 1000.0) / 86400000.0 + EPOCH;
        var phase = (time - 2451550.1) / SYNODIC_MONTH;
        var moonAge = phase - Math.floor(phase);
        if (moonAge < 0) {
            moonAge = moonAge + 1.0;
        }
        // return moonAge * SYNODIC_MONTH;
        return (moonAge * 25).toNumber();
    }

    function min(a, b) { return a < b ? a : b; }

    function max(a, b) { return a > b ? a : b; }
}
