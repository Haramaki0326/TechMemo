# ループ処理の方法 ～ for, forEach, for-of ～ 


## 配列
## 連想配列
## オブジェクト
## jQueryでの`.each`
## アロー関数
## forEachは最後の手段

## 参考
[配列をループで処理する (for, forEach, for-of) | まくまくJavaScriptノート](https://maku77.github.io/js/array/loop.html)


## for-of を使う方法 (ECMAScript 2015)
``` js
var arr = ['AAA', 'BBB', 'CCC'];

for (const elem of arr) {
  console.log(elem);
}
```
ECMAScript 2015 以降は、配列をループ処理したいときは for-of の構文を使うのがシンプルです。

## forEach を使う方法 (ECMAScript 2015)
`Array.forEach()` を使用すると、指定したコールバック関数が要素ごとに呼び出されます。

``` js
const arr = ['AAA', 'BBB', 'CCC'];
arr.forEach(function(elem, index) {
  console.log(index + ': ' + elem);
});
```
アロー関数を使って次のように記述することもできます。

``` js
const arr = ['AAA', 'BBB', 'CCC'];
arr.forEach((elem, index) => {
    console.log(`${index}: ${elem}`);
});
```
インデックスが必要ないのであれば、次のようにするだけで OK です。

``` js
arr.forEach(elem => console.log(elem));
```
forEach のループ処理の中（コールバック関数の中）で return しても、forEach を呼び出している側の関数からは return できないという点に注意してください。 コールバック関数の中で return するだけになるので、ループ処理の中断も行われません。

ループ中に break や return を呼び出したい場合は、インデックスによる単純な for ループか、for-of ループを使うのが直感的です。

## for ループを使う方法（旧来のやり方）
``` js
const arr = ['AAA', 'BBB', 'CCC'];
for (let i = 0; i < arr.length; ++i) {
  console.log(arr[i]);
}
```
初期の JavaScript で使われていた配列のループ処理方法です。 for ... in を使ってループ処理を行うこともできますが、その場合は「オブジェクトのプロパティ」の列挙になってしまうので、配列のループ処理を行うには、上記のようにインデックスで回すのが正解です。

ECMAScript 2015 以降では var ではなく let を使ってループ変数 i のスコープを絞りましょう。

## jQuery の $.each を使う方法（おまけ）
``` js
const arr = ['AAA', 'BBB', 'CCC'];
$.each(arr, function(index, elem) {
  console.log(index + ': ' + elem);
});
```
実行結果
0: AAA
1: BBB
2: CCC