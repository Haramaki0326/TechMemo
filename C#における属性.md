# C#における属性

- 条件コンパイルなどの、コンパイラへの指示に使う（`Conditional` や `Obsolete`）  
- 作者情報などをメタデータとしてプログラムに埋め込む（`AssemblyTitle` など）  
- 「リフレクション」を利用して、プログラム実行時に属性情報を取り出して利用する  

参考：[C# によるプログラミング入門  [動的な処理] 属性](https://ufcpp.net/study/csharp/sp_attribute.html)

## 概要
属性は以下のように `[]` でくくり、 クラスやメンバーの前に付けて使います。

```
[属性名(属性パラメータ)]
メンバーの定義
```
たとえば以下のような感じ。

``` cs
[DataContract]
class User
{
    public int Id { get; set; }
    public string Name { get; set; }
}
```
属性名は語尾に `Attribute` を付けることになっています。 例えば、標準で用意されている属性には `ObsoleteAttribute` や `ConditionalAttribute` などといった名前のものがあります。 また、これらを C# から利用する場合、語尾の `Attribute` は省略してもかまいません。 したがって、前者は `Obsolete`、 後者は `Conditional` という名前で使用できます。

# 定義済み属性
## コンパイラが利用
### Obsolete

### Conditional


## 開発ツール
- Category  
- DefaultValue  
- Description  
- Browsable  

## 実行エンジン
- DllImport  
- ComImport  


## ライブラリ
### データ検証
- Required  
- Range  
- StringLength  

### テスト
- TestClass  
- TestMethod  

## プログラム自体に関する情報
- AssemblyDescription   

## その他
### HttpGet, HttpPost
[ASP.NET MVC 開発を始める前に理解しておきたいこと](https://qiita.com/kazuhisam3/items/f056819172d2b6d36a8c#httpgethttpposthttpputhttpdeletehttphead)
``` cs
[HttpGet]
public ActionResult Index()
{
    // HttpのGetメソッドの場合のみ、処理される
    return View();
}
[HttpPost]
public ActionResult Index1()
{
    // HttpのPostメソッドの場合のみ、処理される
    return View();
}
```
>属性で指定されたメソッドのみ処理が実行されます
上記以外にも以下のものがあります
[HttpPut, HttpDelete, HttpHead]

### Serializable
[基本的なシリアル化](基本的なシリアル化)
>クラスをシリアル化できるようにするための最も簡単な方法は、次に示すように SerializableAttribute でマークすることです。
``` cs
[Serializable]  
public class MyObject {  
  public int n1 = 0;  
  public int n2 = 0;  
  public String str = null;  
}  
```
>このクラスのインスタンスをファイルにシリアル化する方法を、次のコード例に示します。
``` cs
MyObject obj = new MyObject();  
obj.n1 = 1;  
obj.n2 = 24;  
obj.str = "Some String";  
IFormatter formatter = new BinaryFormatter();  
Stream stream = new FileStream("MyFile.bin", FileMode.Create, FileAccess.Write, FileShare.None);  
formatter.Serialize(stream, obj);  
stream.Close();  
```
>この例では、バイナリ フォーマッタを使用してシリアル化します。 必要な作業は、使用するストリームのインスタンスとフォーマッタを作成し、フォーマッタで Serialize メソッドを呼び出すことだけです。 ストリームとシリアル化するオブジェクトを、この呼び出しのパラメーターとして指定します。

### DataContract
- C#オブジェクトをJSONに変換する際に利用。`DataContract`属性を使うのが公式のやり方
[DataContractAttribute クラス](https://docs.microsoft.com/ja-jp/dotnet/api/system.runtime.serialization.datacontractattribute?view=netframework-4.8)  
- Json.NETを使うともっと楽らしい
    - [C#でJSONを扱うライブラリ「Json.NET」を使ってみました](https://qiita.com/ta-yamaoka/items/a7ff1d9651310ade4e76)


# 属性の対象
- assembly  
	アセンブリ(簡単に言うと、プログラムの実行に必要なファイルをひとまとめにした物のこと)が対象になります。
- module  
	モジュール(1つの実行ファイルやDLLファイルのこと)が対象になります。
- type  
	クラスや構造体、列挙型やデリゲート(後述)等の型が対象になります。
- field  
	フィールド(要するにメンバー変数のこと)が対象になります。
- method  
	メソッドが対象になります。
- event  
	イベント(後述)が対象になります。
- property  
	プロパティが対象になります。
- param  
	メソッドの引数が対象になります。
- return  
	メソッドの戻り値が対象になります。