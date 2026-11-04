# Play Console answers

These answers are based on the code as of 2026-11-01. The app shows Google AdMob ads (banner on the tab screens, a full-screen ad when leaving mock-test results) and sells one non-consumable in-app product, `remove_ads`, through Google Play Billing. It asks Google's UMP consent form where the law requires it. Study progress and settings stay on the device in `shared_preferences`. If you add analytics or crash reporting later, revisit the Data safety section.

### Before the first release with ads
1. Create the app in AdMob (Android and iOS), plus a banner and an interstitial ad unit for each.
2. Paste the ad unit IDs into `lib/monetization/ad_ids.dart`, and the AdMob app IDs into `android/app/build.gradle.kts` and `ios/Runner/Info.plist`. Release builds show no ads while the unit IDs are empty.
3. In AdMob → Privacy & messaging, create a GDPR message (EU/UK) and, for iOS, an IDFA explainer message. The app shows whichever ones apply.
4. Host `app-ads.txt` (AdMob gives you the line) at the root of the developer website listed on the store page.
5. In Play Console → Monetize → Products → In-app products, create `remove_ads` (non-consumable) and set its price. Do the same in App Store Connect for iOS.
6. iOS: add Google's full SKAdNetwork list to `Info.plist` (only Google's own ID is there now).

## Store settings

| Field | Answer |
|---|---|
| App or game | App |
| Free or paid | **Free** (contains ads, offers in-app purchases) |
| Category | Education |
| Tags (pick up to 5 from Play's list) | Choose the closest to exam prep, study and reference |
| Contact email | _support address for Unity Wave Labs, required and shown publicly_ |
| Website | _optional_ |
| Default language | English (Canada) – en-CA |
| Translations | French (Canada) – fr-CA, from `listing-fr.md` |

## Graphics

| Asset | File |
|---|---|
| App icon 512×512 | `Downloads/citizenship-app-screens/citizenship-app-screens/identity/app-icon-lake-512.png` |
| Feature graphic 1024×500 | `…/identity/feature-graphic-1024x500.png` |
| Phone screenshots (2–8) | `…/store-screenshots/1-hero.png` to `6-english-french.png`, in that order |

The screenshots and feature graphic are in English. Play uses the English ones for the French listing unless you upload French versions.

## App content

### Privacy policy
Required for every app. Hosted on GitHub Pages from `docs/privacy-policy.html`: https://moosanaqviech.github.io/canadiancitizenship/privacy-policy.html. The link must open the policy text directly, with no sign-in or interstitial page (a claude.ai artifact link was rejected for this).

### Ads
**Yes, my app contains ads.**

### App access
**All functionality is available without special access.** (No login.)

### Content rating (IARC questionnaire)
- Category: **Reference, News, or Educational**
- Violence, sexuality, language, controlled substances, gambling, crude humour: **No** to all
- Users can interact or exchange content: **No**
- Shares user location: **No**
- Allows purchases of digital goods: **Yes** (one-time ad removal)
- Expected rating: Everyone / PEGI 3 / ESRB E

### Target audience and content
- Target age groups: **18 and over**. The knowledge test applies to applicants aged 18–54. Choosing only 18+ keeps the app out of the Families policy requirements.
- Appeals to children: **No**

### News app
**No**

### Government apps
**No, this app is not developed by or on behalf of a government.** The listing and the app's Settings both carry the independence notice. Reviewers look for this on government-adjacent topics.

### Financial features / Health apps
**My app doesn't provide any financial features.** Health: **None.**

### Data safety
| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **Yes** (through the Google Mobile Ads SDK) |
| Is all of the user data collected by your app encrypted in transit? | **Yes** |
| Do you provide a way for users to request that their data be deleted? | **No** (the app keeps no data off the device; users can reset their advertising ID in device settings) |

Data types to declare, all **collected and shared**, not required to be optional, purposes **Advertising or marketing**, **Analytics** and **Fraud prevention, security and compliance**:

| Category | Type |
|---|---|
| Location | Approximate location |
| App activity | App interactions |
| App info and performance | Crash logs, Diagnostics |
| Device or other IDs | Device or other IDs |

This follows Google's own disclosure for the Mobile Ads SDK; check it against the current version at developers.google.com/admob/android/privacy/play-data-disclosure before submitting. Progress and settings saved locally with `shared_preferences` still don't count as collected.

## Release

- Package name: `com.unitywavelabs.canada_citizenship` (permanent once uploaded)
- Version: `1.0.0+1`
- Build: `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`
- Signing: use Play App Signing; you need your own upload key configured in `android/` first

## App names on the device

- Home-screen label (`@string/app_name`): "Canadian Citizenship Test 2026" in English, "Examen de citoyenneté 2026" in French, the same as the store names. Some launchers will shorten them under the icon.
- In-app title (`appTitle`): "Canadian Citizenship Test 2026" / "Examen de citoyenneté 2026", the same as the store names.

---

# Privacy policy (draft)

**Canadian Citizenship Test 2026 — Privacy policy**
Last updated: _date you publish_

Canadian Citizenship Test 2026 ("the app") is published by Unity Wave Labs.

**What we collect.** We don't. The app doesn't ask for an account, and we never see your progress or answers. The app shows ads from Google AdMob, and Google collects some information to show and measure those ads (see below).

**What stays on your device.** Your lesson progress, quiz and mock-test scores, and your settings (language, text size, contrast) are saved only on your device so the app can remember where you left off. We can't see this information. Uninstalling the app, or clearing its storage, deletes it.

**Internet and permissions.** Lessons, quizzes and mock tests work without an internet connection. The app uses the internet only to load ads and to process the optional "Remove ads" purchase.

**Ads.** Ads are provided by Google AdMob. To show and measure ads and to prevent fraud, Google may collect your device's advertising ID, approximate location (from your IP address), and information about how ads are viewed and tapped. Where the law requires it, for example in the European Union and the United Kingdom, the app asks for your consent first, and you can change your choice at any time under Settings → Privacy choices. On iPhone, the app asks permission before your advertising identifier can be used. You can also reset or limit your advertising ID in your device's settings. Google's practices are described at policies.google.com/technologies/partner-sites.

**Purchases.** The "Remove ads" purchase is handled entirely by Google Play or the Apple App Store. We don't receive your payment details. The app only stores, on your device, that ads have been removed.

**Analytics and other third parties.** The app contains no analytics, and shares no data with third parties other than Google as described above.

**Children.** The app is intended for adults preparing for the Canadian citizenship test and is not directed at children.

**Changes.** If this policy changes, we'll update it here and change the date above.

**Contact.** _support email_

_The app is independent and is not affiliated with or endorsed by IRCC or the Government of Canada._
