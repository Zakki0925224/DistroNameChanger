# DistroNameChanger

os-releaseとlsb-releaseのOS名に該当する部分の変更を簡易化します。
neofetchの"OS"の項目を書き換えることができます。

## 変更される部分
<dl>
    <dt>os-release</dt>
    <dd>5行目の"PRETTY_NAME"の項目</dd>
    <dt>lsb-release</dt>
    <dd>4行目の"DISTRIB_DESCRIPTION"の項目</dd>
</dl>

## 使い方
### インストール
```Bash
    git clone https://github.com/Zakki0925224/DistroNameChanger.git
    cd DistroNameChanger
    sudo bash ./setup.sh install
```
### アンインストール
```Bash
    sudo bash ./setup.sh uninstall
```
### 起動
```Bash
    sudo DistroNameChanger
```
### インストールチェッカー
DistroNameChangerがインストールされているかどうかをチェックします。
```Bash
    sudo bash ./setup.sh check
```

## 注意

os-releaseの"PRETTY_NAME"の項目と、lsb-releaseの"DISTRIB_DESCRIPTION"の項目が事前に一致してないとうまく動作しません。