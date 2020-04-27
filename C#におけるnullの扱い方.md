# C#におけるnullの扱い方
[null許容値型(Nullable&amp;lt;T&amp;gt; 型) - C# によるプログラミング入門 | ++C++; // 未確認飛行 C](https://ufcpp.net/study/csharp/sp2_nullable.html)
[null の取り扱い - C# によるプログラミング入門 | ++C++; // 未確認飛行 C](https://ufcpp.net/study/csharp/rm_nullusage.html)
[C# 8 で null 安全が導入されるらしいので、??（null 合体演算子）、?. ?[]（null 条件演算子）を復習する - Qiita](https://qiita.com/Nossa/items/1fd4881a0b97a5f32901)


## 前提
- C#では値型（`int`や`struct`など）はnull値は取れません。
- 値型でnull値をとるにはnull許容値型（int?など?をつける）を使います。
- 一方、参照型（`string`や`class`など）はデフォルトでnull許容型であり、null値の許容、非許容が区別されていません。

## null許容型
intなどは本来nullは代入できない

``` cs
int num = null; //エラー
int? num = null; //エラーにならない
```

`T?` という書き方で得られる null 許容型は、 コンパイル結果的には、`Nullable<T>`構造体(System名前空間) と等価になります。 例えば、以下の2つの変数x と y は全く同じ型の変数になります。
``` cs
int? x;
Nullable<int> y;
```
## null条件演算子（`?.`、`?[]`）
`?.`、`?[]`はnull条件演算子と呼ばれています。
`?.`、`?[]`はメンバーやインデックスのアクセスの前に、左辺がnullかどうかテストしnullでない場合、アクセスが行われます。
左辺が`null`の場合、`null`が返ります。

下記のコードは`user`が`null`でない場合、`Name`の値が返り、`null`の場合には`null`を返します。
`user`が`null`でも`NullReferenceException`は発生しません。
``` cs
var name = user?.Name;
```
また下記のコードも`users`（Userのコレクションを想定）が`null`でも`NullReferenceException`が発生しません。
``` cs
var second = users?[1];
```
if文や`?:`（三項演算子）を使った場合に比べて読みやすいと思います。
``` cs
// if 文
string name;
if (user != null) name = user.Name;

// 三項演算子
var name = (user == null) ? null : user.Name;
```
## null合体演算子（`??`）
``` cs
// x が null の場合、y が代入される。
z = x ?? y;

//こんな風に使う
int? hoge;
〜
int hage = hoge ?? 0;

```

## null条件演算子（`?.`）とnull合体演算子（`??`）の合わせ技
`?.` `??` を組み合わせて使うこともできます。
userがnullの場合、"名無しの権兵衛"、nullでない場合Nameの値が返ります。
``` cs
var user = TryGetUser();
string name = user?.Name ?? "名無しの権兵衛"
```

## Option型
難しいのでパス