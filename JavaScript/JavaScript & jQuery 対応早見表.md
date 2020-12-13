# JavaScript & jQuery 対応早見表
## 参考
- [【脱jQuery】JavaScriptをネイティブで書くときのあれこれTips](https://www.willstyle.co.jp/blog/1025/)
- [jQuery→JavaScript書き換え一覧表](https://qiita.com/okame_qiita/items/d8d85906b88e33ba0eff)

## 要素の取得
### ID
IDはDocument内に1つというルールがあるので取得は`getElementById`で取得するのが手っ取り早いでしょう。
``` js
// jQuery
let hoge = $('#hoge'); // jQuery Object
// Native
let hoge = document.getElementById('hoge'); // element
```

### Tag・Class
TagやClassの取得はDocument内に複数存在するので取得は`getElementsByTagName`、`getElementsByClassName`となり、取得した値はHTMLCollection（配列）になります。
``` js
// jQuery
let div = $('div'); // jQuery Object
let fuga = $('.fuga'); // jQuery Object
// Native
let div = document.getElementsByTagName('div'); // HTMLCollection
let fuga = document.getElementsByClassName('fuga'); // HTMLCollection
// fuga[0] = .fugaの最初の要素
```


### Selectors API
jQueryのセレクタのような、より複雑な指定ができるAPIが存在します。
注意点としては、最初に合致したHTML要素を取得した時点でプログラムは終了するという点です。
つまり、複数の要素を取得するには自作のループ処理を作成するか、後述する`querySelectorAll()`を使う必要があります。

``` js
// jQuery
let hoge = $('#hoge'); // jQuery Object
// Native
let hoge = document.querySelector('#hoge'); // element
```
Classのように複数存在するものはquerySelectorAllで指定します。
同じく、取得した値はNodeList（配列）になります。

``` js
// jQuery
let fuga = $('.fuga'); // jQuery Object
// Native
let fuga = document.querySelectorAll('.fuga'); // NodeList
```
ただし、**querySelectorやquerySelectorAllは速度の面で劣るため、単純な要素の取得にはgetElementByIdやgetElementsByClassNameを使用することを推奨**します。


### 検索
`find()`のような指定も可能です。
``` js
// jQuery
let link = $('#hoge').find('a'); // jQuery Object
// Native
let link = document.getElementById('hoge').getElementsByTagName('a'); // HTMLCollection
let link = document.querySelector('#hoge').querySelectorAll('a'); // NodeList
```

### 取得した要素の存在チェック
jQueryオブジェクトは取得した要素に変更を加えようとした際に、取得した要素が存在しない場合でもプロパティ自体は存在するのでエラーを返さず特に何も起こりませんが、ネイティブでは要素が存在しない場合にnullを返すため、エラーになってしまうので必ず存在チェックを行いましょう。
``` js
let hoge = document.getElementById('hoge');
if(hoge){
  // #hogeが存在すれば実行される
}
```

### HTMLCollectionとNodeListの違い
getElementsByTagNameやgetElementsByClassNameの返り値はHTMLCollectionでquerySelectorAllの返り値はNodeListとなっています。
この違いはHTMLCollectionは動的であり、NodeListは静的であるということです。
つまり、DOMに変更を加えた際に取得した値が動的に変更されるのがHTMLCollectionで、取得した値が変更されないのがNodeListということに注意が必要です。

## イベントの操作
jQueryでは.on() .off()でイベントハンドラの登録、削除が簡単におこなえました。
これはネイティブとの差はそれほどありません。

### 登録
``` js
// jQuery
$('#hoge').on('click',function(){
  // click event
});

// Native
document.getElementById('hoge').addEventListener('click',function(){
  // click event
},false);
```

### 削除
``` js
// jQuery
$('#hoge').off('click');
// Native
document.getElementById('hoge').removeEventListener('click');
```

## クラスの操作
jQueryではクラスの操作を行うメソッドは.hasClass() .addClass() .removeClass() .toggleClass()がありました。
これもネイティブとの違いはそれほどありません。

### 存在の確認
``` js
// jQuery
$('#hoge').hasClass('fuga'); // bool
// Native
document.getElementById('hoge').classList.contains('fuga'); // bool
```

### 追加
``` js
// jQuery
$('#hoge').addClass('fuga');
// Native
document.getElementById('hoge').classList.add('fuga');
```

### 削除
``` js
// jQuery
$('#hoge').removeClass('fuga');
// Native
document.getElementById('hoge').classList.remove('fuga');
```

### トグル
``` js
// jQuery
$('#hoge').toggleClass('fuga');
// Native
document.getElementById('hoge').classList.toggle('fuga');
```

## 属性の操作
jQueryでは属性の操作を行うメソッドは.attr() .removeAttr() がありました。
.attr()のみで取得と設定どちらも出来ていましたがネイティブではsetとgetがあることに注意してください。

### 取得
``` js
// jQuery
$('#hoge').attr('href');

// Native
// element.getAttribute(属性名)
document.getElementById('hoge').getAttribute('href');
```

### 設定
``` js
// jQuery
$('#hoge').attr('href','https://www.willstyle.co.jp');

// Native
// element.setAttribute(属性名, 属性値)
document.getElementById('hoge').setAttribute('href','https://www.willstyle.co.jp');
```

### 削除
``` js
// jQuery
$('#hoge').removeAttr('href');
// Native
document.getElementById('hoge').removeAttribute('href');
```

## スタイルの操作
jQueryではスタイルの操作を行うメソッドは.css() でした。
ネイティブではメソッドではなくオブジェクトを直接変更することに注意してください。
その際のスタイルのプロパティ名はキャメルケース（プロパティ内のハイフンを削除し、次の頭文字を大文字に）で表記します。

### 取得
``` js
// jQuery
$('#hoge').css('background-color');
// Native
document.getElementById('hoge').style.backgroundColor;
```

### 設定
``` js
// jQuery
$('#hoge').css('background-color','red');
// Native
document.getElementById('hoge').style.backgroundColor = 'red';
```

## ループ処理
jQueryでは.each()という便利な関数がありましたが、ネイティブではfor…ofもしくはfor文を使います。

``` js
// jQuery
$('.hoge').each(function(i){
  // $(this)で現在の要素を指定
})
// Native
let fuga = document.getElementsByClassName('fuga');
for (let elm of fuga) {
  // elmで現在の要素を指定
}
```

ただしfor…ofはIE未対応のためしばらくはfor文で書きましょう。

### for文
``` js
// Native
let fuga = document.getElementsByClassName('fuga');
for (let i = 0; i < fuga.length; i++) {
  // fuga[i]で現在の要素を指定
}
```
