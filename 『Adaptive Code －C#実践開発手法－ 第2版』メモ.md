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
**インスタンスの直接の生成は以下のような問題を抱える。**
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
        var userRepository = new UserRepository();
        var user = userRepository.GetByID(userID);
        this.securityService.ChangeUsersPassword(user, newPassword);
    }
}
```

### 実装を拡張することが不可能
`SecurityService`の実装を変更する場合にどうするか？対応方法としては、
- `SecurityService`のサブクラス`NewSecurityService`を作って、それを参照するように`AccountController`も変更するか。
- `SecurityService`を直接変更するか。

**→どちらにせよ、`SecurityService`を変更したら`AccountController`の再テストが必要になってしまう！**

### 依存関係の連鎖
1. `AccountController`が`SecurityService`と`UserRepository`の実装に永遠に依存する。
→`SecurityService`と`UserRepository`の実装が終わっていないと、`AccountController`のテストができない。
2. `SecurityService`と`UserRepository`の依存先が`AccountController`の暗黙的な依存先になっている。
→`SecurityService`と`UserRepository`の依存先の実装が終わっていないと、`AccountController`のテストができない。

### テスト容易性の欠如
`AccountController`のUTが非常に難しくなっている。
→ 上記2点の結果。
上記のコードでは`AccountController`はモックを使ってのUTが不可能。

### その他の不適切な関係（メソッドの引数が不適切）
→`AccountController`に限らず、`SecurityService.ChangeUsersPassword()`を利用するすべてのクライアントクラスに以下のように`User`オブジェクトの生成を任せることになっている
``` cs
        var userRepository = new UserRepository();
        var user = userRepository.GetByID(userID);
```
→本来は`SecurityService`がUserオブジェクトを作るべき

### 解決方法
- クラスAがAのクラス内で別クラス`ClassB`を参照している
  - → **AはBに依存している**。
- 別クラス`ClassB`を`new`で生成して直接参照している箇所に対して以下のリファクタリングを行う
  - まず`ClassB`のインターフェース`IClassB`を定義する
  - `IClassB`型のオブジェクトを利用するようにする
  - 次に`new`で生成するのではなく、コンストラクタで`IClassB`変数をもらってやり、`IClassB`フィールドに設定してやる（**依存性の注入**）

### After
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
    - `IFooService`
    - `FooService : IFooService`
    - `NullFooService : IFooService`
    - `IFooService FooRepository.GetById(FooId)`
  - 利用クラス `FooService` に対してインターフェイス `IFooService` を用意する
  - インターフェイス `IFooService` の実装として、1.通常クラス `FooService` と、2.Null Object クラス `NullFooService : IFooService`を用意する
    - 1. 通常のクラスにはそれまでのロジックを書いておく（とくに変更はしない）
    - 2. Null Object には利用するインスタンスがnullだった場合の、プロパティやメソッドのデフォルト値を書いておく
  - `IFooService FooRepository.GetById(FooId)` では、`FooService`が見つかったときはそのまま`FooService`を `Client` に戻し、見つからない場合は`NullFooService`を生成して戻す。
  - `Client` は `FooRepository.GetById(FooId)` で取得した `IFooService` のインスタンスに対し、Nullかどうかを気にせずプロパティやメソッドにアクセスして利用することができる。

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
// IFooService

public interface IUser
{
    void IncrementSessionTicket();

    string Name{ get; }
}
```
``` cs
// FooService : IFooService

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
// NullFooService : IFooService

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
// IFooService FooRepository.GetById(FooId)

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



# 第9章 リスコフの置換原則（LSP）

## 考え方の流れ
- 親クラス（Base）、子クラス（Derived）、呼び出し側（Client）
- リスコフの置換原則：ClientがBaseを利用している箇所すべてに対し子クラスで置換したとしても安全であるべきだ
- そのためには、BaseとDerivedとの間に、「is-a関係」が成り立っていなければならない
- 「is-a関係」は単純な単純にメソッドのシグネチャが同じであればいいわけではない
- クラスとしての責務を引き継がなければならない
- そこで用いられる具体的な基準が
  - 契約に関するルール（「事前条件」「事後条件」「不変条件」）
  - 変性に関するルール（「戻り値＝共変」「引数＝反変」）
    - 反変性の分かりやすい例としては、檜山のキマイラ飼育日記（「牛が牧草を食うのが共変継承なのか」）参照
    - 普通のクラスは共変（親クラスに子クラスを代入可能→ポリモーフィズム）
    - C#のオーバーライドメソッドに関して、その戻り値も引数も不変である。そのため、特別に対処する必要はない
    - C#でクラス変性を意識するのは、ジェネリックインターフェースとデリゲートに対してのみ。
- リスコフの置換原則を破ると、同時に「開放/閉鎖の原則」を破ることになる

## 9.1 リスコフの置換原則とは

### 正式な定義
**SがTの派生型であるとすれば、T型のオブジェクトをS型のオブジェクトと置き換えたとしても、プログラムは動作し続けるはずである。**

### 用語説明
#### ■ 基底型
クライアントが参照する型（T）。クライアントはさまざまなメソッドを呼び出し、そのどれもが派生型によてオーバーライド（部分的に特化）できます。

#### ■ 派生型
基底型（T）を継承するクラスファミリ（S）のいずれかのクラス。具体的にどの派生型を呼び出しいているのかをクライアントが知るべきではなく、知る必要もありません。クライアントの振る舞いは、与えられた派生型のインスタンスに関係なく、同じでなれければなりません。

#### ■ コンテキスト
クライアントが派生型を操作する方法。クライアントが派生型を操作しないとしたら、リスコフの置換原則に従うことも、違反することもあり得ません。


### リスコフの置換原則のルール
LSPを守るには、以下の2ルールを守る必要がある

#### コントラクトのルール
- 事前条件を派生型で強化することはできない
- 事後条件を派生型で緩和することはできない
- 基底型の不変条件は派生型でも維持されなければならない

#### 変性のルール
- 派生型のメソッドの引数には反変性がなければならない
- 派生型の戻り値の型には共変性がなければならない
- 既存の例外階層に含まれていない新しい例外を派生型からスローすることはできない


## 9.2 コントラクト
### 事前条件
- 事前条件は、「メソッドを失敗させずに確実に実行するために必要なすべての条件」
- 以下の例のように、メソッドの先頭にガード句を配置することで、事前条件を実装できる

``` cs
public decimal CalculateShippingCost(   float packageWeightInKillograms,
                                        Size<float> packageDimenstionsInInches,
                                        RegionInfo destination)
{
    if(packageWeightInKillograms <= 0f)
        throw new ArgumentOutOfRangeException("packageWeightInKillograms",
            "Package weight must be positive and non-zero");

    if(packageDimenstionsInInches.X <= 0f || packageDimenstionsInInches.Y <= 0f)
        throw new ArgumentOutOfRangeException("packageDimenstionsInInches",
            "Package dimensions must be positive and non-zero");

    return decimal.MinusOne;
}
```

### 事後条件
- 事後条件は、「メソッド終了時にオブジェクトが有効な状態のままであるかどうかをチェックするための条件」
- 以下の例のように、メソッドの最後にガード句を配置することで、事後条件を実装できる

``` cs
public virtual decimal CalculateShippingCost(   float packageWeightInKillograms,
                                        Size<float> packageDimenstionsInInches,
                                        RegionInfo destination)
{
    if(packageWeightInKillograms <= 0f)
        throw new ArgumentOutOfRangeException("packageWeightInKillograms",
            "Package weight must be positive and non-zero");

    if(packageDimenstionsInInches.X <= 0f || packageDimenstionsInInches.Y <= 0f)
        throw new ArgumentOutOfRangeException("packageDimenstionsInInches",
            "Package dimensions must be positive and non-zero");

    var shippingCost = decimal.One;

    // 送料の計算

    if(shippingCost <= decimal.Zero)
        throw new ArgumentOutOfRangeException("return",
            "The return value is out of range");

    return shippingCost;
}
```

### データ不変条件



## 9.3 共変性と反変性
- データ不変条件は、「オブジェクトのライフタイムにわたって変化しない述語のこと」
- オブジェクトが作成された時点で満たされ、オブジェクトがスコープを外れるまでその状態が維持されなければならない
- 以下の例のように、プロパティのセッターにガード句を配置することで、不変条件を実装できる

``` cs
public class ShippingStrategy
{
    public ShippingStrategy(decimal flatRate)
    {
        FlatRate = flatRate;
    }

    protected decimal flatRate;

    public decimal FlatRate
    {
        get
        {
           return flateRate;
        }

        set
        {
            if(value <= decimal.Zero)
                throw new ArgumentOutOfRangeException("value",
                    "Flat rate must be positive and non-zero");

            floatRate = value;
        }
    }
}
```
https://togetter.com/li/1405372
@tenjuu99 LSPが言ってるのは、派生クラスはシグネチャや構造が合ってさえいれば良いわけではなく、振る舞い仕様も継承しなさい、という話で、元々プログラマーが気を付けるべきガイドラインだと理解してます。(続

  
2019-09-12 22:46:08
たなかこういち @Tanaka9230
@tenjuu99 この理解を前提に、
自分がいいたいことは、、継承ツリー全てimmutableオブジェクトとして仕立てよというルールの元だったら、LSP違反な、つまり振る舞い仕様を継承してないような派生クラスというのは、（良心的に開発している限り）誤って作り出すことが無いのではないか、、ということとなります。