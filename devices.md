# Enabled devices

### Round screens

Hardware specifications come from the bundled SDK 9.2.0 [Device Reference](~/AppData/Roaming/Garmin/ConnectIQ/Sdks/connectiq-sdk-win-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/Overview.html).

- **Enabled** means listed in `manifest.xml`; **Base Impl** is the resolved source mapping in `monkey.jungle`. A mapping alone does not establish compatibility.
- **Low mem** identifies this project’s low-memory implementation (`fenix5x`, `fenix6`, `fenix6x`, `vivoactive4s`, or `venu`), not a hardware RAM threshold. Unmapped devices are `—`.
- **OLED** is inferred from the reference’s 65,536-color round display specification; the pages do not explicitly name the panel technology.
- **API** records the device API version where known; `—` means it has not been recorded. The reference’s widget SDK note is not a watchface API version.
- Devices absent from this SDK’s reference are retained at the end with unverified specifications marked `—`.

| Enabled | Device ID               | Base Impl      | Screen  | Low mem | OLED | API |
| ------- | ----------------------- | -------------- | ------- | ------- | ---- | --- |
| [ ]     | fenix5s                 | vivoactive4s   | 218x218 | [x]     | [ ]  | 3.1 |
| [ ]     | fr255s                  | vivoactive4s\* | 218x218 | [x]     | [ ]  | 5.2 |
| [ ]     | fr255sm                 | vivoactive4s   | 218x218 | [x]     | [ ]  | 5.2 |
| [ ]     | legacyherocaptainmarvel | vivoactive4s   | 218x218 | [x]     | [ ]  | —   |
| [ ]     | legacysagarey           | vivoactive4s   | 218x218 | [x]     | [ ]  | —   |
| [ ]     | vivoactive4s            | vivoactive4s   | 218x218 | [x]     | [ ]  | 3.3 |
| [ ]     | approachs60             | fenix5x        | 240x240 | [x]     | [ ]  | 2.4 |
| [ ]     | d2charlie               | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | d2delta                 | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | d2deltapx               | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | d2deltas                | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | descentmk1              | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | descentmk2s             | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5                  | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5plus              | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5splus             | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5x                 | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix5xplus             | fenix5x        | 240x240 | [x]     | [ ]  | 3.3 |
| [ ]     | fenix6s                 | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fenix6spro              | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr245                   | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr245m                  | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr645                   | fenix5x        | 240x240 | [x]     | [ ]  | 3.1 |
| [ ]     | fr645m                  | fenix5x        | 240x240 | [x]     | [ ]  | 3.2 |
| [ ]     | fenix7s                 | fenix7s        | 240x240 | [ ]     | [ ]  | 5.2 |
| [ ]     | fenix7spro              | fenix7s        | 240x240 | [ ]     | [ ]  | 5.2 |
| [ ]     | fr745                   | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr935                   | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr945                   | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | fr945lte                | fenix5x        | 240x240 | [x]     | [ ]  | —   |
| [ ]     | marqadventurer          | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqathlete             | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqaviator             | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqcaptain             | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqcommander           | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqdriver              | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqexpedition          | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | marqgolfer              | fenix5x        | 240x240 | [x]     | [ ]  | 3.4 |
| [ ]     | vivoactive3             | fenix5x        | 240x240 | [x]     | [ ]  | 3.1 |
| [ ]     | vivoactive3d            | fenix5x        | 240x240 | [x]     | [ ]  | 3.0 |
| [ ]     | vivoactive3m            | fenix5x        | 240x240 | [x]     | [ ]  | 3.2 |
| [ ]     | vivoactive3mlte         | fenix5x        | 240x240 | [x]     | [ ]  | 3.1 |
| [ ]     | approachs62             | fenix6         | 260x260 | [x]     | [ ]  | 3.0 |
| [ ]     | fenix6                  | fenix6         | 260x260 | [x]     | [ ]  | 3.4 |
| [ ]     | fenix6pro               | fenix6         | 260x260 | [x]     | [ ]  | 3.4 |
| [ ]     | fenix7                  | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | fenix7pro               | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | fenix7pronowifi         | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | fenix8solar47mm         | fenix7         | 260x260 | [ ]     | [ ]  | 6.0 |
| [ ]     | fr255                   | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | fr255m                  | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | fr955                   | fenix7         | 260x260 | [ ]     | [ ]  | 5.2 |
| [ ]     | legacyherofirstavenger  | fenix6         | 260x260 | [x]     | [ ]  | 3.3 |
| [ ]     | legacysagadarthvader    | fenix6         | 260x260 | [x]     | [ ]  | 3.3 |
| [ ]     | vivoactive4             | fenix6         | 260x260 | [x]     | [ ]  | 3.3 |
| [ ]     | descentmk2              | fenix6x        | 280x280 | [x]     | [ ]  | —   |
| [ ]     | enduro                  | fenix6x        | 280x280 | [x]     | [ ]  | —   |
| [ ]     | enduro3                 | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [ ]     | fenix6xpro              | fenix6x        | 280x280 | [x]     | [ ]  | —   |
| [ ]     | fenix7x                 | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [ ]     | fenix7xpro              | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [ ]     | fenix7xpronowifi        | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [ ]     | fenix8solar51mm         | fenix7x        | 280x280 | [ ]     | [ ]  | —   |
| [ ]     | fr265s                  | venu2s         | 360x360 | [ ]     | [x]  | 5.2 |
| [ ]     | venu2s                  | venu2s         | 360x360 | [ ]     | [x]  | 5.0 |
| [ ]     | approachs50             | vivoactive6    | 390x390 | [ ]     | [x]  | 5.1 |
| [ ]     | approachs7042mm         | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | d2air                   | venu           | 390x390 | [x]     | [x]  | 3.2 |
| [ ]     | venu                    | venu           | 390x390 | [x]     | [x]  | 3.3 |
| [ ]     | descentg2               | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | descentmk343mm          | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | epix2pro42mm            | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | fr165                   | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | fr165m                  | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | fr57042mm               | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | instinct3amoled45mm     | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | instinctcrossoveramoled | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | marq2                   | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | marq2aviator            | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | venu3s                  | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | venu441mm               | vivoactive6    | 390x390 | [ ]     | [x]  | —   |
| [ ]     | vivoactive5             | vivoactive6    | 390x390 | [ ]     | [x]  | 5.2 |
| [ ]     | vivoactive6             | vivoactive6    | 390x390 | [ ]     | [x]  | 6.0 |
| [ ]     | d2airx10                | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | d2mach1                 | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | epix2                   | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | epix2pro47mm            | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | fenix843mm              | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | fenixe                  | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | fr265                   | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | instinct3amoled50mm     | venu2          | 416x416 | [ ]     | [x]  | —   |
| [ ]     | venu2                   | venu2          | 416x416 | [ ]     | [x]  | 5.0 |
| [ ]     | venu2plus               | venu2          | 416x416 | [ ]     | [x]  | 5.0 |
| [ ]     | approachs7047mm         | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | d2mach2                 | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | d2mach2pro              | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | descentmk351mm          | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | epix2pro51mm            | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | fr965                   | fr965          | 454x454 | [ ]     | [x]  | 5.2 |
| [ ]     | fenix847mm              | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | fenix8pro47mm           | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | fr57047mm               | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | fr970                   | fr965          | 454x454 | [ ]     | [x]  | 6.0 |
| [ ]     | venu3                   | fr965          | 454x454 | [ ]     | [x]  | —   |
| [ ]     | venu445mm               | fr965          | 454x454 | [ ]     | [x]  | —   |

---

\* - code is different / resources are from base

### Not present in this SDK reference

| Enabled | Device ID          | Base Impl | Screen | Low mem | OLED | API |
| ------- | ------------------ | --------- | ------ | ------- | ---- | --- |
| [ ]     | approachs7247mm    | fr965     | —      | [ ]     | —    | —   |
| [ ]     | fenix947mm         | fr965     | —      | [ ]     | —    | —   |
| [ ]     | fenix9pro47mm      | fr965     | —      | [ ]     | —    | —   |
| [ ]     | fenix9prosolar47mm | fenix7    | —      | [ ]     | —    | —   |

### Excluded because to old SDK

_Unless requested by Community_

| Enabled | Device ID        | Base Impl | Screen  | Low mem | OLED | API |
| ------- | ---------------- | --------- | ------- | ------- | ---- | --- |
| [ ]     | fr45             | —         | 208x208 | —       | [ ]  | 1.4 |
| [ ]     | fr55             | —         | 208x208 | —       | [ ]  | 3.4 |
| [ ]     | garminswim2      | —         | 208x208 | —       | [ ]  | 1.4 |
| [ ]     | fenixchronos     | —         | 218x218 | [x]     | [ ]  | 3.1 |
| [ ]     | d2bravo          | —         | 218x218 | —       | [ ]  | —   |
| [ ]     | d2bravo_titanium | —         | 218x218 | —       | [ ]  | —   |
| [ ]     | fenix3           | —         | 218x218 | —       | [ ]  | 1.4 |
| [ ]     | fenix3_hr        | —         | 218x218 | —       | [ ]  | —   |
| [ ]     | bounce2          | —         | 390x390 | —       | [x]  | —   |
| [ ]     | venud            | —         | 390x390 | —       | [x]  | —   |
