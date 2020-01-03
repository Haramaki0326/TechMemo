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