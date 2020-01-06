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
- 1,2のメソッドの戻り値は基本的に`Task`か`Task<TResult>`になる。
- とは言え、コンストラクタとは違い`Task.Run`や`Task.Factory.StartNew`は呼び出した時点で中身のメソッドは実行されるので、戻り値を`Task`変数に入れなくてもよい。具体的には以下

``` cs
using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
		// ①、②どちらのコードも可能
		// ①task変数に代入する。taskはこのあとtask.resultなど色々活用可能。
       	var task = Task.Factory.StartNew(() => Console.WriteLine("task変数に代入する。"));
        
		// ②task変数に代入しない。コンソール出力を行うのみ。
		Task.Factory.StartNew(() => Console.WriteLine("task変数には代入しない。実行のみ。"));
    }
}
```

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

## Task内での戻り値について
- Task内での戻り値なし
  - `Task`
- Task内での戻り値あり
  - `Task<T>`

### Task\<TResult\>.Result（Task内での戻り値ありの場合）
- `Task`はTask内での戻り値がない場合に用いる。そのため、呼び出し元スレッドに何か処理結果を返すことはない。
- `Task<TResult>`はTask内での戻り値がある場合に用いる。そのため、呼び出し元スレッドに何か処理結果を返すときは、`Task<TResult>`クラスの`Result`プロパティを用いる。

``` cs
    static void Main()
    {
        Task<int> task = Task.Run<int>(() =>
        {
            int total = 0;
            for (int i = 1; i <= 100; ++i)
                total += i;
            Thread.Sleep(4560); // 何か重い処理をしている...
            return total;
        });

        int result = task.Result; // スレッドの処理の結果を「待ち受け」する

        Console.WriteLine("Result is {0}", result);
    }
```
ただしこう書くと、スレッドが終了するまで待つことになります。Run()で子スレッドに処理を投入したのに、すぐ次の行でスレッドの処理が終了するまで待ってしまっては、非同期処理の利点を完全に殺していることになります。つまり、まったくの無駄です。非同期処理なのですから、メインスレッドはRun()で処理を子スレッドに投入した後、スレッドの完了を待たずさっさと自分の処理に戻りたいのです。そんな都合の良い構文がC#にはあるのでしょうか？　まあこう書いている地点であるんですけどね。
``` cs
Task<int> task = Task.Run<int>(() => {
        int total = 0;
        for (int i=1; i<=100; ++i)
            total += i;
        Thread.Sleep(4560); // 何か重い処理をしている...
        return total;
    });

int result = await task; // スレッドの処理の結果を「待ち受け」する
```
Taskにawaitを付けると、メインスレッドは処理を即リターンして、子スレッドの処理が終了すると、int result以降の処理が、おもむろに再開します。

**TODO:具体的なコードで確認**


## タスクとスレッドについて
- `async`や`await`を用いなくても、タスクを生成するとスレッドプールから使われていないスレッド（メインスレッドではないもの）が割り当てられる。(Sample1,2)
- タスクが複数生成されていても、スレッドが空いた場合は使い回しを行う。(Sample3)

``` cs
//Sample1

using System;
using System.Threading;
using System.Threading.Tasks;

class Example
{
    static void Main()
    {
        Console.WriteLine("MainThread Start. Thread={0}",
        Thread.CurrentThread.ManagedThreadId);

        Task t1 = Task.Run( () =>
                {
                    Console.WriteLine("t1 Start");
                    Console.WriteLine("Task={0}, Thread={1}",
                    Task.CurrentId,
                    Thread.CurrentThread.ManagedThreadId);

                    Thread.Sleep(1000);

                    Console.WriteLine("t1 Finished");
                    Console.WriteLine("Task={0}, Thread={1}",
                    Task.CurrentId,
                    Thread.CurrentThread.ManagedThreadId);
                }
            );

        Console.WriteLine("MainThread is finished. Thread={0}",
        Thread.CurrentThread.ManagedThreadId);

        t1.Wait();

        Console.WriteLine("MainThread and T1 are finished. Thread={0}",
        Thread.CurrentThread.ManagedThreadId);



    }
}
// The example displays output like the following:
// MainThread Start. Thread=1
// MainThread is finished. Thread=1
// t1 Start
// Task=1, Thread=4
// t1 Finished
// Task=1, Thread=4
// MainThread and T1 are finished. Thread=1
```


``` cs
//Sample2

using System;
using System.Threading;
using System.Threading.Tasks;

class Example
{
	static void Main()
	{
		Console.WriteLine("MainThread Start. Thread={0}",
		Thread.CurrentThread.ManagedThreadId);

		Task t1 = Task.Run(() =>
		{
			Console.WriteLine("t1 Start");
			Console.WriteLine("t1,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);

			Thread.Sleep(1000);

			Console.WriteLine("t1 Finished");
			Console.WriteLine("t1,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);
		});

		Task t2 = Task.Run(() =>
		{
			Console.WriteLine("t2 Start");
			Console.WriteLine("t2,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);

			Thread.Sleep(2000);

			Console.WriteLine("t2 Finished");
			Console.WriteLine("t2,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);
		});

		Console.WriteLine("MainThread is finished. Thread={0}",
		Thread.CurrentThread.ManagedThreadId);

		t1.Wait();
		t2.Wait();

		Console.WriteLine("MainThread and t1,t2 are finished. Thread={0}",
		Thread.CurrentThread.ManagedThreadId);

	}
}
// MainThread Start. Thread=1
// MainThread is finished. Thread=1
// t1 Start
// t2 Start
// t2,Task=2, Thread=4
// t1,Task=1, Thread=5
// t1 Finished
// t1,Task=1, Thread=5
// t2 Finished
// t2,Task=2, Thread=4
// MainThread and t1,t2 are finished. Thread=1

```

``` cs
// Sample3

using System;
using System.Threading;
using System.Threading.Tasks;

class Example
{
	static void Main()
	{
		Console.WriteLine("MainThread Start. Thread={0}",
		Thread.CurrentThread.ManagedThreadId);

		Task t1 = Task.Run(() =>
		{
			Console.WriteLine("t1 Start");
			Console.WriteLine("t1,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);

			Thread.Sleep(1000);

			Console.WriteLine("t1 Finished");
			Console.WriteLine("t1,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);
		});
		
		// t1が終わるまでt2を開始させない。
		t1.Wait();

		Task t2 = Task.Run(() =>
		{
			Console.WriteLine("t2 Start");
			Console.WriteLine("t2,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);

			Thread.Sleep(2000);

			Console.WriteLine("t2 Finished");
			Console.WriteLine("t2,Task={0}, Thread={1}",
			Task.CurrentId,
			Thread.CurrentThread.ManagedThreadId);
		});

		Console.WriteLine("MainThread is finished. Thread={0}",
		Thread.CurrentThread.ManagedThreadId);

		t2.Wait();

		Console.WriteLine("MainThread and t1,t2 are finished. Thread={0}",
		Thread.CurrentThread.ManagedThreadId);

	}
}
// The example displays output like the following:
//MainThread Start.Thread=1
//t1 Start
//t1, Task= 1, Thread= 4
//t1 Finished
//t1, Task= 1, Thread= 4
//MainThread is finished.Thread= 1
//t2 Start
//t2, Task= 2, Thread= 4
//t2 Finished
//t2, Task= 2, Thread= 4
//MainThread and t1, t2 are finished.Thread= 1

```


# async/awaitキーワード、そして「非同期メソッド」とは
## 参考
[C# 今更ですが、await / async - Qiita](https://qiita.com/rawr/items/5d49960a4e4d3823722f)

## 概要
- シグネチャに`async`を付けたメソッドのことを **「非同期メソッド」** と呼びます。  
- 非同期メソッドの特徴はただ一つ、文中で`await`キーワードを使えるようになることです。
- そして、`await`キーワードの効果は、「指定した`Task`の完了を待つ」「そして、その結果を取り出す」ことです。
- 最後に、非同期メソッドの戻り値は必ず`Task`もしくは`Task<T>`になります。

## asyncの効果
### IDE等が、非同期メソッドとして扱う
### 戻り値の指定
- 戻り値で、`Task`を指定した場合、戻り値を返す必要は無い（返せない）  
- 戻り値で、`Task<T>`を指定した場合、`return`で`T`型の値を返せばよい  

メソッドの戻り値で`Task<string>`と指定しているにもかかわらず、`response.Content.ReadAsStringAsync()`では`string`型を返します。
このように、Task<T>のTで指定した型を返せばよくなります。むしろ、Taskを返そうとするとエラーになります。
戻り値無し（void）の場合は、通常のvoidと同じく、戻り値を返す必要はありません。

### awaitの使用
- `await`がキーワード扱いされる
- `await`が現れたら、その処理は非同期（別スレッド）で行われ、メソッドの処理が終わる
- `await`で指定された処理が終わったら、その先の処理が流れ出す
- `await`は、`async`キーワードによって変更された非同期メソッドでのみ使用できます。


まず、上記「メソッドの処理が終わる」の意味です。
`await`以降は`await`で指定した処理が終わるまで実行されない、と覚えておきましょう。

### hogeAsyncについて