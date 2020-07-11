# 『Adaptive Code －C#実践開発手法－ 第2版』メモ
## 目次
### 第1部 アジャイル開発のフレームワーク
第1章 スクラムの紹介
第2章 カンバンの紹介

### 第2部 アダプティブコードの基礎
第3章 依存関係と階層化
第4章 インターフェイスとデザインパターン
第5章 テスト
第6章 リファクタリング

### 第3部 SOLIDコード
第7章 単一責務の原則
第8章 開放/閉鎖の原則
第9章 リスコフの置換原則
第10章 インターフェイス分離の原則
第11章 依存性反転の原則

### 第4部 アダプティブコードの適用
第12章 依存性の注入
第13章 結合性、凝集性、コナーセンス

# 第3章 依存関係と階層化
## 3.1 依存関係
### 依存関係には3つのレベルがある
- ファーストパーティの依存関係
  - アセンブリdll間の依存関係
- フレームワークの依存関係
  - `.NET Framework`のバージョン間の依存関係
- サードパーティの依存関係
  - `.NET Framework`とそれ以外のライブラリ間の依存関係

### 依存関係は有向グラフでモデル化できる

## 3.2 依存関係の管理
### newは不吉な臭い
- クラスAがAのクラス内で別クラス`ClassB`を参照している
  - → **AはBに依存している**。
- 別クラス`ClassB`を`new`で生成して直接参照している箇所に対して以下のリファクタリングを行う
  - まず`ClassB`のインターフェース`IClassB`を定義する
  - `IClassB`型のオブジェクトを利用するようにする
  - 次に`new`で生成するのではなく、コンストラクタで`IClassB`変数をもらってやり、`IClassB`フィールドに設定してやる（**依存性の注入**）

### 具体例
#### Before
``` cs
public class AccountController
{
    private readonly SecurityService securityService;

    public AccountController()
    {
        this.securityService = new SecurityService();
    }

    [HttpPost]
    public void ChangePassword(Guid userID, string newPassword)
    {
        var userRepository = new userRepository();
        var user = userRepository.GetByID(userID)
        user.ChangePassword(newPassword);
        this.securityService.ChangeUsersPassword(userID, newPassword);
    }
}
```


#### After
``` cs
public class AccountController
{
    private readonly ISecurityService securityService;

    public AccountController(ISecurityService securityService)
    {
        if(securityService == null)
        {
            throw new ArgumentNullException("securityService")
        }

        this.securityService = securityService;
    }

    [HttpPost]
    public void ChangePassword(Guid userID, string newPassword)
    {
        this.securityService.ChangeUsersPassword(userID, newPassword);
    }
}
```

``` cs
public class SecurityService : ISecurityService
{
    private readonly IUserRepository userRepository;

    public SecurityService(IUserRepository userRepository)
    {
        if(userRepository == null)
        {
            throw new ArgumentNullException("userRepository")
        }

        this.userRepository = userRepository;
    }

    public void ChangeUsersPassword(Guid userID, string newPassword)
    {
        var user = userRepository.GetByID(userID);
        user.ChangePassword(newPassword);
    }
}
```

## 3.3 階層化
### レイヤーとティア
- レイヤーは論理的な階層
- ティアは物理的な階層

### 2層アーキテクチャ
- ユーザーインターフェース層
- データアクセス層
- `ユーザーインターフェース` → `データアクセスのインターフェース`
- `データアクセスの実装` → `データアクセスのインターフェース`

### 3層アーキテクチャ
- ユーザーインターフェース層
- ビジネスロジック層
- データアクセス層

### 非対称な階層化（CQRSなど）


# 第4章 インターフェイスとデザインパターン
## 4.1 インターフェイスとは何か

## 4.2 アダプティブデザインパターン
### 4.2.1 Null Object パターン
#### 概要
- nullであるインスタンスのプロパティやメソッドを参照すると`NullReferenceException` 例外が発生する
- それを避けるために、クライアント側のコードにインスタンスがnullかどうかのif文を書く必要がある
- だが大量のnullチェックif文を書くのは煩雑
- それを避けるために以下のNull Object パターンを適用して、大量のnullチェックif文を書かなくてもよくする
  - 登場オブジェクトは以下の5つ
    - `Client`
    - `IFooServer`
    - `FooServer : IFooServer`
    - `NullFooServer : IFooServer`
    - `IFooServer FooRepository.GetById(FooId)`
  - 利用クラス `FooServer` に対してインターフェイス `IFooServer` を用意する
  - インターフェイス `IFooServer` の実装として、1.通常クラス `FooServer` と、2.Null Object クラス `NullFooServer : IFooServer`を用意する
    - 1. 通常のクラスにはそれまでのロジックを書いておく（とくに変更はしない）
    - 2. Null Object には利用するインスタンスがnullだった場合の、プロパティやメソッドのデフォルト値を書いておく
  - `IFooServer FooRepository.GetById(FooId)` では、`FooServer`が見つかったときはそのまま`FooServer`を `Client` に戻し、見つからない場合は`NullFooServer`を生成して戻す。
  - `Client` は `FooRepository.GetById(FooId)` で取得した `IFooServer` のインスタンスに対し、Nullかどうかを気にせずプロパティやメソッドにアクセスして利用することができる。

#### サンプルコード

``` cs
// Client

static void Main(string[] args)
{
    var user = userRepository.GetByID(Guid.NewGuid());

    // Null Objectパターンを適用しないと、ここで例外がスローされる
    user.IncremetSessionTicket();

    Console.WriteLine("The user's name is {0}", user.Name)
    Console.ReadKey();
}
```
``` cs
// IFooServer

public interface IUser
{
    void IncrementSessionTicket();

    string Name{ get; }
}
```
``` cs
// FooServer : IFooServer

public class User : IUser
{
    public string Name{
        get;
        private set;
    }

    public void IncrementSessionTicket()
    {
        sessionExpiry.AddMinutes(30);
    }

    private DateTime sessionExpiry;
}
```

``` cs
// NullFooServer : IFooServer

public class NullUser : IUser
{
    public string Name{
        get
        {
            return "unknown";
        }
    }

    public void IncrementSessionTicket()
    {
        // 何もしない
    }
}
```

``` cs
// IFooServer FooRepository.GetById(FooId)

public class UserRepository : IUserRepository
{
    public UserRepository()
    {
        users = new List<User>
        {
            new User(Guid.NewGuid()),
            new User(Guid.NewGuid()),
            new User(Guid.NewGuid()),
            new User(Guid.NewGuid())
        };
    }

    public IUser GetByID(Guid userID)
    {
        IUser userFound = users.SingleOrDefault(user => user.ID == userID);
        if(userFound == null)
        {
            userFound = new NullUser();
        }
        return userFound;
    }

    private ICollection<User> users;
}
```


### 4.2.2 Adapter パターン

### 4.2.3 Strategy パターン

## 4.3 さらなる汎用性を求めて

