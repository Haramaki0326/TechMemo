# Taskクラスについて
## 概要
**「Taskとは、『非同期処理』のことではない。」**
Taskクラスはその名の通り、一つの「作業単位」「仕事」「タスク」そのものを表しているといえます。一般的なTaskファクトリであるTask.Runを例とすると、
``` cs
var task = Task.Run(() =>
{
    MethodA();
    MethodB();
});
```
この変数taskは、「MethodAを実行後、MethodBを実行する、という『タスク』を作成し、それを開始したもの」を表します。つまり、変数taskの中身は、文字通り『タスク』そのものなのです。

例
「1000ミリ秒待機するという『仕事』を表す」
``` cs
var task = Task.Delay(1000); // ただのDelayなんだけど、ちょっと違って見えてきません？
「HttpClientでGETを行うという『仕事』」
var task = client.GetAsync("https://......"); // <- awaitを付けていない
```
ここで記述しているのは「開始するところ」だけなのがポイント。だから、「実際のGET処理は裏で誰かが勝手にやってくれる」。

### Taskの生成と実行
- タスクオブジェクトを作成・実行する手順は以下の3つ。
  1. Task.Factory.StartNew
  2. Task.Run
  3. new Task()

- 基本的には`Task.Run`を使えばよい
- `Task.Run`は手軽だが細かな制御ができない。
- `Task.Factory.StartNew`はオプションが多いので細かい設定が可能。

### 引数


#### Task.Factory.StartNew
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

#### Task.Run
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
#### new Task()
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
