# \<form\>, \<input\>, value について
## 参考
[【初心者向け】0からformがわかる｜HTMLでのフォーム作成](https://webliker.info/79009/)
[\<input\>の使い方とtype属性の一覧をサンプル付きで紹介](https://webliker.info/39533/)
![](/img/formタグについて.png)


## 概要
### actionとmethod
``` html
<form action="confirm.php" method="post">
  ここにテキストフィールドやチェックボックスなどのhtmlタグを書いていく
</form>
```
- `action`には送信ボタンを押したあとに移動するページのURLを記入
- `method`にはフォームの入力内容のデータの送信形式を指定します。GETとPOSTの2種類がある。

### フォーム項目の種類
### `<input>`タグを用いるもの
![](/img/input属性一覧.png)
#### テキストフィールド
``` html
名前：<input type="text" name="yourname">
```
inputではtype="〇〇"に書く内容によって表示されるテキストフィールドの種類を指定します。今回は通常のテキスト入力欄をつくるためにtype="text"としました。
その他にも数字専用の入力フィールドにするならtype="number"やメールアドレスの入力フィールドにするならtype="email"などがあります。

#### ラジオボタン
``` html
<p>性別を選択</p>
<input id="male" type="radio" name="sex" value="male"><label for="male">男性</label>
<input id="female" type="radio" name="sex" value="female"><label for="female">女性</label>
```
ラジオボタンを表示するにはinputのtype属性をtype="radio"とします。labelについてはテキストフィールドと同じように、idとforを同じにすることで項目とチェックボタンを連動させることができます。

#### チェックボックス
``` html
<p>好きなスポーツ</p>
<input id="football" type="checkbox" name="sport" value="サッカー"><label for="football">サッカー</label>
<input id="baseball" type="checkbox" name="sport" value="野球"><label for="baseball">野球</label>
<input id="basketball" type="checkbox" name="sport" value="バスケ"><label for="basketball">バスケ</label>
```
チェックボックスを表示するにはinputのtype属性をtype="checkbox"とします。
ラジオボタンと同じくlabelのforとinputのidを同じにすることで項目とチェックボックスを連動させることができます。

### テキストエリア
``` html
<label for="comment">コメント</label>
<textarea id="comment" name="comment"></textarea>
```
### セレクトボックス
``` html
<select name="sushi">
  <option value="magro">まぐろ</option>
  <option value="ika">いか</option>
  <option value="ebi">えび</option>
</select>
```

