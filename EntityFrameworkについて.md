# EntityFrameworkについて
## 参考
- [第2回　Entity Frameworkコード・ファーストでモデル開発](https://www.atmarkit.co.jp/fdotnet/aspnetmvc3/aspnetmvc3_03/aspnetmvc3_03_01.html)

## 手順
- モデル・クラス（＝エンティティ）の定義
- コンテキスト・クラスの定義
- イニシャライザの準備
- コントローラ、ビューの作成

## モデル・クラス（＝エンティティ）の定義
``` cs
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MvcApp.Models
{
  public class Book
  {
    [Key]
    public string Isbn { get; set; } // ISBNコード
    public string Title { get; set; } // 書名
    public int? Price { get; set; } // 価格
    public string Publish { get; set; } // 出版社
    public DateTime Published { get; set; } // 刊行日

    public virtual ICollection<Review> Reviews { get; set; } // レビュー
  }
}
```

``` cs
using System;

namespace MvcApp.Models
{
  public class Review
  {
    public int ReviewId { get; set; } // レビューID
    public string Title { get; set; } // レビュータイトル
    public string Body { get; set; } // レビュー本文
    public DateTime CreatedAt { get; set; } // 投稿日
  }
}
```

- クラス（単数形）は、同名のテーブル（複数形）にマッピングされる
- プロパティは、同名のテーブル列にマッピングされる
- 主キーは、Id、または＜クラス名＞Idという名前がデフォルト（例：ReviewId）
- 上記以外の主キーを定義するには、Key属性（System.ComponentModel.DataAnnotations名前空間）を付けてプロパティを定義する（例：Isbn）
- nullを許容する値型の列は、null許容型で指定する（例：Price）
-ナビゲーション・プロパティは、同名のエンティティにマッピングされる（例：Reviews）


ナビゲーション・プロパティとは、あるエンティティと関連（アソシエーション）を持った、別のエティティを参照するためのプロパティのこと。
Bookエンティティで定義されたReviewsプロパティがそれだ。BookエンティティとReviewエンティティとは1：nの関係にあるので、ナビゲーション・プロパティはICollection<エンティティ>型であり、名前もReview“s”と複数形になる点にも注目してほしい。


## コンテキストクラスの定義
エンティティが定義できたところで、この何の変哲もないPOCOをデータベースに接続する――橋渡しの役目を果たすのがコンテキスト・クラス（System.Data.Entity.DbContextクラスの派生クラス）だ。

``` cs
using System.Data.Entity;

namespace MvcApp.Models
{
  public class MyMvcContext : DbContext
  {
    public DbSet<Book> Books { get; set; } // Booksテーブル
    public DbSet<Review> Reviews { get; set; } // Reviewsテーブル
  }
}
```

エンティティとテーブルとをマッピングするために、**DbSet<エンティティ>型**のパブリック・プロパティ（名前はエンティティ名の複数形）を定義する。
これによって、コンテキスト・クラス`MyMvcContext`の`Books`、`Reviews`プロパティは、同名の`Books`、`Reviews`テーブルにアクセスし、その結果をレコード単位に`Book`、`Review`エンティティのインスタンスに割り当てることになる。先ほども述べたように、テーブルの各列（フィールド）は、それぞれエンティティの対応するプロパティにマッピングされる。



## イニシャライザの準備
todo

## コントローラ、ビューの作成
todo
