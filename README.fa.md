# xPsiphon

[English](README.md) | فارسی

xPsiphon یک پنل مدیریتی ترمینالی برای اجرا و مانیتور کردن چندین لوکیشن Psiphon روی سرور Ubuntu است. این ابزار هسته Psiphon را نصب می‌کند، کانفیگ‌های لوکیشن‌ها را می‌سازد، برای هر لوکیشن یک پروسه جدا اجرا می‌کند، لاگ جداگانه نگه می‌دارد، وضعیت سرور و مصرف پروسه‌ها را نشان می‌دهد، پورت‌های فایروال را بررسی می‌کند، تست تأخیر/سرعت تونل را انجام می‌دهد و می‌تواند اجرای خودکار هنگام بوت را با `systemd` فعال کند.

مدیر اصلی یک اسکریپت Python 3 بدون وابستگی خارجی است. نصب‌کننده Bootstrap با Bash نوشته شده است.


## پیش‌نیازها

- Ubuntu 24 یا یک سرور لینوکسی جدید با `systemd`
- دسترسی root یا sudo
- وجود `curl` برای دستور نصب یک‌خطی

نصب‌کننده وابستگی‌های لازم مثل `python3` را نصب می‌کند، باینری هسته Psiphon را دانلود می‌کند، کانفیگ‌ها را می‌سازد و هر دو دستور `xpsiphon` و `xp` را نصب می‌کند.

## نصب یک‌خطی

دستور زیر را کپی و اجرا کنید:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

نصب‌کننده این کارها را انجام می‌دهد:

- نصب `curl`، `ca-certificates` و `python3` در صورت نیاز
- دانلود `psiphon-tunnel-core-x86_64`
- نصب `xpsiphon` در `/usr/local/bin/xpsiphon`
- نصب `xp` در `/usr/local/bin/xp`
- ساخت `/etc/psiphon/configs`
- ساخت کانفیگ `AUTO` و کانفیگ‌های کشورها
- ساخت مسیرهای دیتا، run و لاگ

فعال‌سازی Autostart هنگام نصب:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh) --enable-autostart
```

## امکانات

- نصب یک‌خطی روی سرور Ubuntu خام
- پنل ترمینالی تعاملی با خروجی رنگی و خوانا
- دستور کوتاه `xp`
- لوکیشن `AUTO` روی SOCKS `1080` و HTTP `8080`
- کانفیگ‌های چندلوکیشنی کشورها با پورت‌های جداگانه
- Start، Stop و Restart برای یک لوکیشن یا همه لوکیشن‌ها
- نمایش وضعیت کامل سرور و مصرف CPU/RAM مربوط به Psiphon
- لاگ جداگانه برای هر لوکیشن
- بررسی فایروال و پورت‌های باز برای UFW و firewalld
- تست پینگ و سرعت دانلود هر لوکیشن از طریق SOCKS
- Autostart اختیاری با `systemd`
- بدون نیاز به پکیج Python خارجی


## نصب محلی

از داخل نسخه Clone شده پروژه:

```bash
sudo bash install.sh
```

گزینه‌های نصب‌کننده:

```bash
sudo bash install.sh --force-configs
sudo bash install.sh --force-psiphon
sudo bash install.sh --enable-autostart
sudo bash install.sh --no-configs
sudo bash install.sh --skip-psiphon
```

## شروع سریع

باز کردن پنل:

```bash
xpsiphon
```

یا:

```bash
xp
```

اجرای لوکیشن اتوماتیک:

```bash
sudo xp start AUTO
```

اجرای همه لوکیشن‌های ساخته‌شده:

```bash
sudo xp start all
```

بررسی وضعیت:

```bash
xp status
```

مشاهده زنده لاگ‌ها:

```bash
xp logs AUTO -f
```

## راهنمای دستورات

| دستور | توضیح |
| --- | --- |
| `xp` | باز کردن پنل ترمینالی تعاملی |
| `xp status` | نمایش وضعیت سرور و همه Instanceهای Psiphon |
| `xp locations` | نمایش لوکیشن‌ها، پورت‌ها و مسیر کانفیگ‌ها |
| `sudo xp start AUTO` | اجرای لوکیشن اتوماتیک Psiphon |
| `sudo xp start US` | اجرای یک لوکیشن کشور مشخص |
| `sudo xp start all` | اجرای همه لوکیشن‌های کانفیگ‌شده |
| `sudo xp stop US` | توقف یک لوکیشن |
| `sudo xp stop all` | توقف همه لوکیشن‌ها |
| `sudo xp restart US` | ری‌استارت یک لوکیشن |
| `xp logs US` | نمایش آخرین خطوط لاگ یک لوکیشن |
| `xp logs US -f` | دنبال کردن زنده لاگ یک لوکیشن |
| `xp firewall` | بررسی پورت‌های محلی و وضعیت UFW/firewalld |
| `xp ports` | میانبر برای `xp firewall` |
| `xp test` | تست همه لوکیشن‌های در حال اجرا از طریق SOCKS |
| `xp test AUTO` | تست یک لوکیشن |
| `xp speed US` | میانبر برای `xp test US` |
| `xp doctor` | بررسی پیش‌نیازها و وضعیت نصب |
| `sudo xp autostart on` | فعال‌سازی اجرای خودکار هنگام بوت |
| `sudo xp autostart off` | غیرفعال‌سازی اجرای خودکار هنگام بوت |
| `xp autostart status` | نمایش وضعیت Autostart |

`xpsiphon` و `xp` معادل هم هستند.

## پنل تعاملی

اجرا کنید:

```bash
xp
```

گزینه‌های پنل:

- وضعیت کامل
- اجرای AUTO
- start/stop/restart لوکیشن انتخابی
- start all / stop all
- مشاهده لاگ‌ها
- تغییر وضعیت autostart
- بررسی فایروال و پورت‌های باز
- تست پینگ/سرعت
- بررسی‌های doctor

## پورت‌ها و لوکیشن‌ها

`AUTO` از انتخاب خودکار سرور توسط Psiphon استفاده می‌کند:

```text
AUTO SOCKS: 127.0.0.1:1080
AUTO HTTP:  127.0.0.1:8080
```

کانفیگ‌های کشورها پورت‌های ترتیبی و جداگانه دارند تا چندین لوکیشن بتوانند همزمان اجرا شوند:

```text
AT SOCKS 1081 / HTTP 8081
BE SOCKS 1082 / HTTP 8082
BG SOCKS 1083 / HTTP 8083
CA SOCKS 1084 / HTTP 8084
CH SOCKS 1085 / HTTP 8085
...
US SOCKS 1101 / HTTP 8101
```

کانفیگ‌های ساخته‌شده:

```text
/etc/psiphon/configs/psiphon.AUTO.config
/etc/psiphon/configs/psiphon.**.config
```

## مسیرها

مسیرهای پیش‌فرض:

```text
Psiphon binary: /etc/psiphon/psiphon-tunnel-core-x86_64
Configs:        /etc/psiphon/configs
Data roots:     /tmp/psiphon
Logs:           /var/log/xpsiphon
PID files:      /run/xpsiphon
Systemd unit:   /etc/systemd/system/xpsiphon.service
```

Overrideهای زمان اجرا:

```bash
XPSIPHON_BIN=/path/to/psiphon-tunnel-core-x86_64
XPSIPHON_CONF_DIR=/path/to/configs
XPSIPHON_DATA_DIR=/path/to/data
XPSIPHON_LOG_DIR=/path/to/logs
XPSIPHON_RUN_DIR=/path/to/run
XPSIPHON_SERVICE_PATH=/etc/systemd/system/xpsiphon.service
```

Overrideهای نصب‌کننده:

```bash
XPSIPHON_INSTALL_PATH=/usr/local/bin/xpsiphon
XPSIPHON_SHORT_PATH=/usr/local/bin/xp
XPSIPHON_GITHUB_REPO=IzumiRain/xPsiphon
XPSIPHON_GITHUB_REF=main
```

## لاگ‌ها

هر لوکیشن لاگ جداگانه دارد:

```text
/var/log/xpsiphon/psiphon.AUTO.log
/var/log/xpsiphon/psiphon.**.log
```

مشاهده لاگ‌ها:

```bash
xp logs AUTO
xp logs US -f
```

## فایروال و پورت‌های باز

بررسی وضعیت پورت‌های محلی و فایروال‌های رایج لینوکس:

```bash
xp firewall
```

این بررسی نشان می‌دهد:

- هر پورت SOCKS/HTTP آزاد است یا در حال listen
- وضعیت UFW و Ruleهای allow مرتبط
- وضعیت firewalld و پورت‌های مجاز
- نمونه دستور برای باز کردن پورت‌ها فقط برای IPهای قابل اعتماد

نکته امنیتی: پورت‌های پروکسی را فقط برای IPهای قابل اعتماد باز کنید. باز کردن پورت‌های پروکسی برای کل اینترنت توصیه نمی‌شود.

نمونه Ruleهای UFW برای یک IP قابل اعتماد:

```bash
sudo ufw allow from YOUR_IP to any port 1080:1101 proto tcp
sudo ufw allow from YOUR_IP to any port 8080:8101 proto tcp
```

## تست پینگ و سرعت

تست لوکیشن‌های در حال اجرا از طریق پروکسی SOCKS:

```bash
xp test
xp test AUTO
xp speed US
```

فقط لوکیشن‌های در حال اجرا قابل تست هستند. اگر یک لوکیشن متوقف باشد، نتیجه `not listening` نمایش داده می‌شود.

گزینه‌ها:

```bash
xp test AUTO --no-speed
xp test US --timeout 30
xp test AUTO --url https://www.gstatic.com/generate_204
xp test AUTO --speed-url https://speed.cloudflare.com/__down?bytes=1048576
```

مقدار ping در این بخش تأخیر درخواست HTTPS از داخل پروکسی است، نه ICMP ping.

## Autostart

فعال‌سازی xPsiphon هنگام بوت:

```bash
sudo xp autostart on
```

غیرفعال‌سازی:

```bash
sudo xp autostart off
```

بررسی:

```bash
xp autostart status
systemctl status xpsiphon.service
```

این سرویس هنگام بوت همه لوکیشن‌های کانفیگ‌شده را اجرا می‌کند و هنگام توقف سرویس، آن‌ها را متوقف می‌کند.

## بروزرسانی یا نصب دوباره

نصب‌کننده را دوباره اجرا کنید:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

بازسازی اجباری کانفیگ‌های ساخته‌شده:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh) --force-configs
```

دانلود دوباره باینری هسته Psiphon:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh) --force-psiphon
```

## حذف نصب

```bash
sudo systemctl disable --now xpsiphon.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/xpsiphon.service
sudo systemctl daemon-reload 2>/dev/null || true
sudo rm -f /usr/local/bin/xpsiphon /usr/local/bin/xp
sudo rm -rf /run/xpsiphon /var/log/xpsiphon /tmp/psiphon
```

کانفیگ‌ها و باینری Psiphon به صورت پیش‌فرض نگه داشته می‌شوند. فقط اگر دیگر نیاز ندارید حذفشان کنید:

```bash
sudo rm -rf /etc/psiphon
```

## رفع اشکال

### `Psiphon binary not found`

نصب‌کننده Bootstrap را اجرا کنید:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/IzumiRain/xPsiphon/main/install.sh)
```

### `not listening` در تست سرعت

ابتدا لوکیشن را اجرا کنید:

```bash
sudo xp start AUTO
xp test AUTO
```

### خطاهای Permission

عملیات start/stop/restart/autostart نیاز به root دارد:

```bash
sudo xp start AUTO
sudo xp stop all
```

### بررسی نصب

```bash
xp doctor
xp status
xp locations
```

## اعتبارها

- پنل مدیریتی xPsiphon: [IzumiRain](https://github.com/IzumiRain)
- باینری Psiphon tunnel core: [Psiphon-Labs](https://github.com/Psiphon-Labs)
- پروژه مرجع Psiphon Linux: [SpherionOS/PsiphonLinux](https://github.com/SpherionOS/PsiphonLinux)


## حمایت مالی

اگر xPsiphon برای شما مفید بوده است، حمایت مالی شما ارزشمند است.

| شبکه | آدرس |
|---------|---------|
| **TRC20** (Tron) | `TKBHWNoeygcaCK8N78e7dQX5Yco3WTb6ZN` |
| **BEP20** (BNB Smart Chain) | `0x0F982640a69D3B9FB944840D7DA8bECCfcF0bb9E` |
| **TON** | `UQAyLUyxew-eggwhxbzsAZZZ9ULM8MYOk-3IXFh7tNC33LNt` |


## مجوز

[MIT](LICENSE) © IzumiRain.
