<div align="center">

# 🌧️ xPsiphon

<div dir="rtl">

### یک پنل ترمینالی ساده برای اجرای چندین لوکیشن Psiphon روی یک سرور لینوکس

</div>
</div>

<div align="center">

[English](README.md) · **فارسی**

<br>

[![Version](https://img.shields.io/badge/version-2.0.0-2ea043?style=flat-square)](CHANGELOG.fa.md)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Ubuntu%20%2F%20Linux-e95420?style=flat-square)](#-قدم-۱--تهیه-یک-سرور)
[![Dependencies](https://img.shields.io/badge/python-3%20(no%20pip%20deps)-ffd343?style=flat-square)](#)
[![Locations](https://img.shields.io/badge/locations-AUTO%20%2B%2028%20countries-8957e5?style=flat-square)](#-لوکیشنها-و-پورتها)

</div>

---

<div dir="rtl">

## 💡 xPsiphon چیست؟

**xPsiphon یک سرور لینوکس را به مجموعه‌ای از پروکسی‌های Psiphon تبدیل می‌کند که می‌توانید همه را از یک منوی ساده کنترل کنید.**

‏Psiphon یک ابزار رایگان است که ترافیک شما را از طریق سرورهایی در سراسر دنیا تونل
می‌کند. xPsiphon روی سرور شما **برای هر کشور یک تونل Psiphon** اجرا می‌کند — همه
به‌صورت همزمان و هرکدام روی پورت جداگانه — و یک پنل ساده برای Start، Stop، مشاهده
و تست آن‌ها در اختیارتان می‌گذارد.

لازم نیست متخصص باشید. اگر بتوانید یک دستور را کپی و Paste کنید، می‌توانید نصبش
کنید. همه‌ی قدم‌های زیر برای کسی که بار اول است نوشته شده‌اند.

## 📑 فهرست مطالب

**از اینجا شروع کنید (گام‌به‌گام)**
- [قدم ۱ — تهیه یک سرور](#%EF%B8%8F-قدم-۱--تهیه-یک-سرور)
- [قدم ۲ — نصب xPsiphon](#-قدم-۲--نصب-xpsiphon)
- [قدم ۳ — اجرای یک لوکیشن](#%EF%B8%8F-قدم-۳--اجرای-یک-لوکیشن)

**استفاده‌ی روزمره**
- [منو (پنل تعاملی)](#%EF%B8%8F-منو-پنل-تعاملی)
- [جدول دستورات](#%EF%B8%8F-جدول-دستورات)
- [لوکیشن‌ها و پورت‌ها](#-لوکیشن%E2%80%8Cها-و-پورت%E2%80%8Cها)
- [تغییر پورت یک لوکیشن](#-تغییر-پورت-یک-لوکیشن)
- [لاگ‌ها](#-لاگ%E2%80%8Cها)
- [فایروال و پورت‌های باز](#-فایروال-و-پورت%E2%80%8Cهای-باز)
- [تست پینگ و سرعت](#-تست-پینگ-و-سرعت)
- [اجرای خودکار هنگام بوت](#-اجرای-خودکار-هنگام-بوت)

**نگهداری**
- [بروزرسانی](#%EF%B8%8F-بروزرسانی)
- [حذف نصب](#%EF%B8%8F-حذف-نصب)
- [مسیرها](#%EF%B8%8F-مسیرها)
- [رفع اشکال](#-رفع-اشکال)

**درباره**
- [امکانات](#-امکانات)
- [اعتبارها](#-اعتبارها) · [حمایت مالی](#-حمایت-مالی) · [مجوز](#-مجوز)

</div>

---

<div dir="rtl">

## 🖥️ قدم ۱ — تهیه یک سرور

شما به یک سرور کوچک لینوکسی (یک «VPS») نیاز دارید. تقریباً هر سرور ارزانی کار می‌کند.

- **سیستم‌عامل:** ‏Ubuntu 22 یا 24 (پیشنهادی). هر لینوکس جدیدی که `systemd` داشته
  باشد هم خوب است.
- **اندازه:** کوچک‌ترین پلن کافی است (۱ CPU / ۵۱۲ مگابایت RAM جواب می‌دهد).
- **دسترسی:** به‌عنوان `root` (یا کاربری با `sudo`) وارد می‌شوید.

</div>

> ```bash
> ssh root@YOUR_SERVER_IP
> ```

<div dir="rtl">

وقتی خط فرمان سرور را دیدید، به قدم ۲ بروید.

## 📥 قدم ۲ — نصب xPsiphon

این **خط** را کپی کنید، در سرور Paste کنید و Enter بزنید:

</div>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

<div dir="rtl">

همین. نصب‌کننده همه‌ی کارها را برایتان انجام می‌دهد:

- ✅ در صورت نبود، `curl`، `ca-certificates` و `python3` را نصب می‌کند
- ✅ موتور هسته‌ی Psiphon را دانلود می‌کند
- ✅ دستور `xpsiphon` **و** میانبر کوتاه `xp` را نصب می‌کند
- ✅ همه‌ی کانفیگ‌های لوکیشن را می‌سازد (`AUTO` + ۲۸ کشور)
- ✅ پوشه‌های لاگ، دیتا و run را ایجاد می‌کند

بعد از پایان، درستی نصب را بررسی کنید:

</div>

```bash
xp version      # باید چاپ کند: xPsiphon 2.0.0
xp doctor       # باید خط‌های سبز OK نشان دهد
```

<div dir="rtl">

> 💡 **می‌خواهید در هر ری‌استارت خودکار اجرا شود؟** به دستور نصب `--enable-autostart`
> اضافه کنید، یا بعداً با `sudo xp autostart on` تنظیمش کنید.

## ▶️ قدم ۳ — اجرای یک لوکیشن

ساده‌ترین انتخاب `AUTO` است که اجازه می‌دهد Psiphon بهترین سرور را برایتان انتخاب کند:

</div>

```bash
sudo xp start AUTO
```

<div dir="rtl">

بررسی کنید که در حال اجراست:

</div>

```bash
xp status
```

<div dir="rtl">

یک کشور خاص می‌خواهید؟ از کد دوحرفی‌اش استفاده کنید (به
[فهرست کامل](#-لوکیشنها-و-پورتها) نگاه کنید):

</div>

```bash
sudo xp start US      # ایالات متحده
sudo xp start DE      # آلمان
sudo xp start all     # اجرای همه‌ی لوکیشن‌ها با هم
```

<div dir="rtl">

هر لوکیشن روی **پورت‌های محلی مخصوص خودش** listen می‌کند. برای مثال:

</div>

```text
AUTO  →  SOCKS 127.0.0.1:1080   |  HTTP 127.0.0.1:8080
US    →  SOCKS 127.0.0.1:1101   |  HTTP 127.0.0.1:8101
```

<div dir="rtl">

## 🎛️ منو (پنل تعاملی)

منو را به تایپ دستور ترجیح می‌دهید؟ کافی است اجرا کنید:

</div>

```bash
xp
```

<div dir="rtl">

یک پنل می‌گیرید که با یک کلید می‌توانید:

- 📊 وضعیت کامل را ببینید
- ▶️ لوکیشن `AUTO` را اجرا کنید، یا لوکیشن انتخابی را Start / Stop / Restart کنید
- ⏯️ همه را Start / همه را Stop کنید
- 📜 لاگ یک لوکیشن را زنده دنبال کنید
- 🔁 وضعیت autostart را تغییر دهید
- 🔧 پورت SOCKS/HTTP یک لوکیشن را عوض کنید
- 🧱 بررسی فایروال و پورت‌های باز را اجرا کنید
- 📶 تست پینگ و سرعت بگیرید
- 🩺 بررسی‌های doctor را اجرا کنید
- ⬆️ xPsiphon را بروزرسانی کنید
- 🗑️ xPsiphon را حذف کنید

دستورهای `xpsiphon` و `xp` یکی هستند — هرکدام را دوست دارید استفاده کنید.

## ⌨️ جدول دستورات

| دستور | چه کاری می‌کند |
| --- | --- |
| `xp` | باز کردن منوی تعاملی |
| `xp status` | نمایش وضعیت سرور و همه‌ی Instanceهای Psiphon |
| `xp locations` | فهرست لوکیشن‌ها، پورت‌ها و مسیر کانفیگ‌ها |
| `sudo xp start AUTO` | اجرای لوکیشن اتوماتیک |
| `sudo xp start US` | اجرای یک کشور |
| `sudo xp start all` | اجرای همه‌ی لوکیشن‌ها |
| `sudo xp stop US` | توقف یک لوکیشن |
| `sudo xp stop all` | توقف همه‌ی لوکیشن‌ها |
| `sudo xp restart US` | ری‌استارت یک لوکیشن |
| `xp logs US` | نمایش آخرین خطوط لاگ یک لوکیشن |
| `xp logs US -f` | دنبال کردن زنده‌ی لاگ یک لوکیشن |
| `sudo xp port US --socks 1201 --http 8201` | تغییر پورت‌های یک لوکیشن |
| `xp firewall` | بررسی پورت‌های محلی + UFW/firewalld |
| `xp ports` | میانبر برای `xp firewall` |
| `xp test` | تست همه‌ی لوکیشن‌های در حال اجرا |
| `xp test AUTO` | تست یک لوکیشن |
| `xp speed US` | میانبر برای `xp test US` |
| `xp doctor` | بررسی پیش‌نیازها و سلامت نصب |
| `sudo xp autostart on` / `off` | فعال / غیرفعال کردن اجرای هنگام بوت |
| `xp autostart status` | نمایش وضعیت autostart |
| `sudo xp update` | بروزرسانی درجا (حفظ کانفیگ‌ها و تونل‌های در حال اجرا) |
| `sudo xp uninstall` | حذف xPsiphon (حفظ کانفیگ‌ها و باینری) |
| `sudo xp uninstall --purge` | حذف **همه‌چیز** |
| `xp version` | نمایش نسخه‌ی نصب‌شده |

> 🔐 کارهایی که چیزی را Start/Stop می‌کنند یا سیستم را تغییر می‌دهند به `sudo` نیاز
> دارند. کارهای فقط‌خواندنی (`status`، `locations`، `logs`، `test`، `doctor`) نیازی
> ندارند.

## 🌍 لوکیشن‌ها و پورت‌ها

‏`AUTO` از انتخاب خودکار سرور توسط Psiphon استفاده می‌کند:

</div>

```text
AUTO SOCKS: 127.0.0.1:1080     AUTO HTTP: 127.0.0.1:8080
```

<div dir="rtl">

هر کشور روی پورت‌های **یکتا و ثابت** خودش اجرا می‌شود تا همه بتوانند با هم اجرا شوند:

</div>

```text
AT SOCKS 1081 / HTTP 8081     JP SOCKS 1095 / HTTP 8095
BE SOCKS 1082 / HTTP 8082     NL SOCKS 1096 / HTTP 8096
BG SOCKS 1083 / HTTP 8083     NO SOCKS 1097 / HTTP 8097
CA SOCKS 1084 / HTTP 8084     PL SOCKS 1098 / HTTP 8098
CH SOCKS 1085 / HTTP 8085     RO SOCKS 1099 / HTTP 8099
CZ SOCKS 1086 / HTTP 8086     SE SOCKS 1100 / HTTP 8100
DE SOCKS 1087 / HTTP 8087     US SOCKS 1101 / HTTP 8101
DK SOCKS 1088 / HTTP 8088     AU SOCKS 1102 / HTTP 8102
EE SOCKS 1089 / HTTP 8089     ES SOCKS 1103 / HTTP 8103
FI SOCKS 1090 / HTTP 8090     ID SOCKS 1104 / HTTP 8104
FR SOCKS 1091 / HTTP 8091     IE SOCKS 1105 / HTTP 8105
GB SOCKS 1092 / HTTP 8092     LT SOCKS 1106 / HTTP 8106
IN SOCKS 1093 / HTTP 8093     RS SOCKS 1107 / HTTP 8107
IT SOCKS 1094 / HTTP 8094     SG SOCKS 1108 / HTTP 8108
```

<div dir="rtl">

فهرست کشورها (**۲۸ Egress Region**) با **کلاینت زنده‌ی Psiphon** راستی‌آزمایی شده
است — همان مجموعه‌ای که `psiphon-tunnel-core` در نوتیس `AvailableEgressRegions`
روی همین Propagation Channel گزارش می‌کند.

> 🧩 **لوکیشن‌های Legacy:** ‏`BG` (بلغارستان) و `EE` (استونی) برای سازگاری با
> نسخه‌های قبلی نگه داشته شده‌اند اما در مجموعه‌ی زنده‌ی فعلی حضور نداشتند. اگر
> استفاده نشوند بی‌ضررند — یک Region ثابت بدون سرور در دسترس، به‌سادگی وصل نمی‌شود.
> برای حذفشان فایل‌های `/etc/psiphon/configs/psiphon.BG.config` و
> `/etc/psiphon/configs/psiphon.EE.config` را پاک کنید.

> 🔒 **پورت‌ها در بروزرسانی‌ها ثابت می‌مانند.** لوکیشن‌های جدید همیشه پورت آزاد
> بعدی را می‌گیرند و پورت لوکیشن‌های موجود تغییر نمی‌کند، بنابراین Ruleهای فایروال
> شما بعد از بروزرسانی همچنان کار می‌کنند.

## 🔧 تغییر پورت یک لوکیشن

پورت هر لوکیشن در فایل کانفیگ خودش قرار دارد. اگر یک پورت پیش‌فرض روی سرور شما اشغال
شده باشد (مثلاً چیز دیگری از `1092` استفاده می‌کند)، آن را دوباره تخصیص دهید:

</div>

```bash
sudo xp port GB --socks 1201 --http 8201
sudo xp port GB --socks 1201          # فقط SOCKS عوض شود، HTTP بماند
```

<div dir="rtl">

این کار از داخل پنل هم با گزینه‌ی `p) Change location port` امکان‌پذیر است.
xPsiphon پورت‌هایی را که با لوکیشن دیگری تداخل دارند یا خارج از محدوده هستند رد
می‌کند. اگر لوکیشن در حال اجراست، برای اعمال تغییر آن را ری‌استارت کنید:

</div>

```bash
sudo xp restart GB
```

<div dir="rtl">

## 📜 لاگ‌ها

هر لوکیشن فایل لاگ جداگانه‌ی خودش را می‌نویسد:

</div>

```text
/var/log/xpsiphon/psiphon.AUTO.log
/var/log/xpsiphon/psiphon.US.log
```

<div dir="rtl">

مشاهده‌ی آن‌ها:

</div>

```bash
xp logs AUTO       # آخرین خطوط
xp logs US -f      # دنبال کردن زنده (با Ctrl-C متوقف کنید)
```

<div dir="rtl">

## 🧱 فایروال و پورت‌های باز

بررسی اینکه کدام پورت‌ها listen هستند و فایروال شما چه چیزی را اجازه می‌دهد:

</div>

```bash
xp firewall
```

<div dir="rtl">

این بررسی نشان می‌دهد:

- هر پورت SOCKS/HTTP آزاد است یا در حال listen
- وضعیت UFW و Ruleهای allow مرتبط
- وضعیت firewalld و پورت‌های مجاز

</div>

<div dir="rtl">

## 📶 تست پینگ و سرعت

تست لوکیشن‌های در حال اجرا از طریق پروکسی SOCKS:

</div>

```bash
xp test           # تست همه‌ی لوکیشن‌های در حال اجرا
xp test AUTO      # تست یکی
xp speed US       # میانبر برای: xp test US
```

<div dir="rtl">

فقط لوکیشن‌های **در حال اجرا** قابل تست هستند. یک لوکیشن متوقف `not listening` نشان
می‌دهد.

گزینه‌ها:

</div>

```bash
xp test AUTO --no-speed
xp test US --timeout 30
xp test AUTO --url https://www.gstatic.com/generate_204
xp test AUTO --speed-url https://speed.cloudflare.com/__down?bytes=1048576
```

<div dir="rtl">

> ℹ️ مقدار «ping» در اینجا تأخیر درخواست HTTPS **از داخل پروکسی** است، نه ICMP ping.

## 🔁 اجرای خودکار هنگام بوت

xPsiphon هنگام ری‌استارت سرور، همه‌ی لوکیشن‌های کانفیگ‌شده را خودکار
اجرا میکند:

</div>

```bash
sudo xp autostart on       # فعال‌سازی
sudo xp autostart off      # غیرفعال‌سازی
xp autostart status        # بررسی
systemctl status xpsiphon.service
```

<div dir="rtl">

## ⬆️ بروزرسانی

بروزرسانی یک نصب موجود به آخرین نسخه:

</div>

```bash
sudo xp update
```

<div dir="rtl">

**بروزرسانی به‌صورت پیش‌فرض بدون اختلال است** — یک سرور در حال کار به کارش ادامه می‌دهد:

- ✅ کانفیگ‌های موجود شما حفظ می‌شوند، **شامل پورت‌های سفارشی**
- ✅ باینری هسته‌ی Psiphon همان‌طور که هست می‌ماند (دوباره دانلود نمی‌شود)
- ✅ تونل‌های در حال اجرا متوقف **نمی‌شوند**؛ وضعیت autostart تغییر **نمی‌کند**
- ✅ فقط کانفیگ‌های لوکیشن‌های **جدید** اضافه می‌شوند

لوکیشن‌های جدید اضافه می‌شوند اما خودکار اجرا نمی‌شوند. هر وقت آماده بودید اجرا کنید:

</div>

```bash
sudo xp start all
```

<div dir="rtl">

بازسازی‌های اختیاری و انتخابی (این‌ها *می‌توانند* اختلال ایجاد کنند):

</div>

```bash
sudo xp update --force-psiphon    # دانلود دوباره‌ی باینری هسته
sudo xp update --force-configs    # بازنویسی کانفیگ‌ها (پورت‌های سفارشی ریست می‌شوند)
```

<div dir="rtl">

از داخل پنل هم (گزینه‌ی `u) Update xPsiphon`) یا با اجرای دوباره‌ی نصب‌کننده‌ی
یک‌خطی می‌توانید بروزرسانی کنید — رفتارش به همین شکل امن است.

> 📝 دستور `xp update` از شاخه‌ی `main` در گیت‌هاب واکشی می‌کند. برای دیدن تغییرات
> بین نسخه‌ها به [CHANGELOG](CHANGELOG.fa.md) نگاه کنید.

## 🗑️ حذف نصب

حذف xPsiphon با یک دستور:

</div>

```bash
sudo xp uninstall
```

<div dir="rtl">

این کار همه‌ی لوکیشن‌ها را متوقف می‌کند، سرویس `xpsiphon.service` را غیرفعال و حذف
می‌کند، دستورهای `xpsiphon` و `xp` را برمی‌دارد و مسیرهای زمان اجرا
(`/run/xpsiphon`، `/var/log/xpsiphon`، `/tmp/psiphon`) را پاک می‌کند. کانفیگ‌ها و
باینری Psiphon در `/etc/psiphon` به‌صورت پیش‌فرض **نگه داشته می‌شوند**.

حذف **همه‌چیز**، شامل کانفیگ‌ها و باینری:

</div>

```bash
sudo xp uninstall --purge
```

<div dir="rtl">

رد شدن از مرحله‌ی تأیید (برای اسکریپت‌ها):

</div>

<div dir="ltr">

```bash
sudo xp uninstall --yes
sudo xp uninstall --purge --yes
```

</div>

<div dir="rtl">

از داخل پنل هم با گزینه‌ی `x) Uninstall xPsiphon` می‌توانید حذف کنید.

<details>
<summary>پاک‌سازی دستی (اگر دستور <code>xp</code> از قبل حذف شده باشد)</summary>

<div dir="ltr">

```bash
sudo systemctl disable --now xpsiphon.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/xpsiphon.service
sudo systemctl daemon-reload 2>/dev/null || true
sudo rm -f /usr/local/bin/xpsiphon /usr/local/bin/xp
sudo rm -rf /run/xpsiphon /var/log/xpsiphon /tmp/psiphon
sudo rm -rf /etc/psiphon   # فقط اگر می‌خواهید کانفیگ‌ها و باینری هم حذف شوند
```

</div>
</details>

## 🗂️ مسیرها

مسیرهای پیش‌فرض:

</div>


```text
Psiphon binary: /etc/psiphon/psiphon-tunnel-core-x86_64
Configs:        /etc/psiphon/configs
Data roots:     /tmp/psiphon
Logs:           /var/log/xpsiphon
PID files:      /run/xpsiphon
Systemd unit:   /etc/systemd/system/xpsiphon.service
```

<div dir="rtl">

‏Overrideهای زمان اجرا (متغیرهای محیطی):

</div>

```bash
XPSIPHON_BIN=/path/to/psiphon-tunnel-core-x86_64
XPSIPHON_CONF_DIR=/path/to/configs
XPSIPHON_DATA_DIR=/path/to/data
XPSIPHON_LOG_DIR=/path/to/logs
XPSIPHON_RUN_DIR=/path/to/run
XPSIPHON_SERVICE_PATH=/etc/systemd/system/xpsiphon.service
```

<div dir="rtl">

‏Overrideهای نصب‌کننده:

</div>

```bash
XPSIPHON_INSTALL_PATH=/usr/local/bin/xpsiphon
XPSIPHON_SHORT_PATH=/usr/local/bin/xp
XPSIPHON_GITHUB_REPO=IzumiRain/xPsiphon
XPSIPHON_GITHUB_REF=main
```

<div dir="rtl">

## 🩹 رفع اشکال

<details>
<summary><code>Psiphon binary not found</code></summary>

نصب‌کننده‌ی Bootstrap را دوباره اجرا کنید:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

</details>

<details>
<summary>نمایش <code>not listening</code> در تست سرعت</summary>

اول لوکیشن را اجرا کنید، بعد تستش کنید:

```bash
sudo xp start AUTO
xp test AUTO
```

</details>

<details>
<summary>خطاهای Permission</summary>

عملیات Start، Stop، Restart و autostart به root نیاز دارند:

```bash
sudo xp start AUTO
sudo xp stop all
```

</details>

<details>
<summary>بررسی سلامت کلی</summary>

```bash
xp doctor
xp status
xp locations
```

</details>

## ✨ امکانات

- نصب یک‌خطی روی سرور Ubuntu خام
- پنل ترمینالی تعاملی
- دستور کوتاه `xp`
- لوکیشن `AUTO` روی SOCKS `1080` / HTTP `8080`
- **۲۸** لوکیشن کشوری روی پورت‌های یکتا (راستی‌آزمایی‌شده با کلاینت زنده)
- پورت SOCKS/HTTP قابل‌تغییر برای هر لوکیشن (از CLI یا پنل)
- Start / Stop / Restart برای یک لوکیشن یا همه‌ی لوکیشن‌ها
- نمای وضعیت کامل سرور و مصرف CPU/RAM هر پروسه‌ی Psiphon
- فایل لاگ جداگانه برای هر لوکیشن
- بررسی فایروال و پورت‌های باز برای UFW و firewalld
- تست پینگ و سرعت دانلود هر لوکیشن از طریق SOCKS
- بروزرسانی درجای امن و بدون اختلال
- حذف تمیز (با گزینه‌ی purge اختیاری)
- اجرای خودکار اختیاری با `systemd`
- **بدون نیاز به هیچ پکیج Python**

## 🙌 اعتبارها

- پنل مدیریتی xPsiphon — [IzumiRain](https://github.com/IzumiRain)
- باینری Psiphon tunnel core — [Psiphon-Labs](https://github.com/Psiphon-Labs)
- پروژه‌ی مرجع Psiphon Linux — [SpherionOS/PsiphonLinux](https://github.com/SpherionOS/PsiphonLinux)

## 💖 حمایت مالی

اگر xPsiphon برای شما مفید بوده است، حمایت مالی شما ارزشمند است 🙏

| شبکه | آدرس |
| --- | --- |
| **TRC20** (Tron) | `TKBHWNoeygcaCK8N78e7dQX5Yco3WTb6ZN` |
| **BEP20** (BNB Smart Chain) | `0x0F982640a69D3B9FB944840D7DA8bECCfcF0bb9E` |
| **TON** | `UQAyLUyxew-eggwhxbzsAZZZ9ULM8MYOk-3IXFh7tNC33LNt` |

## 📄 مجوز

[MIT](LICENSE) © IzumiRain

</div>

<div align="center">

<sub>
ساخته‌شده با ❤️ توسط <a href="https://github.com/IzumiRain">IzumiRain</a><br>
<a href="README.md">English</a> · <a href="CHANGELOG.fa.md">تغییرات</a>
</sub>

</div>
