# LocalDBについて
## 参考
[LocalDB とは？ - Web/DB プログラミング徹底解説](https://www.keicode.com/dotnet/what-is-localdb.php)
[SQL Server Express LocalDB - SQL Server](https://docs.microsoft.com/ja-jp/sql/database-engine/configure-windows/sql-server-express-localdb?view=sql-server-ver15)
[SQLServer LocalDBにまつわる色々まとめ](https://qiita.com/s_saito/items/9c50e2c451948678399c)
[Visual Studio から SQL Server LocalDB へ接続するためのアレコレ - clock-up-blog](https://blog.clock-up.jp/entry/2016/07/27/vs-sqlserver-localdb)

## 概要
`LocalDB`とは、開発者のための開発用の`SQL Server Express`として、よりシンプルで小さいけれど、API レベルの互換性を保っている`SQL Server`。

- アプリケーションからは通常の (SQL Server に接続するのと同様の) クライアントサイドプロバイダーで接続可能。
- 複数の LocalDB へ接続する場合、それぞれのプロセスを起動する。
- LocalDB はサービスとして作成されない。
- `"Data Source=(localdb)\MSSQLLocalDB"`もしくは`"Data Source=(localdb)\ProjectsV13"` として接続することで接続でき、接続を試みるクライアントプロセスの子プロセスとして sqlservr.exe が起動される。 (接続文字列 `"Data Source=(localdb)\MSSQLLocalDB;Integrated Security=true"` で接続できる)

## 有効な LocalDB のインスタンス名を確認
ここが一番大事。
コマンドラインで `sqllocaldb info` を実行するとわかる。