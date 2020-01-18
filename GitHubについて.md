# GitHubについて
## VSCodeとの連携
[Visual Studio CodeでGitを利用する](https://www.atmarkit.co.jp/ait/articles/1507/21/news017.html)  
[GitHubに作成したレポジトリをVSCodeにプルからのプッシュするまで](https://qiita.com/qrusadorz/items/9916644e1af1453fe30b)  
[Visual Studio Code で Git を 使う](https://azriton.github.io/2017/08/23/Visual-Studio-Code%E3%81%A7Git%E3%82%92%E4%BD%BF%E3%81%86/)

## Markdownでコードの折りたたみポイント
Markdownを使ってコードを折りたたんで表示するには少しコツがいる。
要点は以下。

- `<details>`タグで囲む
- `<summary>`タグで折りたたみタイトルを表示
- `<summary>`タグのあとは空行を1行いれる。
- あとは既存通り（` ``` `タグでコードを囲めばよい）

### だめな例
空行をいれないと正常に表示されない
```
NG例(\ は置換する)
<details>
<summary>折りたたみ部分</summary>
\``` cs
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace MyFirstMVC.Models
{
	public class SampleModel
	{
		public int Id { get; set; }

		[DisplayName("bool型(DataType無指定)")]
		public bool CheckBox_sample { get; set; }
	}
}
\```
</details>
```

### よい例
空行をいれると以下のように正常に表示される
```
OK例(\ は置換する)
<details>
<summary>折りたたみ部分</summary>

\``` cs
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace MyFirstMVC.Models
{
	public class SampleModel
	{
		public int Id { get; set; }

		[DisplayName("bool型(DataType無指定)")]
		public bool CheckBox_sample { get; set; }
	}
}
\```
</details>
```

### 実際の表示例
<details>
<summary>折りたたみ部分</summary>

``` cs
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace MyFirstMVC.Models
{
	public class SampleModel
	{
		public int Id { get; set; }

		[DisplayName("bool型(DataType無指定)")]
		public bool CheckBox_sample { get; set; }
	}
}

```
</details>