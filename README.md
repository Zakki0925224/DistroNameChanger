# DistroNameChanger

os-releaseとlsb-releaseのOS名に該当する部分の変更を簡易化します。

## 変更される部分
<dl>
    <dt>os-release</dt>
    <dd>5行目の"PRETTY_NAME"の項目</dd>
    <dt>lsb-release</dt>
    <dd>4行目の"DISTRIB_DESCRIPTION"の項目</dd>
</dl>

## 使い方
```Bash
    $ sh DistroNameChanger.sh
```