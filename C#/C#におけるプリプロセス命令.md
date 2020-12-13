# プリプロセス命令 

- シンボル定義
    - `#define`
    - `#undef`
- 条件付きコンパイル
    - `#if`
    - `#else`
    - `#elif`
    - `#endif`
- エラー、警告の報告
    - `#warning`
    - `#error`
    - `#line`
- ソースコードの領域分け
    - `#region`
    - `#endregion`
- プラグマ
    - `#pragma`

参考：[C# によるプログラミング入門  [その他] プリプロセス](https://ufcpp.net/study/csharp/sp_preprocess.html)

## 概要
シンボル定義で定めたシンボルが存在するときに条件付きコンパイルが行える。  
例
``` cs
#define B

using System;

class PreProcessTest
{
  static void Main()
  {
#if A
    Console.Write("A という名前のシンボルが定義されています。\n");
#elif B
    Console.Write("B という名前のシンボルが定義されています。\n");
#endif
  }
}
```
普通にコンパイルした場合

```
B という名前のシンボルが定義されています。
```

コンパイルオプションに `/define:A` と指定してコンパイルした場合

```
A という名前のシンボルが定義されています。
```

## シンボル定義


## 条件付きコンパイル


## エラー、警告の報告


## ソースコードの領域分け


## プラグマ




