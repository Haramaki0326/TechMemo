# C#の構成ファイルについて
## 参考
- [「アプリケーション構成ファイル」を使用して設定を読み込む - .NET Tips (VB.NET,C#...)](https://dobon.net/vb/dotnet/programing/appconfigfile.html)
- [.NET Core の設定情報の仕組みをしっかり理解したい方向け基本のキ - ecbeing labs（イーシービーイング・ラボ）](https://blog.ecbeing.tech/entry/2020/03/16/114500)

## 接続文字列について
- [Web.Config からデータベース接続文字列(ConnectionStrings)を取得する - 接続文字列を設定ファイルに記述する - ASP.NET プログラミング](https://www.ipentec.com/document/csharp-get-connection-string-from-web-config)
- https://www.atmarkit.co.jp/fdotnet/dotnettips/1050sqlconstringbuild/sqlconstringbuild.html
- https://blog.shibayan.jp/entry/20140728/1406520000
- https://csharp.sql55.com/database/get-connection-string-from-app-config.php
- 

## 概要
「アプリケーション構成ファイル」とは、アプリケーション固有の設定が記述されたXML形式のファイルです。このアプリケーション構成ファイルは様々な設定を変更する時に使用されますが、アプリケーションの設定を記述しておけるという機能もあります。ここでは、「アプリケーション構成ファイル」への設定の記述と、その設定を読み込む簡単な方法を示します。
以下に、値が文字列の設定をアプリケーション構成ファイルに記述する方法と、その設定を読み取る方法を、順を追って説明します。

### 1.アプリケーション構成ファイルの作成
Visual Studioのソリューションエクスプローラでプロジェクトを右クリックして、ポップアップメニューを表示させます。メニューの「追加」-「新しい項目の追加」を選び、「新しい項目の追加」ダイアログを表示させます。ここで「アプリケーション構成ファイル」を選んで「追加」ボタンをクリックすると、「アプリケーション構成ファイル」が作成されます。
このアプリケーション構成ファイルは、ファイル名「App.config」(Webアプリケーションでは「web.config」)としてプロジェクトに追加されます。プロジェクトをビルドすると、アプリケーション構成ファイルはEXEファイルと同じフォルダに「（EXEファイル名）.config」という名前でコピーされます（例えば、"Project1.exe"という名前のアプリケーションでは、"Project1.exe.config"という名前になります）。

はじめのアプリケーション構成ファイルの中身は次のようになっています。
``` xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
</configuration>
```

もし「新しい項目の追加」にどうしても「アプリケーション構成ファイル」が出ない場合は、「App.config」という名前のファイルを作成して、このファイルをプロジェクトに追加し（ソリューションエクスプローラへのドラッグ＆ドロップ等で追加できます）、そのファイルをVisual Studioで開いて、上記のXMLを記述すれば、OKです。

### 2.設定の記述

次のように<appSettings>要素を追加し、さらにその中に<add>要素を必要なだけ追加していきます。key属性が設定名で、value属性が設定の値になります。

``` xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
    <appSettings>
        <add key="Application Name" value="MyApplication" />
        <add key="Application Version" value="1.0.0.0" />
        <add key="Comment" value="Hoge Hoge" />
    </appSettings>
</configuration>
```
これでアプリケーション構成ファイルへの設定の記述は終了です。

### 3.アプリケーション構成ファイルの読み込み

「アプリケーション構成ファイル」から設定を読み込むためには、.NET Framework 2.0以降では、`ConfigurationManager.AppSettings`プロパティを使います。なお`ConfigurationManager`を使うには、参照設定に「`System.Configuration.dll`」を追加する必要があります。

``` cs
//指定したキーの値を取得
//見つからないときはnullを返す
Console.WriteLine(System.Configuration.ConfigurationManager.AppSettings["Comment"]);

//すべてのキーとその値を取得
foreach (string key in System.Configuration.ConfigurationManager.AppSettings.AllKeys)
{
    Console.WriteLine("{0} : {1}",
        key, System.Configuration.ConfigurationManager.AppSettings[key]);
}
```

上記の結果、次のように出力されます。

```
Hoge Hoge
Application Name : MyApplication
Application Version : 1.0.0.0
Comment : Hoge Hoge
```
