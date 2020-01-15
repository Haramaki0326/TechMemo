# ASP.NET MVCとは

# ライフサイクルについて
[ASP.NET MVC 開発を始める前に理解しておきたいこと](https://qiita.com/kazuhisam3/items/f056819172d2b6d36a8c)  
[第0回　Webアプリケーション・フレームワークの新たな選択肢](https://www.atmarkit.co.jp/fdotnet/aspnetmvc3/aspnetmvc3_01/aspnetmvc3_01_03.html)
![](https://www.atmarkit.co.jp/fdotnet/aspnetmvc3/aspnetmvc3_01/aspnetmvc3_01_05.gif)

# ビューについて
## 参考
[ASP.NET Core 入門5 ASP.NET Core MVC ビューエンジンRazor](https://qiita.com/dongsu-iis/items/5f830381aa8796421f67)  
[ASP.NET MVC View](https://qiita.com/kazuhisam3/items/f056819172d2b6d36a8c#aspnet-mvc-view)  
[C# Razor構文 基礎文法 総まとめ](https://www.atmarkit.co.jp/fdotnet/rapidmaster/rapidmaster_03/rapidmaster_03.html)  
[第5回　新しいビュー・エンジン「Razor」の基本を理解しよう](https://www.atmarkit.co.jp/fdotnet/aspnetmvc3/aspnetmvc3_06/aspnetmvc3_06_01.html)

## 概要
- Controllerから、表示に必要なデータを受け取り、画面に表示するためのhtmlを用意します
MVC 3 からは、View側を記述するためのDSLとして、Razorが導入されました
- ControllerとViewは一対一対応する（？）  
たとえば、`Controllers`フォルダの中に、`HomeContoroller`および`BookContoroller`があるとする。このとき、対応するビューが`Views`フォルダ配下にそれぞれ、`Home`、`Book`フォルダが作られる。  
この対応に沿ってそれぞれのコントローラーからビューに値を渡すことになる。
![](https://github.com/Haramaki0326/TechMemo/blob/develop/%E3%82%B3%E3%83%B3%E3%83%88%E3%83%AD%E3%83%BC%E3%83%A9%E3%83%BC%E3%81%A8%E3%83%93%E3%83%A5%E3%83%BC%E3%81%AE%E9%96%A2%E4%BF%8201.PNG?raw=true)
- コントローラー（またはモデル）からビューに値を渡す方法は３つ。`ViewData`,`ViewBag`,`ViewModel`。MSの推奨は`ViewModel`。  
参考：[ASP.NET Core 入門5 ASP.NET Core MVC ビューエンジンRazor](https://qiita.com/dongsu-iis/items/5f830381aa8796421f67) 
- ビューからコントローラーに値を渡す方法は、通常のHTMLと同じ方法。つまり、`<form>`タグの中に`submit`属性値を指定する方法。後述。  
参考：[第5回　新しいビュー・エンジン「Razor」の基本を理解しよう](https://www.atmarkit.co.jp/fdotnet/aspnetmvc3/aspnetmvc3_06/aspnetmvc3_06_03.html) 
``` html
<form>
    <input type="submit">
</form>
```
## コントローラー（またはモデル）からビューに値を渡す方法
### 1. ViewData
ControllerとView間でデータの受け渡すための入れ物
### 2. ViewBag

#### 記述例

``` csharp
//Controllers/ViewController

public ActionResult Index()
{
    ViewBag.Price = 1;
    ViewBag.Message = "ViewBag.Message";
    ViewData["Message1"] = "ViewData.Message1";
    return View();
}
```

``` html
@*Views/View/index.cshtml*@

@ViewBag.Message1         @* ViewData.Message1 と表示される *@
<br/>
@(ViewBag.Price * 10)     @* 10 と表示される *@
<br />
@ViewData["Message"]      @* ViewBag.Message と表示される *@
<br/>
@* @(ViewData["Price"] * 10) *@ @* 実行時に型を変換しろとエラーになる *@
@((int)ViewData["Price"] * 10) @* 10 と表示される *@
```

### 3. ViewModel (もしくは@model)
### 概要
- View(cshtml)で使用する型が指定できます
`@model Employee`
以降、`@Model.Id`のような参照が可能となります
デフォルトでは、`@model dynamic`となっているので、なんでもありの状態ですが明示的に指定したほうがよいです
コンパイル時に存在しないプロパティを参照しているとエラーになりますし、インテリセンスもきくようになります

- `@model` を使うことで、`Controller`を経由して、 `Model` を `View` に渡すことができる。

### 説明
[Razor による強い型付けビュー](https://aspnet.keicode.com/basic/aspnet-mvc-strongly-typed-view.php)

Razor は強い型付けをサポートしています。
「強い型付け」は英語の strongly-typed の翻訳。
ざっくり言えば「強く型付けされる」 (strongly-typed) ということは、その変数の型が決まったらその型が変わらない、ということです。
「この (Razor で定義される) ビューで『データモデル』と言ったらこの型 (type) のことですよ！」 というのを宣言できる、ということです。
具体的には「この (Razor で定義される) ビューの Model プロパティの型は @model キーワードで指定した型です！」 ということになります。

では、具体的な例を挙げてみてみましょう。

``` html
@model razor2.Models.Employee

<head>
    <title>Index</title>
</head>
<bdoy>
    <p>Model.FirstName</p>
    <p>Model.LastName</p>
</bdoy>
```

この @model キーワードで指定した型がこの Razor ビューにおける Model プロパティの型になります。
ここでは Employee という型 (クラス) を指定します。ここでは Employee クラスは次のように定義しました。

``` cs
namespace razor2.Models
{
    public class Employee
    {
        public string FirstName { get; set;}
        public string LastName { get; set;}
    }
}
```

そのため、コードの中で @Model.FirstName とか @Model.LastName という風に参照できるのです。
そして、コントローラ側からは次のようにビューに Employee オブジェクトを渡しています。

``` cs
namespace razor2.Controllers
{
    public class EmployeeControllers : Controller
    {
        public ActionResult Index()
        var emp = new Employee
        {
            FirstName = "Keith",
            LastName = "Oyama"
        };
        
        return View(emp);
    }
}
```
このように渡すと、自動的に渡された Employee を Model というプロパティで参照できるのです。

### 複数のModelをViewに渡したいときは・・・
[stackoverflow - Multiple models in a view](https://stackoverflow.com/questions/4764011/multiple-models-in-a-view)


## ビューからコントローラーに値を渡す方法
あとで

## Razor構文
### インライン式

### コードブロック

### コメント

### 名前空間のインポート

### 条件分岐


### 繰り返し処理

### 関数


### レイアウト

### HTMLヘルパー
参考：[ASP.NET MVC HTML ヘルパー①](https://tokkan.net/csharp/asp3.html)
HTMLヘルパーはビューに埋め込むコントロールで、ASPがHTMLに変換してくれます。フォームやINPUT関連、リンクなどがあります。
INPUT系は後ろにForが付くものと付かないものがありますが、これはプロパティの指定がプロパティ名直接かラムダ式を使用するかの違いになり、
**Forが付かないものはプロパティを直接指定し、Forが付くものはラムダ式でプロパティを指定します。**

```
 @* Forなし *@
 @Html.Editor("Str1")

 @* Forあり *@
 @Html.EditorFor(model => model.Boo)
```

### テンプレート関連のビュー・ヘルパー
[書籍転載：ASP.NET MVC 5 実践プログラミング](https://www.buildinsider.net/web/bookaspmvc5/040401)
[yan note: ASP.NET MVC 12_テンプレートヘルパー ～その1～](http://yan-note.blogspot.com/2016/12/aspnet-mvc-12-1.html?m=1)

>テンプレートヘルパーは、引数に指定したモデルのプロパティの型やその属性から自動的にHTML要素を生成してくれます。たとえばstring型であればinput要素を、bool型であればcheckbox要素を生成するといった具合です。

>DisplayFor／EditorForヘルパーは、言うなれば、モデル定義に応じて出力を自在に変化できるヘルパー。DisplayForヘルパーがデータの表示を、EditorForヘルパーがデータ編集（入力）項目の生成を、それぞれ担っています。
「モデル定義に応じて」と言ってわかりにくければ、モデルに定義されているデータ型、あるいは、付随するメタ情報（属性）に応じて、適切な出力を生成する、と言い換えても良いかもしれません。（たとえば）プロパティの型がstring型であれば、EditorForメソッドは標準のテキストボックス（`<input type="text">`要素）を、bool型であればチェックボックス（`<input type="checkbox"`>要素）を、それぞれ出力します。

![](https://re.buildinsider.net/web/bookaspmvc5/040401/4-4_s.gif)

>モデルの状態をヘルパーが自動的に認識してくれるわけです。このような性質から、テンプレートヘルパーには、以下のようなメリットがあります。
- ビューが、プロパティの型／メタ情報を意識しなくても良い
- モデル（型／メタ情報）の変更がビューに影響しにくい
- 同じ型（メタ情報）であれば同じ出力を生成するので、出力に一貫性を持たせやすい
>モデルをもとにデータを入出力するならば、まずはTextBoxFor／CheckBoxForなど個別のヘルパーではなく、テンプレートヘルパーを優先して利用するのが望ましいでしょう。


#### DisplayNameForヘルパー
DisplayNameForヘルパーは、モデルのプロパティの表示名をhtmlタグで修飾せずに出力します。
- 属性を指定しない場合、プロパティ名をそのまま出力します。
- DisplaｙName属性を指定した場合、指定した値を出力します。
- Display属性のnameプロパティを指定した場合も、指定した値を出力します。


**モデル**
``` cs
//DisplayName属性を使用する場合にインポートする
using System.ComponentModel;
//Display属性を使用する場合にインポートする
using System.ComponentModel.DataAnnotations;

namespace Practice.Models
{
    public class TemplateHelperViewModel
    {
        public string Text1 { get; set; }

        [DisplayName("テキスト2")]
        public string Text2 { get; set; }

        [Display(Name = "テキスト3")]
        public string Text3 { get; set; }
    }
}
```

**コントローラー**
``` cs
using System.Web.Mvc;

namespace Practice.Controllers
{
    public class TemplateHelperController : Controller
    {
        public ActionResult Index()
        {
            var mdl = new Models.TemplateHelperViewModel();
            return View(mdl);
        }
    }
}
```


**ビュー**
``` html
@model Practice.Models.TemplateHelperViewModel

@Html.DisplayNameFor(mdl => mdl.Text1)
@Html.DisplayNameFor(mdl => mdl.Text2)
@Html.DisplayNameFor(mdl => mdl.Text3)
```

**出力**
![](https://4.bp.blogspot.com/-1i1nvn3cYDk/WFErbyjkcPI/AAAAAAAAD4o/pNg1z8Ktj2ALm1W1LTZUSr9SQdM8wyuegCLcB/s1600/WS000002.JPG)



#### DisplayForヘルパー/ EditorForヘルパー
DisplayForヘルパーはモデルの値を表示形式で出力します。
EditorForヘルパーはモデルの値を入力形式で出力します。
モデルの値の型やDataType属性（名前空間：System.ComponentModel.DataAnnotations）に指定した値により出力形式が変わります。
![](//img/テンプレートヘルパーまとめ.PNG)

### タグヘルパー
参考：
[ASP.NET Core MVC の Razor で使える Tag Helpers のメモ書き - しばやん雑記](https://blog.shibayan.jp/entry/20170725/1500966960)  
[ASP.NET Core のタグ ヘルパー](https://docs.microsoft.com/ja-jp/aspnet/core/mvc/views/tag-helpers/intro?view=aspnetcore-3.1)

概要
>基本的には asp-* という属性を使って書ける Html Helper です。HTML のタグとシームレスに統合されていて、構造を崩さずに書けるので Tag Helpers は最高に便利です。

#### リンク生成 (a)
``` html
<!-- href = /home/about -->
<a asp-controller="Home" asp-action="About">About me</a>

<!-- href = /home/about/123 -->
<a asp-controller="Home" asp-action="About" asp-route-id="123">About me</a>

<!-- href = /home/about#top -->
<a asp-controller="Home" asp-action="About" asp-fragment="top">Go to Top</a>

<!-- href = https://hostname/home/about -->
<a asp-controller="Home" asp-action="About" asp-protocol="https">Https link</a>

<!-- href = https://www.example.com/home/about -->
<a asp-controller="Home" asp-action="About" asp-protocol="https" asp-host="www.example.com">Absolute Path</a>
```

#### リソース参照 (img / link / script)
``` html
<!-- src = /img/top.png?v=SHA256HASH -->
<img src="~/img/top.png" asp-append-version="true" />

<!-- href のファイルを読み込めなかった時は asp-fallback-href を読む -->
<link rel="stylesheet" href="https://ajax.aspnetcdn.com/ajax/bootstrap/3.3.7/css/bootstrap.min.css"
        asp-fallback-href="~/lib/bootstrap/dist/css/bootstrap.min.css"
        asp-fallback-test-class="sr-only" asp-fallback-test-property="position" asp-fallback-test-value="absolute" />

<!-- src のファイルを読み込めなかった時は asp-fallback-src を読む -->
<script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-2.2.0.min.js"
        asp-fallback-src="~/lib/jquery/dist/jquery.min.js"
        asp-fallback-test="window.jQuery">
</script>
```


#### フォーム表示 (form / input / select など)
``` html
<!-- action = /user/login -->
<form asp-controller="Login" asp-action="User" method="post">

    <!-- type="email" id="Email" name="Email" -->
    <input asp-for="Email" />

    <!-- type="password" id="Password" name="Password" -->
    <input asp-for="Password" />

    <button>Login</button>

</form>

<!-- CSRF 用トークンを自動出力しない -->
<form asp-antiforgery="false">
  <button>submit</button>
</form>

<!-- formaction = /forms/delete/123 -->
<button asp-controller="Forms" asp-action="Delete" asp-route-id="123">Delete</button>

<!-- asp-items には IEnumerable<SelectListItem> -->
<select asp-for="Favorite" asp-items="AllItems">
</select>
```


#### バリデーションエラー表示 (div / span)
``` html
<!-- 全てのエラーを表示 -->
<div asp-validation-summary="All"></div>

<!-- モデルに対してのエラーのみ -->
<div asp-validation-summary="ModelOnly"></div>

<!-- 指定したキーのエラーのみ -->
<span asp-validation-for="Email"></span>
```

#### Core MVC 独自 (environment)
``` html
<!-- ASP.NET Core 1.1 まで -->
<environment names="Production,Staging">
  <link rel="stylesheet" href="~/site.min.css" />
</environment>
<environment names="Development">
  <link rel="stylesheet" href="~/site.css" />
</environment>

<!-- ASP.NET Core 2.0 から -->
<environment Exclude="Development">
  <link rel="stylesheet" href="~/site.min.css" />
</environment>
<environment Include="Development">
  <link rel="stylesheet" href="~/site.css" />
</environment>
```


# コントローラーについて

[ASP.NET MVC Controller](https://qiita.com/kazuhisam3/items/f056819172d2b6d36a8c#aspnet-mvc-controller)
ルーティングにより関連付けられたリクエストを実際に処理するためのコードを記述します
このControllerになんでも記述が出来てしまうので、大きくなり過ぎないように注意が必要となります
※WebFormsのaspx.csになんでも記述出来るのと同じです
　ASP.NET MVCにしたから、MVCの形式で作れるようになるわけではなく、
　考え方、作り方を変えないと同じ事になるので注意しましょう

# モデルについて



## EntityFramework


