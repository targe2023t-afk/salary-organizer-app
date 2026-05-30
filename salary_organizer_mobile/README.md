# Smart Salary Organizer Mobile App (تطبيق منظم الإنفاق الذكي)

This is a premium, cross-platform hybrid mobile application wrapper for the [Smart Salary Organizer](https://salary-organizer-499942098323.europe-west1.run.app) website. It has been built using **Flutter** and features custom network state handling, dynamic offline states, double-back tap to exit handling, and custom loading aesthetics.

هذا المشروع عبارة عن تطبيق موبايل هجين (Hybrid) عالي الأداء ومتوافق مع أنظمة Android و iOS، يقوم بتغليف موقع [منظّم الإنفاق الذكي للمرتب](https://salary-organizer-499942098323.europe-west1.run.app) باستخدام إطار العمل **Flutter**، مع دعم متكامل لحالة الشبكة، وشاشة انتظار مخصصة، وشاشة عدم وجود إنترنت، والتحكم بزر الرجوع.

---

## Features (الميزات)
*   **Hybrid / Cross-Platform (هايبرد / متعدد الأنظمة)**: Single codebase runs perfectly on both Android and iOS. (كود برمجي موحد يعمل على أندرويد وآيفون).
*   **Immersive Mode (وضع ملء الشاشة)**: Hides bulky browser controls, making it look 100% like a native app. (شاشات كاملة بدون أشرطة متصفح ليبدو كـ تطبيق أصلي تماماً).
*   **Offline Mode & Auto Reconnect (تتبع حالة الشبكة وإعادة الاتصال التلقائي)**: Detects internet drops and shows a beautiful retry interface. Reloads automatically when connection is restored. (كشف انقطاع الإنترنت وعرض شاشة إعادة محاولة أنيقة، مع تحديث تلقائي فور عودة الشبكة).
*   **Smart Back Button Handling (إدارة زر الرجوع للخلف)**: Pressing the physical back button on Android navigates backwards inside the website history rather than closing the app. Shows a confirmation dialog when exiting from the homepage. (الرجوع للخلف داخل صفحات الموقع عند ضغط زر الرجوع في أندرويد بدلاً من إغلاق التطبيق فجأة، مع إظهار نافذة تأكيد خروج عند الصفحة الرئيسية).
*   **Custom Loaders (مؤشرات تحميل مخصصة)**: Linear progress indicator at the top matching the app's color palette, combined with a modern custom overlay spinner for initial boot. (شريط تحميل علوي مع شاشة انتظار انسيابية أثناء الفتح الأول).
*   **Pull-to-Refresh Support (إعادة التحميل)**: Quick floating refresh button to update budget details manually. (زر عائم مخصص لإعادة تحميل الصفحة وتحديث بيانات الميزانية بسهولة).

---

## Getting Started (دليل البدء والتشغيل)

### 1. Requirements (المتطلبات الأساسية)
To run and build this application, you must have Flutter SDK installed on your system:
لكي تتمكن من تشغيل وبناء التطبيق، يجب تثبيت Flutter SDK على جهازك:

1.  **Download Flutter SDK**: Visit the [Official Flutter Installation Guide](https://docs.flutter.dev/get-started/install) and download the bundle matching your OS (Windows / macOS / Linux).
    (قم بتحميل Flutter من الموقع الرسمي واتبع خطوات التثبيت لنظام تشغيلك).
2.  **Android Studio / Xcode**:
    *   For Android: Install [Android Studio](https://developer.android.com/studio) and configure an Emulator or connect a real Android phone.
    *   For iOS: You need a macOS device with [Xcode](https://developer.apple.com/xcode/) installed.

---

### 2. How to Run the App (كيفية تشغيل التطبيق)

Follow these terminal commands inside the project directory:
اتبع هذه الأوامر في سطر الأوامر (Terminal) داخل مجلد المشروع:

```bash
# 1. Fetch package dependencies (تحميل مكتبات المشروع)
flutter pub get

# 2. Check if your development environment is fully ready (التحقق من جاهزية البيئة البرمجية)
flutter doctor

# 3. List connected devices / emulators (عرض الأجهزة المتصلة أو المحاكيات المتاحة)
flutter devices

# 4. Run the app in debug mode on a connected device (تشغيل التطبيق في وضع التطوير)
flutter run
```

---

### 3. How to Build Production App (كيفية بناء النسخة النهائية للنشر)

When your application is ready to be published or installed permanently:
عندما تريد بناء ملف التطبيق النهائي لتثبيته أو رفعه للمتاجر:

#### For Android (ملف APK للـ أندرويد):
Run the following command to generate a release APK:
قم بتشغيل الأمر التالي لإنتاج ملف APK محسن ومضغوط:
```bash
flutter build apk --release
```
The compiled file will be located at:
ستجد ملف التطبيق النهائي في المسار:
`build/app/outputs/flutter-apk/app-release.apk`

*Alternatively, build an App Bundle (`.aab`) for Google Play:*
```bash
flutter build appbundle --release
```

#### For iOS (ملف IPA للـ آيفون):
*(Requires macOS & Xcode)*
```bash
flutter build ipa --release
```

---

## Codebase Structure (هيكل المجلدات والكود)

-   [pubspec.yaml](file:///C:/Users/brand/.gemini/antigravity/scratch/salary_organizer_mobile/pubspec.yaml): Project dependencies and settings. (مكتبات وإعدادات المشروع).
-   [lib/main.dart](file:///C:/Users/brand/.gemini/antigravity/scratch/salary_organizer_mobile/lib/main.dart): Core Flutter container hosting the WebView, connection listener, custom alert dialogue, and offline UI. (الملف البرمجي الرئيسي الذي يحتوي على الـ WebView ومعالجات الشبكة والواجهة).
-   [android/](file:///C:/Users/brand/.gemini/antigravity/scratch/salary_organizer_mobile/android): Android-native codebase and manifest configurations. (إعدادات كود أندرويد وصلاحيات الإنترنت).
-   [ios/](file:///C:/Users/brand/.gemini/antigravity/scratch/salary_organizer_mobile/ios): iOS-native configurations and plist permissions. (إعدادات كود آيفون وصلاحيات الشبكة).
