# Enabled devices

### Round screens

Hardware specifications come from the bundled SDK 9.2.0 [Device Reference](~/AppData/Roaming/Garmin/ConnectIQ/Sdks/connectiq-sdk-win-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/Overview.html).

- **Enabled** means listed in `manifest.xml`; **Base Impl** is the renderer selected by the recursively resolved device `sourcePath` in `monkey.jungle`. Devices without an explicit source/resource mapping show `—`. A mapping alone does not establish compatibility.
- **Low mem** identifies a selected renderer that uses custom affine transforms and legacy buffered bitmaps, not a hardware RAM threshold. Unmapped devices show `—`.
- **OLED** is inferred from the reference’s 65,536-color round display specification; the pages do not explicitly name the panel technology.
- **API** records the device API version where known; `—` means it has not been recorded. The reference’s widget SDK note is not a watchface API version.
- Fenix 8/9 specifications also use the installed SDK device profiles (`Devices/<device>/compiler.json`), including their explicit `displayType`. Other devices absent from the reference remain at the end with unverified specifications marked `—`.

| Enabled | Device ID               | Base Impl      | Screen  | Low mem | OLED | API |
| ------- | ----------------------- | -------------- | ------- | ------- | ---- | --- |
| [ ]     | fenix5s                 | —              | 218x218 | —       | [ ]  | 3.1 |
| [ ]     | fr255s                  | —              | 218x218 | —       | [ ]  | 5.2 |
| [ ]     | fr255sm                 | —              | 218x218 | —       | [ ]  | 5.2 |
| [ ]     | legacyherocaptainmarvel | —              | 218x218 | —       | [ ]  | 3.3 |
| [ ]     | legacysagarey           | —              | 218x218 | —       | [ ]  | —   |
| [x]     | vivoactive4s            | vivoactive4s   | 218x218 | [x]     | [ ]  | 3.3 |
| [ ]     | approachs60             | —              | 240x240 | —       | [ ]  | 2.4 |
| [ ]     | d2charlie               | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | d2delta                 | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | d2deltapx               | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | d2deltas                | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | descentmk1              | —              | 240x240 | —       | [ ]  | —   |
| [x]     | descentmk2s             | marqadventurer | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5                  | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | fenix5plus              | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | fenix5splus             | —              | 240x240 | —       | [ ]  | —   |
| [x]     | fenix5x                 | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5xplus             | —              | 240x240 | —       | [ ]  | 3.3 |
| [x]     | fenix6s                 | marqadventurer | 240x240 | [x]     | [ ]  | —   |
| [x]     | fenix6spro              | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | fr245                   | —              | 240x240 | —       | [ ]  | —   |
| [ ]     | fr245m                  | —              | 240x240 | —       | [ ]  | —   |
| [x]     | fr645                   | fenix5x        | 240x240 | [x]     | [ ]  | 3.1 |
| [x]     | fr645m                  | fenix5x        | 240x240 | [x]     | [ ]  | 3.2 |
| [x]     | fenix7s                 | fenix7s        | 240x240 | [ ]     | [ ]  | 5.2 |
| [x]     | fenix7spro              | fenix7s        | 240x240 | [ ]     | [ ]  | 5.2 |
| [x]     | fr745                   | marqadventurer | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr935                   | —              | 240x240 | —       | [ ]  | —   |
| [x]     | fr945                   | marqadventurer | 240x240 | [x]     | [ ]  | —   |
| [x]     | fr945lte                | marqadventurer | 240x240 | [x]     | [ ]  | —   |
| [x]     | marqadventurer          | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqathlete             | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqaviator             | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqcaptain             | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqcommander           | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqdriver              | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqexpedition          | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | marqgolfer              | marqadventurer | 240x240 | [x]     | [ ]  | 3.4 |
| [x]     | vivoactive3             | vivoactive3    | 240x240 | [x]     | [ ]  | 3.1 |
| [x]     | vivoactive3d            | vivoactive3    | 240x240 | [x]     | [ ]  | 3.0 |
| [x]     | vivoactive3m            | vivoactive3    | 240x240 | [x]     | [ ]  | 3.2 |
| [x]     | vivoactive3mlte         | vivoactive3    | 240x240 | [x]     | [ ]  | 3.1 |
| [ ]     | approachs62             | —              | 260x260 | —       | [ ]  | 3.0 |
| [x]     | fenix6                  | fenix6         | 260x260 | [x]     | [ ]  | 3.4 |
| [ ]     | legacyherofirstavenger  | —              | 260x260 | —       | [ ]  | 3.3 |
| [x]     | legacysagadarthvader    | fenix6         | 260x260 | [x]     | [ ]  | 3.3 |
| [x]     | vivoactive4             | vivoactive4    | 260x260 | [x]     | [ ]  | 3.3 |
| [x]     | fenix6pro               | —              | 260x260 | —       | [ ]  | 3.4 |
| [x]     | fenix7                  | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [x]     | fenix7pro               | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [x]     | fenix7pronowifi         | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [x]     | fenix8solar47mm         | fenix7         | 260x260 | [ ]     | [ ]  | 6.0 |
| [x]     | fenix9prosolar47mm      | fenix7         | 260x260 | [ ]     | [ ]  | 6.0 |
| [x]     | fr255                   | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [x]     | fr255m                  | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [x]     | fr955                   | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | descentmk2              | —              | 280x280 | —       | [ ]  | —   |
| [ ]     | enduro                  | —              | 280x280 | —       | [ ]  | —   |
| [x]     | fenix6xpro              | fenix6x        | 280x280 | [x]     | [ ]  | —   |
| [ ]     | enduro3                 | —              | 280x280 | —       | [ ]  | —   |
| [x]     | fenix7x                 | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [x]     | fenix7xpro              | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [x]     | fenix7xpronowifi        | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [x]     | fenix8solar51mm         | fenix7x        | 280x280 | [ ]     | [ ]  | 6.0 |
| [x]     | fenix9prosolar51mm      | fenix7x        | 280x280 | [ ]     | [ ]  | 6.0 |
| [ ]     | fr265s                  | —              | 360x360 | —       | [x]  | 5.2 |
| [ ]     | venu2s                  | —              | 360x360 | —       | [x]  | 5.0 |
| [ ]     | approachs50             | —              | 390x390 | —       | [x]  | 5.1 |
| [ ]     | approachs7042mm         | —              | 390x390 | —       | [x]  | —   |
| [ ]     | d2air                   | —              | 390x390 | —       | [x]  | 3.2 |
| [x]     | venu                    | venu           | 390x390 | [x]     | [x]  | 3.3 |
| [ ]     | descentg2               | —              | 390x390 | —       | [x]  | —   |
| [ ]     | descentmk343mm          | —              | 390x390 | —       | [x]  | —   |
| [ ]     | epix2pro42mm            | —              | 390x390 | —       | [x]  | —   |
| [ ]     | fr165                   | —              | 390x390 | —       | [x]  | —   |
| [ ]     | fr165m                  | —              | 390x390 | —       | [x]  | —   |
| [ ]     | fr57042mm               | —              | 390x390 | —       | [x]  | —   |
| [ ]     | instinct3amoled45mm     | —              | 390x390 | —       | [x]  | —   |
| [ ]     | instinctcrossoveramoled | —              | 390x390 | —       | [x]  | —   |
| [ ]     | marq2                   | —              | 390x390 | —       | [x]  | —   |
| [ ]     | marq2aviator            | —              | 390x390 | —       | [x]  | —   |
| [ ]     | venu3s                  | —              | 390x390 | —       | [x]  | —   |
| [ ]     | venu441mm               | —              | 390x390 | —       | [x]  | —   |
| [ ]     | vivoactive5             | —              | 390x390 | —       | [x]  | 5.2 |
| [ ]     | vivoactive6             | —              | 390x390 | —       | [x]  | 6.0 |
| [ ]     | d2airx10                | —              | 416x416 | —       | [x]  | —   |
| [ ]     | d2mach1                 | —              | 416x416 | —       | [x]  | —   |
| [ ]     | epix2                   | —              | 416x416 | —       | [x]  | —   |
| [ ]     | epix2pro47mm            | —              | 416x416 | —       | [x]  | —   |
| [x]     | fenix843mm              | venu2          | 416x416 | [ ]     | [x]  | 6.0 |
| [x]     | fenix943mm              | venu2          | 416x416 | [ ]     | [x]  | 6.0 |
| [x]     | fenix9pro43mm           | venu2          | 416x416 | [ ]     | [x]  | 6.0 |
| [ ]     | fenixe                  | —              | 416x416 | —       | [x]  | —   |
| [ ]     | fr265                   | —              | 416x416 | —       | [x]  | —   |
| [ ]     | instinct3amoled50mm     | —              | 416x416 | —       | [x]  | —   |
| [x]     | venu2                   | venu2          | 416x416 | [ ]     | [x]  | 5.0 |
| [ ]     | venu2plus               | —              | 416x416 | —       | [x]  | 5.0 |
| [ ]     | approachs7047mm         | —              | 454x454 | —       | [x]  | —   |
| [ ]     | d2mach2                 | —              | 454x454 | —       | [x]  | —   |
| [ ]     | d2mach2pro              | —              | 454x454 | —       | [x]  | —   |
| [ ]     | descentmk351mm          | —              | 454x454 | —       | [x]  | —   |
| [ ]     | epix2pro51mm            | —              | 454x454 | —       | [x]  | —   |
| [x]     | fr965                   | fr965          | 454x454 | [ ]     | [x]  | 5.2 |
| [x]     | fenix847mm              | fr965          | 454x454 | [ ]     | [x]  | 6.0 |
| [x]     | fenix8pro47mm           | fr965          | 454x454 | [ ]     | [x]  | 6.0 |
| [x]     | fenix947mm              | fr965          | 454x454 | [ ]     | [x]  | 6.0 |
| [x]     | fenix9pro47mm           | fr965          | 454x454 | [ ]     | [x]  | 6.0 |
| [ ]     | fr57047mm               | —              | 454x454 | —       | [x]  | —   |
| [ ]     | fr970                   | —              | 454x454 | —       | [x]  | 6.0 |
| [x]     | venu3                   | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | venu445mm               | —              | 454x454 | —       | [x]  | —   |
| [x]     | fenix9pro51mm           | fenix9pro51mm  | 466x466 | [ ]     | [x]  | 6.0 |

---

### Not present in this SDK reference

| Enabled | Device ID       | Base Impl | Screen | Low mem | OLED | API |
| ------- | --------------- | --------- | ------ | ------- | ---- | --- |
| [ ]     | approachs7247mm | —         | —      | —       | —    | —   |

### Excluded because to old SDK

_Unless requested by Community_

| Enabled | Device ID        | Base Impl | Screen  | Low mem | OLED | API |
| ------- | ---------------- | --------- | ------- | ------- | ---- | --- |
| [ ]     | fr45             | —         | 208x208 | —       | [ ]  | 1.4 |
| [ ]     | fr55             | —         | 208x208 | —       | [ ]  | 3.4 |
| [ ]     | garminswim2      | —         | 208x208 | —       | [ ]  | 1.4 |
| [ ]     | fenixchronos     | —         | 218x218 | —       | [ ]  | 3.1 |
| [ ]     | d2bravo          | —         | 218x218 | —       | [ ]  | —   |
| [ ]     | d2bravo_titanium | —         | 218x218 | —       | [ ]  | —   |
| [ ]     | fenix3           | —         | 218x218 | —       | [ ]  | 1.4 |
| [ ]     | fenix3_hr        | —         | 218x218 | —       | [ ]  | —   |
| [ ]     | bounce2          | —         | 390x390 | —       | [x]  | —   |
| [ ]     | venud            | —         | 390x390 | —       | [x]  | —   |
