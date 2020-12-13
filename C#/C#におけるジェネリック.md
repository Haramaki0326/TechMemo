# C#におけるジェネリック

## 参考
[ジェネリック - C# によるプログラミング入門 | ++C++; // 未確認飛行 C](https://ufcpp.net/study/csharp/sp2_generics.html)

## ジェネリックメソッド
### 構文
```
アクセスレベル 戻り値の型 メソッド名<型引数>(引数リスト)
  where 型引数中の型が満たすべき条件
{
  メソッド定義
}
```

### 例
次の Swap メソッドは，任意のデータ型について使うことはできません。
例えば，この Swap メソッドは文字列型について値を交換することはできません。
``` cs
static void Swap(ref double a, ref double b)
{
    double temp = a;
    a = b;
    b = a;
}
```
次の `Swap<T>` メソッドは，任意のデータ型について値の交換ができるようにしたものです。
このように，型パラメータ T を持ったクラスやメソッドを，ジェネリクス (generics) といいます。

``` cs
static void Swap<T>(ref T a, ref T b)
{
    T temp = a;
    a = b;
    b = a;
}

static void Main()
{
    int m = 1, n = 2;
    Swap<int>(ref m, ref n);
}
```
型パラメータ `T` は，メソッド名の直後に `Swap<T>` のように書きます。
型パラメータが複数必要であれば，`Swap<T, U>` のように書けばいいです。

## ジェネリッククラス
### 構文
```
class クラス名<型引数>
  where 型引数中の型が満たすべき条件
{
  クラス定義
}
```

### 例
上の例では、メソッドに対して定義しました。
ジェネリックはクラスに対しても定義する事が出来ます。
``` cs
public class Array<T>
{
    private T[] m_Items;
 
    public void Set(int index, T item)
    {
        m_Items[index] = item;
    }
 
    public T Get(int index)
    {
        return m_Items[index];
    }
}
```
クラス名の後に`<>`を付けています。
クラス内のメンバ変数やメソッドの引数、戻り値などで利用できます。

## 型制約

