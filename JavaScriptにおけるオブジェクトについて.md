# JavaScriptにおけるオブジェクトについて
## キーワード
- [新しいオブジェクトの作成 - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Guide/Creating_New_Objects)
  - オブジェクト初期化子
  - コンストラクタ関数
    - [コンストラクタ関数の使用 - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Guide/Creating_New_Objects/Using_a_Constructor_Function)
    - [コンストラクタ 演算子 new](https://ja.javascript.info/constructor-new)
- プロトタイプ
  - [図で理解するJavaScriptのプロトタイプチェーン - Qiita](https://qiita.com/howdy39/items/35729490b024ca295d6c)
  - [や...やっと理解できた！JavaScriptのプロトタイプチェーン - maeharinの日記](https://maeharin.hatenablog.com/entry/20130215/javascript_prototype_chain)
  - [JavaScriptのprototypeを理解する｜TECH PLAY Magazine ［テックプレイマガジン](https://techplay.jp/column/618)
  - [Javascriptでオブジェクト指向するときに覚えておくべきこと - Qiita](https://qiita.com/awakia/items/8ff451ca5f8ae0122be7)

## オブジェクトとは
https://ja.javascript.info/object
https://ja.javascript.info/object-methods

## オブジェクトの初期化
### オブジェクト初期化子（リテラル）
コンストラクタ関数を使用してオブジェクトを作成する方法だけではなく、オブジェクト初期化子を使用してもオブジェクトを作成することができます。オブジェクト初期化子を使うことはリテラル表示を用いてオブジェクトを作成するということです。

オブジェクト初期化子を使用したオブジェクトの構文は次のとおりです。

``` js
var obj = { property_1:   value_1,   // property_# は識別子でもよい
            2:            value_2,   // あるいは数値でもよい
            ...,
            "property_n": value_n }; // あるいは文字列でもよい
```
ここで、`obj` は新しいオブジェクトの名前を、各 `property_i` は識別子（名前、数値、文字列リテラルのいずれか）を、各 `value_i` はその値を `property_i` に代入する式をそれぞれ表しています。`obj` および代入部分はなくてもかまいません。このオブジェクトを別の場所で参照する必要がないのであれば変数に代入する必要はありません。（文が期待されているところにオブジェクトリテラルを置く場合、リテラルを丸括弧で囲み、ブロック文と間違われないようにする必要があるかもしれません。）

トップレベルのスクリプトでオブジェクト初期化子を使用してオブジェクトを作成した場合、JavaScript はオブジェクトリテラルを含む式を評価するたびにそのオブジェクトを解釈します。さらに、関数内で使用された初期化子はその関数が呼び出されるたびに作成されます。

次の例は 3 つのプロパティを持つ `myHonda` を作成します。engine プロパティは自らもプロパティを持つオブジェクトでもあることに注意してください。

``` js
myHonda = {color:"red",wheels:4,engine:{cylinders:4,size:2.2}};
```
オブジェクト初期化子を使用して配列を作成することもできます。配列リテラル を参照してください。

### コンストラクタ関数
#### 説明1
もう 1 つの方法として、次の 2 つのステップでオブジェクトを作成することができます。

1. コンストラクタ関数を書くことでオブジェクトの種類を定義する。頭文字は大文字にする。（慣習）
2. `new` を用いてそのオブジェクトのインスタンスを作成する。

オブジェクトの種類を定義するために、その名前、プロパティ、メソッドを定義する関数を作成する必要があります。例えば、車についてのオブジェクトの種類を作成したいとします。そしてこの種類のオブジェクトに Car という名前を付け、make、model、および year というプロパティを持たせたいとします。こうするためには次のような関数を書きます。

``` js
function Car(make, model, year) {
   this.make = make;
   this.model = model;
   this.year = year;
}
```

関数に渡された値に基づいてオブジェクトのプロパティに値を代入するために `this` を使用しています。
すると、次のようにして mycar というオブジェクトを作成することができるようになります。

``` js
mycar = new Car("Eagle", "Talon TSi", 1993);
```

この文は mycar を作成し、そのプロパティ用に指定した値を代入します。その結果、mycar.make の値は "Eagle" という文字列、mycar.year は 1993 という整数というようになります。

new を呼び出すことで car オブジェクトをいくらでも作ることができます。

``` js
kenscar = new Car("Nissan", "300ZX", 1992);
vpgscar = new Car("Mazda", "Miata", 1990);
```
それ自身別のオブジェクトであるというようなプロパティを持つオブジェクトを作ることができます。例えば、次のように person というオブジェクトを定義するとします。

``` js
function Person(name, age, sex) {
   this.name = name;
   this.age = age;
   this.sex = sex;
}
```
そして、次のように 2 つの新しい Person オブジェクトのインスタンスを作成します。

``` js
rand = new Person("Rand McKinnon", 33, "M");
ken = new Person("Ken Jones", 39, "M");
```
次のようにして、Car の定義を書き換えて、Person オブジェクトをとる owner プロパティを持たせることができます。

``` js
function Car(make, model, year, owner) {
   this.make = make;
   this.model = model;
   this.year = year;
   this.owner = owner;
}
```
新しいオブジェクトのインスタンスを作成するために、次のようにします。

``` js
car1 = new Car("Eagle", "Talon TSi", 1993, rand);
car2 = new Car("Nissan", "300ZX", 1992, ken);
```
新しいオブジェクトの作成時に文字列リテラルや整数値を渡す代わりに、上記の文ではオブジェクト rand および ken を所有者を表す引数として渡しています。car2 の所有者の名前を知りたい場合は次のプロパティにアクセスすることで可能になります。

``` js
car2.owner.name
```
以前に定義したオブジェクトにいつでもプロパティを追加できることに注意してください。例えば次の文

``` js
car1.color = "black"
```
はプロパティ color を car1 に追加し、それに "black" という値を代入します。しかしながら、この方法では他のどのオブジェクトにも影響を与えません。同じ種類の全オブジェクトに新しいプロパティを追加するには、そのプロパティを car というオブジェクトの種類の定義に追加する必要があります。


#### 説明2
通常 `{...}` 構文で1つのオブジェクトを作ることができます。しかし、しばしば多くの似たようなオブジェクトを作る必要があります。例えば複数のユーザやメニューアイテムなどです。

それは、コンストラクタ関数と `new` 演算子を使うことで実現できます。
コンストラクタ関数は技術的には通常の関数です。それには2つの慣習があります:

1. 先頭は大文字で名前付けされます。
2. `new` 演算子を使ってのみ実行されるべきです。

例:
``` js
function User(name) {
  this.name = name;
  this.isAdmin = false;
}

let user = new User("Jack");

alert(user.name); // Jack
alert(user.isAdmin); // false
```

`new User(...)` として関数が実行されたとき、次のようなステップになります:

新しい空のオブジェクトが作られ、 `this` に代入されます。
関数本体を実行します。通常は `this` を変更し、それに新しいプロパティを追加します。
`this` の値が返却されます。
つまり、`new User(...)` は次のようなことをします:

``` js
function User(name) {
  // this = {};  (暗黙)

  // this へプロパティを追加
  this.name = name;
  this.isAdmin = false;

  // return this;  (暗黙)
}
```

なので、`new User("Jack")` の結果は次と同じオブジェクトです:

``` js
let user = {
  name: "Jack",
  isAdmin: false
};
```

さて、もし他のユーザを作りたい場合、new User("Ann"), new User("Alice") と言ったように呼ぶことができます。毎回リテラルを使うよりはるかに短く、また簡単で読みやすいです。

再利用可能なオブジェクト作成のコードを実装すること、それがコンストラクタの主な目的です。

改めて留意しましょう、技術的にはどんな関数もコンストラクタとして使うことができます。つまり、どの関数も new で実行することができ、上のアルゴリズムで実行されるでしょう。“先頭が大文字” は共通の合意であり、関数が new で実行されることを明確にするためです。

new function() { … }
1つの複雑なオブジェクトの作成に関する多くのコードがある場合、コンストラクタ関数でそれをラップすることができます。このようになります:

let user = new function() {
  this.name = "John";
  this.isAdmin = false;

  // ...ユーザ作成のための他のコード。
  // 複雑なロジック、文やローカル変数などを持つかもしれません。
};
コンストラクタはどこにも保存されず、単に作られて呼び出されただけなので2度は呼び出せません。なので、このやり方は将来再利用することなく、単一のオブジェクトを構成するコードをカプセル化することを目指しています。

##### コンストラクタからの返却
通常、コンストラクタは `return` 文を持ちません。コンストラクタの仕事は必要なものをすべて this の中に書くことです。それが自動的に結果になります。

しかし、もし `return` 文があった場合はどうなるでしょう。ルールはシンプルです:

もし `return` がオブジェクトと一緒に呼ばれた場合、`this` の代わりにそれを返します。
もし `return` がプリミティブと一緒に呼ばれた場合、それは無視されます。
言い換えると、オブエジェクトの`return` はそのオブジェクトを返し、それ以外のケースでは `this` が返却されます。

例えば、ここで `return` は オブジェクトを返却することで、`this` を上書きします:

``` js
function BigUser() {

  this.name = "John";

  return { name: "Godzilla" };  // <-- オブジェクトを返す
}

alert( new BigUser().name );  // Godzilla, オブジェクトを取得 ^^
```
また、これは空の `return` の例です(`return` の後に プリミティブを置いた場合も同じです)

``` js
function SmallUser() {

  this.name = "John";

  return; // 実行が終了し, this を返す

  // ...

}

alert( new SmallUser().name );  // John
```
通常、コンストラクタは `return` 文を持ちません。ここでは、主に完全性のためにオブジェクトを返す特殊な動作について説明しています。

**丸括弧の省略**  
ところで、もし引数を取らない場合は、`new` の後の丸括弧を省略することもできます。

``` js
let user = new User; // <-- 括弧なし
// これと同じ
let user = new User();
```
丸括弧の省略は “良いスタイル” ではありませんが、仕様では許可されています。

##### コンストラクタの中のメソッド
オブジェクトを作るとき、コンストラクタ関数を使用することで高い柔軟性を得ることができます。コンストラクタ関数はオブジェクトがどのように組み立てられるか、その中に何を置くかを定義するパラメータを持っています。
もちろん、this にプロパティだけでなく、同様にメソッドも追加することができます。
例えば、下の new User(name) は name と メソッド sayHi を持つオブジェクトを作ります:

``` js
function User(name) {
  this.name = name;

  this.sayHi = function() {
    alert( "My name is: " + this.name );
  };
}

let john = new User("John");

john.sayHi(); // My name is: John

/*
john = {
   name: "John",
   sayHi: function() { ... }
}
*/
```



#### サンプル
``` js
// パターン1
// ES2015以前の基本的なコンストラクタ関数
function Animal(name){
    this.name = name;
    this.toString = function(){
        return 'Animal:' + this.name;
    };
};

var ani = new Animal('トクジロウ')
console.log(ani.name);
console.log(ani.toString());


// パターン2
// コンストラクタ関数を変数に代入している
var Animal = function(name){
    this.name = name;
    this.toString = function(){
        return 'Animal:' + this.name;
    };
};

var ani = new Animal('トクジロウ')
console.log(ani.name);
console.log(ani.toString());

// パターン3
// インスタンスの生成も同時に行っている。
// この場合、コンストラクタ名が定義されていないので、1度きりの利用が想定される
var ani = new function(name = 'トクジロウ'){
    this.name = name;
    this.toString = function(){
        return 'Animal:' + this.name;
    };
};

console.log(ani.name);
console.log(ani.toString());

```


## 関数もオブジェクト
https://ja.javascript.info/function-basics  
https://ja.javascript.info/function-expressions  
https://ja.javascript.info/function-object  


## プロトタイプ