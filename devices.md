# Enabled devices

### Round screens

Hardware specifications come from the bundled SDK 9.2.0 [Device Reference](~/AppData/Roaming/Garmin/ConnectIQ/Sdks/connectiq-sdk-win-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/Overview.html).

- **Enabled** means listed in `manifest.xml`; **Base Impl** is the renderer selected by the recursively resolved device `sourcePath` in `monkey.jungle`. Devices without an explicit source/resource mapping show `—`. A mapping alone does not establish compatibility.
- **Low mem** identifies a selected renderer that uses custom affine transforms and legacy buffered bitmaps, not a hardware RAM threshold. Unmapped devices show `—`.
- **OLED** is inferred from the reference’s 65,536-color round display specification; the pages do not explicitly name the panel technology.
- **API** records the device API version where known; `—` means it has not been recorded. The reference’s widget SDK note is not a watchface API version.
- **Barometer** records the built-in pressure sensor (barometric altimeter): `[x]` = present, `[ ]` = absent. GPS elevation, golf PlaysLike distance, phone weather, and external sensors do not establish barometer hardware support. These marks are independent of **Enabled**.
- Barometer support was checked on 2026-10-27 against the installed Garmin device profiles (`~/AppData/Roaming/Garmin/ConnectIQ/Devices/<device>/simulator.json`, `sensorHistory` entry with `type: "pressure"`) and matching `<device>.api.debug.xml` definitions of `getPressureHistory`. Every `[x]` device in the round-screen table and `approachs7247mm` has both; every `[ ]` device in that table has neither. Hardware sources and exceptions are linked below.
- The watch face reads [`SensorHistory.getPressureHistory()`](https://developer.garmin.com/connect-iq/api-docs/Toybox/SensorHistory.html#getPressureHistory-instance_function), introduced in API 2.1.0. The D2 Bravo / Bravo Titanium and fēnix 3 / 3 HR have barometer hardware but are limited to API 1.4, so their `[x]` hardware marks do not imply support for this implementation. Sensor presence also does not guarantee that history samples are available at runtime.
- Fenix 8/9 specifications also use the installed SDK device profiles (`Devices/<device>/compiler.json`), including their explicit `displayType`. Other devices absent from the reference remain at the end with unverified specifications marked `—`.

| Enabled | Device ID               | Base Impl               | Screen  | Low mem | OLED | API | Barometer |
| ------- | ----------------------- | ----------------------- | ------- | ------- | ---- | --- | --------- |
| [x]     | fenix5s                 | fenix5s                 | 218x218 | —       | [ ]  | 3.1 | [x]       |
| [x]     | fr255s                  | fr255s                  | 218x218 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fr255sm                 | fr255s                  | 218x218 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | legacyherocaptainmarvel | vivoactive4s            | 218x218 | [x]     | [ ]  | 3.3 | [x]       |
| [x]     | legacysagarey           | vivoactive4s            | 218x218 | [x]     | [ ]  | 3.3 | [x]       |
| [x]     | vivoactive4s            | vivoactive4s            | 218x218 | [x]     | [ ]  | 3.3 | [x]       |
| [ ]     | approachs60             | —                       | 240x240 | —       | [ ]  | 2.4 | [ ]       |
| [x]     | d2charlie               | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | d2delta                 | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | d2deltapx               | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | d2deltas                | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | descentmk1              | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | descentmk2s             | marqadventurer          | 240x240 | [x]     | [ ]  | —   | [x]       |
| [x]     | fenix5                  | fenix5x                 | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | fenix5plus              | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | fenix5splus             | fenix5plus              | 240x240 | —       | [ ]  | —   | [x]       |
| [x]     | fenix5x                 | fenix5x                 | 240x240 | [x]     | [ ]  | —   | [x]       |
| [x]     | fenix5xplus             | fenix5plus              | 240x240 | [x]     | [ ]  | 3.3 | [x]       |
| [x]     | fenix6s                 | marqadventurer          | 240x240 | [x]     | [ ]  | —   | [x]       |
| [x]     | fenix6spro              | marqadventurer          | 240x240 | [x]     | [ ]  | —   | [x]       |
| [ ]     | fr245                   | —                       | 240x240 | —       | [ ]  | 3.3 | [ ]       |
| [ ]     | fr245m                  | —                       | 240x240 | —       | [ ]  | 3.3 | [ ]       |
| [x]     | fr645                   | fenix5x                 | 240x240 | [x]     | [ ]  | 3.1 | [x]       |
| [x]     | fr645m                  | fenix5x                 | 240x240 | [x]     | [ ]  | 3.2 | [x]       |
| [x]     | fenix7s                 | fenix7s                 | 240x240 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fenix7spro              | fenix7s                 | 240x240 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fr745                   | marqadventurer          | 240x240 | [x]     | [ ]  | —   | [x]       |
| [x]     | fr935                   | fenix5x                 | 240x240 | [x]     | [ ]  | 3.1 | [x]       |
| [x]     | fr945                   | marqadventurer          | 240x240 | [x]     | [ ]  | —   | [x]       |
| [x]     | fr945lte                | marqadventurer          | 240x240 | [x]     | [ ]  | —   | [x]       |
| [x]     | marqadventurer          | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqathlete             | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqaviator             | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqcaptain             | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqcommander           | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqdriver              | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqexpedition          | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | marqgolfer              | marqadventurer          | 240x240 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | vivoactive3             | vivoactive3             | 240x240 | [x]     | [ ]  | 3.1 | [x]       |
| [x]     | vivoactive3d            | vivoactive3             | 240x240 | [x]     | [ ]  | 3.0 | [x]       |
| [x]     | vivoactive3m            | vivoactive3             | 240x240 | [x]     | [ ]  | 3.2 | [x]       |
| [x]     | vivoactive3mlte         | vivoactive3             | 240x240 | [x]     | [ ]  | 3.1 | [x]       |
| [ ]     | approachs62             | —                       | 260x260 | —       | [ ]  | 3.0 | [ ]       |
| [x]     | fenix6                  | fenix6                  | 260x260 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | legacyherofirstavenger  | fenix6                  | 260x260 | [x]     | [ ]  | 3.3 | [x]       |
| [x]     | legacysagadarthvader    | fenix6                  | 260x260 | [x]     | [ ]  | 3.3 | [x]       |
| [x]     | vivoactive4             | vivoactive4             | 260x260 | [x]     | [ ]  | 3.3 | [x]       |
| [x]     | fenix6pro               | fenix6                  | 260x260 | [x]     | [ ]  | 3.4 | [x]       |
| [x]     | fenix7                  | fenix7                  | 260x260 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fenix7pro               | fenix7                  | 260x260 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fenix7pronowifi         | fenix7                  | 260x260 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fenix8solar47mm         | fenix7                  | 260x260 | [ ]     | [ ]  | 6.0 | [x]       |
| [x]     | fenix9prosolar47mm      | fenix7                  | 260x260 | [ ]     | [ ]  | 6.0 | [x]       |
| [x]     | fr255                   | fenix7                  | 260x260 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fr255m                  | fenix7                  | 260x260 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | fr955                   | fenix7                  | 260x260 | [ ]     | [ ]  | 5.2 | [x]       |
| [x]     | descentmk2              | fenix6x                 | 280x280 | —       | [x]  | 3.4 | [x]       |
| [x]     | enduro                  | fenix6x                 | 280x280 | —       | [ ]  | 3.4 | [x]       |
| [x]     | fenix6xpro              | fenix6x                 | 280x280 | [x]     | [ ]  | —   | [x]       |
| [x]     | enduro3                 | fenix7x                 | 280x280 | —       | [ ]  | —   | [x]       |
| [x]     | enduro4                 | fenix7x                 | 280x280 | —       | [ ]  | —   | [x]       |
| [x]     | fenix7x                 | fenix7x                 | 280x280 | [ ]     | [ ]  | —   | [x]       |
| [x]     | fenix7xpro              | fenix7x                 | 280x280 | [ ]     | [ ]  | —   | [x]       |
| [x]     | fenix7xpronowifi        | fenix7x                 | 280x280 | [ ]     | [ ]  | —   | [x]       |
| [x]     | fenix8solar51mm         | fenix7x                 | 280x280 | [ ]     | [ ]  | 6.0 | [x]       |
| [x]     | fenix9prosolar51mm      | fenix7x                 | 280x280 | [ ]     | [ ]  | 6.0 | [x]       |
| [x]     | fr265s                  | venu2s                  | 360x360 | —       | [x]  | 5.2 | [x]       |
| [x]     | venu2s                  | venu2s                  | 360x360 | [ ]     | [x]  | 5.0 | [x]       |
| [ ]     | approachs50             | —                       | 390x390 | —       | [x]  | 5.1 | [ ]       |
| [x]     | approachs7042mm         | —                       | 390x390 | —       | [x]  | —   | [x]       |
| [ ]     | d2air                   | —                       | 390x390 | —       | [x]  | 3.2 | [x]       |
| [x]     | venu                    | venu                    | 390x390 | [x]     | [x]  | 3.3 | [x]       |
| [ ]     | descentg2               | instinctcrossoveramoled | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | descentmk343mm          | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | epix2pro42mm            | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | fr165                   | instinctcrossoveramoled | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | fr165m                  | instinctcrossoveramoled | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | fr57042mm               | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | instinct3amoled45mm     | instinctcrossoveramoled | 390x390 | —       | [x]  | —   | [x]       |
| [ ]     | instinctcrossoveramoled | —                       | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | marq2                   | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | marq2aviator            | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | venu3s                  | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [x]     | venu441mm               | epix2pro42mm            | 390x390 | —       | [x]  | —   | [x]       |
| [ ]     | vivoactive5             | —                       | 390x390 | —       | [x]  | 5.2 | [ ]       |
| [ ]     | vivoactive6             | —                       | 390x390 | —       | [x]  | 6.0 | [ ]       |
| [x]     | d2airx10                | venu2                   | 416x416 | —       | [x]  | —   | [x]       |
| [x]     | d2mach1                 | venu2                   | 416x416 | —       | [x]  | —   | [x]       |
| [x]     | epix2                   | venu2                   | 416x416 | —       | [x]  | —   | [x]       |
| [x]     | epix2pro47mm            | venu2                   | 416x416 | —       | [x]  | —   | [x]       |
| [x]     | fenix843mm              | venu2                   | 416x416 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fenix943mm              | venu2                   | 416x416 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fenix9pro43mm           | venu2                   | 416x416 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fenixe                  | venu2                   | 416x416 | —       | [x]  | 6.0 | [x]       |
| [x]     | fr265                   | venu2                   | 416x416 | —       | [x]  | 5.2 | [x]       |
| [x]     | instinct3amoled50mm     | instinct3amoled50mm     | 416x416 | —       | [x]  | —   | [x]       |
| [x]     | venu2                   | venu2                   | 416x416 | [ ]     | [x]  | 5.0 | [x]       |
| [x]     | venu2plus               | venu2                   | 416x416 | —       | [x]  | 5.0 | [x]       |
| [x]     | approachs7047mm         | fr965                   | 454x454 | —       | [x]  | —   | [x]       |
| [x]     | d2mach2                 | fr965                   | 454x454 | —       | [x]  | —   | [x]       |
| [x]     | d2mach2pro              | fr965                   | 454x454 | —       | [x]  | —   | [x]       |
| [x]     | descentmk351mm          | fr965                   | 454x454 | —       | [x]  | —   | [x]       |
| [x]     | epix2pro51mm            | fr965                   | 454x454 | —       | [x]  | 5.2 | [x]       |
| [x]     | fr965                   | fr965                   | 454x454 | [ ]     | [x]  | 5.2 | [x]       |
| [x]     | fenix847mm              | fr965                   | 454x454 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fenix8pro47mm           | fr965                   | 454x454 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fenix947mm              | fr965                   | 454x454 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fenix9pro47mm           | fr965                   | 454x454 | [ ]     | [x]  | 6.0 | [x]       |
| [x]     | fr57047mm               | fr965                   | 454x454 | —       | [x]  | —   | [x]       |
| [x]     | fr970                   | fr965                   | 454x454 | —       | [x]  | 6.0 | [x]       |
| [x]     | venu3                   | fr965                   | 454x454 | [ ]     | [x]  | —   | [x]       |
| [x]     | venu445mm               | fr965                   | 454x454 | —       | [x]  | —   | [x]       |
| [x]     | fenix9pro51mm           | fenix9pro51mm           | 466x466 | [ ]     | [x]  | 6.0 | [x]       |

---

### Not present in this SDK reference

| Enabled | Device ID       | Base Impl | Screen | Low mem | OLED | API | Barometer |
| ------- | --------------- | --------- | ------ | ------- | ---- | --- | --------- |
| [ ]     | approachs7247mm | —         | —      | —       | —    | —   | [x]       |

### Excluded because to old SDK

_Unless requested by Community_

| Enabled | Device ID        | Base Impl | Screen  | Low mem | OLED | API | Barometer |
| ------- | ---------------- | --------- | ------- | ------- | ---- | --- | --------- |
| [ ]     | fr45             | —         | 208x208 | —       | [ ]  | 1.4 | [ ]       |
| [ ]     | fr55             | —         | 208x208 | —       | [ ]  | 3.4 | [ ]       |
| [ ]     | garminswim2      | —         | 208x208 | —       | [ ]  | 1.4 | [ ]       |
| [ ]     | fenixchronos     | —         | 218x218 | —       | [ ]  | 3.1 | [x]       |
| [ ]     | d2bravo          | —         | 218x218 | —       | [ ]  | —   | [x]       |
| [ ]     | d2bravo_titanium | —         | 218x218 | —       | [ ]  | —   | [x]       |
| [ ]     | fenix3           | —         | 218x218 | —       | [ ]  | 1.4 | [x]       |
| [ ]     | fenix3_hr        | —         | 218x218 | —       | [ ]  | —   | [x]       |
| [ ]     | bounce2          | —         | 390x390 | —       | [x]  | —   | [ ]       |
| [ ]     | venud            | —         | 390x390 | —       | [x]  | —   | [x]       |

### Barometer sources

Garmin's [compatible-device list](https://developer.garmin.com/connect-iq/compatible-devices/) identifies models and API levels, but does not list their sensors. The installed SDK profiles provide device-specific pressure-history support; Garmin's hardware specifications and manuals provide these additional checks:

| Devices                              | Hardware evidence                                                                                                                                                                                                                                                                                                               |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Approach S50 / S70                   | Garmin's [sensor comparison](https://www.garmin.com/en-US/compare/?compareProduct=1604358&compareProduct=1604377&compareProduct=847706) lists a barometric altimeter for S70, but not S50.                                                                                                                                      |
| Approach S62                         | Garmin's [comparison with MARQ Golfer, fēnix 7, and epix](https://www.garmin.com/en-GB/compare/?compareProduct=647267&compareProduct=700437&compareProduct=735611&compareProduct=760778) omits a barometric altimeter for S62, consistent with its SDK profile. S60 also lacks pressure history and the API in its SDK profile. |
| Approach S72                         | The [owner's manual](https://www8.garmin.com/manuals/webhelp/GUID-91BDFC0A-876D-451A-AF8E-8DD63A4D6B85/EN-US/GUID-21FCAD28-A7BD-4656-A616-80CCF1250038.html) explicitly describes the internal barometric altimeter; the installed `approachs7247mm` profile also supports pressure history.                                    |
| vívoactive 5 / 6                     | [Garmin's vívoactive 6 sensor specifications](https://www.garmin.com/en-GB/compare/?compareProduct=1555457&compareProduct=1604377&compareProduct=873008&compareProduct=884292) omit the barometric altimeter. Both SDK profiles lack pressure history and its API.                                                              |
| Forerunner 45 / 55 / 245 / 245 Music | [Garmin's Forerunner 45 sensor comparison](https://www.garmin.com/en-US/compare/?compareProduct=641121&compareProduct=643260) omits the barometric altimeter. Installed profiles for 55, 245, and 245 Music lack pressure history and its API.                                                                                  |
| Garmin Swim 2 / Bounce 2             | Garmin's complete sensor lists for [Swim 2](https://www.garmin.com/en-US/p/665374/pn/010-02247-01/) and [Bounce 2](https://www.garmin.com/en-GB/p/pn/010-03399-02/) do not include a barometric altimeter.                                                                                                                      |
| fēnix 3 / 3 HR                       | The [owner's manual](https://www8.garmin.com/manuals/webhelp/fenix3/EN-US/GUID-0FFD6812-6604-4D97-BC0F-56194CB12EB5.html) explicitly confirms an internal altimeter and barometer.                                                                                                                                              |
| D2 Bravo / Bravo Titanium            | The [owner's manual](https://www8.garmin.com/manuals/webhelp/d2bravo/EN-GB/D2_Bravo_OM_EN-US.pdf) describes calibration of the built-in barometric altimeter.                                                                                                                                                                   |
