# C#における非同期処理
## 参考
- [非同期処理の種類 - C# によるプログラミング入門 | ++C++; // 未確認飛行](https://ufcpp.net/study/csharp/AsyncVariation.html)  
- [Taskを極めろ！async/await完全攻略 - Qiita](https://qiita.com/acple@github/items/8f63aacb13de9954c5da)  
- [初心者のためのTask.Run(), async/awaitの使い方 - Qiita](https://qiita.com/Alupaca1363Inew/items/0126270bca99883605de)  
- [async、awaitそしてTaskについて（非同期とは何なのか） - SE（たぶん）の雑感記](https://hiroronn.hatenablog.jp/entry/20171005/1507207811)
  
## 概要
「非同期処理」と言っても、いくつかのタイプの用途があって、それぞれ書き方や使うクラス ライブラリが異なります。 大まかに言うと、以下のような用途があります。

###  バックグラウンド処理
負荷の高い計算や、I/O待ちなどによって、CPUやスレッド資源を保持し続けないために、別スレッドでの計算やI/O待ちを行います。  
C# 5.0 で導入された非同期メソッド（「非同期処理」参照）は、前者のバックグラウンド処理を簡単化するものです。

### 並列計算
マルチコアCPUの性能を最大限引き出すために、同じ計算を複数のコアで同時に実行します。
#### データ並列
同じ処理を異なるデータに対して繰り返し行います。  
データ並列には`Parallel` クラス（`System.Threading.Tasks` 名前空間）や `ParallelEnumerable` クラス（`System.Linq` 名前空間。通称「並列 LINQ」） を使います。

#### タスク並列
異なる処理が独立して動いていて、その間で非同期にデータのやり取り（非同期データフロー）を行います。
タスク並列には `TPL Dataflow` ライブラリを利用するといいでしょう。 また、これらはいずれも、内部的には .NET Framework 4 で導入された `Task` クラス（`System.Threading.Tasks` 名前空間）を利用しています。

# バックグラウンド処理
## 参考
- [非同期メソッド - C# によるプログラミング入門 | ++C++; // 未確認飛行 C](https://ufcpp.net/study/csharp/sp5_async.html)

## 概要
>URL 指定してダウンロードしてきた文字列をテキストボックスに表示という GUI アプリケーションを考えてみましょう。 同期的に書くなら、ボタンに対して以下のようなイベント ハンドラーを登録します。
``` cs
private void Button_Click(object sender, RoutedEventArgs e)
{
    var client = new WebClient();
    var html = client.DownloadString(this.Url.Text);
    this.Output.Text = html;
}
```
>このように同期でダウンロードを行うと、図1に示すように、ネットワークの通信速度が遅い環境では GUI がフリーズしてしまいます。 そこで、図2に示すように、非同期通信版を使って、UI スレッドをブロッキングしないようにします。
![](https://ufcpp.net/media/ufcpp2000/csharp/fig/eventblocking.png)
![](https://ufcpp.net/media/ufcpp2000/csharp/fig/eventasync.png)


## async/awaitキーワード、そして「非同期メソッド」とは
- シグネチャに`async`を付けたメソッドのことを **「非同期メソッド」** と呼びます。  
- 非同期メソッドの特徴はただ一つ、文中で`await`キーワードを使えるようになることです。
- そして、`await`キーワードの効果は、「指定した`Task`の完了を待つ」「そして、その結果を取り出す」ことです。
- 最後に、非同期メソッドの戻り値は必ず`Task`もしくは`Task<T>`になります。

### asyncの効果
#### IDE等が、非同期メソッドとして扱う
#### 戻り値の指定
- 戻り値で、`Task`を指定した場合、戻り値を返す必要は無い（返せない）  
- 戻り値で、`Task<T>`を指定した場合、`return`で`T`型の値を返せばよい  

メソッドの戻り値で`Task<string>`と指定しているにもかかわらず、`response.Content.ReadAsStringAsync()`では`string`型を返します。
このように、Task<T>のTで指定した型を返せばよくなります。むしろ、Taskを返そうとするとエラーになります。
戻り値無し（void）の場合は、通常のvoidと同じく、戻り値を返す必要はありません。

#### awaitの使用
- `await`がキーワード扱いされる
- `await`が現れたら、その処理は非同期（別スレッド）で行われ、メソッドの処理が終わる
- `await`で指定された処理が終わったら、その先の処理が流れ出す
- `await`は、`async`キーワードによって変更された非同期メソッドでのみ使用できます。


まず、上記「メソッドの処理が終わる」の意味です。
`await`以降は`await`で指定した処理が終わるまで実行されない、と覚えておきましょう。


## Taskクラスについて
### 参考
[C# 非同期、覚え書き。 - Qiita](https://qiita.com/hiki_neet_p/items/d6b3addda6c248e53ef0)
[ひょうろくだまらん](http://outside6.wp.xdomain.jp/2016/08/04/post-205/)

### 概要
- タスクオブジェクトを作成・実行する手順は以下の3つ。
  1. Task.Factory.StartNew
  2. Task.Run
  3. new Task()

- 基本的には`Task.Run`を使えばよい
- `Task.Run`は手軽だが細かな制御ができない。
- `Task.Factory.StartNew`はオプションが多いので細かい設定が可能。

### タスクの作成
タスクオブジェクトを作成・実行する手順は以下の3つ。
1. Task.Factory.StartNew
2. Task.Run
3. new Task()

### Task.Factory.StartNew
``` cs
using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        var task = Task.Factory.StartNew(() => Console.WriteLine("OK"));

        Console.ReadLine();
    }
}
```
上記コードは、下記と同じ意味のようです。

``` cs
Sample.cs
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task.Factory.StartNew(
            () => Console.WriteLine("OK"),
            CancellationToken.None,
            TaskCreationOptions.None,
            TaskScheduler.Default);

        Console.ReadLine();
    }
}
```

TaskCreationOptions については、次節で触れます。
TaskScheduler.Default は、ThreadPool を使用してスケジューリングするという意味になります。


### Task.Run
StartNew より記述が短いですね。

``` cs
Sample.cs
using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task.Run(() => Console.WriteLine("OK"));

        Console.ReadLine();
    }
}
```
上記コードは、下記と同じ意味です。

``` cs
Sample.cs
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task.Factory.StartNew(
            () => Console.WriteLine("OK"),
            CancellationToken.None,
            TaskCreationOptions.DenyChildAttach,
            TaskScheduler.Default);

        Console.ReadLine();
    }
}
```

前節の `StartNew` との違いは、第3引数の `TaskCreationOptions.DenyChildAttach` の部分です。
`Run` は子スレッドに親へのアタッチを禁止します。
前節の `StartNew` は禁止しません。
親スレッドへのアタッチは、`StartNew` メソッドに `TaskCreationOptions.AttachedToParent` を指定することで実現できます。

実際の動作を比較してみましょう。

StartNew の場合。

``` cs
Sample.cs
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task.Factory.StartNew(() =>
        {
            Task.Factory.StartNew(() =>
            {
                Thread.Sleep(1000);
                Console.WriteLine("Child");
            }, TaskCreationOptions.AttachedToParent);
        }).Wait();
        Console.WriteLine("Parent");

        Console.ReadLine();
    }
}
```

```
output
Child
Parent
```

Run の場合。

``` cs
Sample.cs
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task.Run(() =>
        {
            Task.Factory.StartNew(() =>
            {
                Thread.Sleep(1000);
                Console.WriteLine("Child");
            }, TaskCreationOptions.AttachedToParent);
        }).Wait();
        Console.WriteLine("Parent");

        Console.ReadLine();
    }
}
```
```
output
Parent
Child
```
Run の場合は、子スレッドの終了を待たずに親スレッドが終了していることがわかります。
Run の子スレッドは親にアタッチできていないということですね。


### new Task()
コンストラクタから生成する場合です。
Start メソッドで起動されます。

``` cs
Sample.cs
using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        var task = new Task(() => Console.WriteLine("OK"));
        task.Start();

        Console.ReadLine();
    }
}
```
この場合、`Task` は `TaskScheduler.Current` というものを使用してスケジューリングされます。


### Taskの引数、戻り値
