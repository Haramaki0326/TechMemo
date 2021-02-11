;------------------------------------------------------------------------------
;   前提：
;       日本語, 英語キーボードどちらでも使用可能
;       英語キーボードの場合、変換・無変換キーが存在するUS配列として扱えるAX配列を利用する
;   参考：
;       https://www.atmarkit.co.jp/ait/articles/0001/26/news001.html
;    Change Key使用：
;       日本語キーボードの場合
;           Caps Lock -> Ctrl
;       英語キーボードの場合
;           Caps Lock -> Ctrl
;           左Alt -> スキャンコード005A(AX配列における変換)
;           右Alt -> スキャンコード005B(AX配列における無変換)
;           Menuキー -> 左Alt
;   Google IME使用
;       変換 = IMEオン
;       無変換 = IMEオフ
;  基本方針：
;    ・効率化のため、ホームポジションからできるだけ手を動かさずに（マウスも使わずに）作業したい
;    ・効率化のためのショートカットなのに、習得コストが大きいと本末転倒
;    ・したがって関連付けで覚えやすい／思い出しやすいショートカットにする
;    ・変換キー（右親指）と左手キー、無変換キー（左親指）と右手キーの組み合わせが押しやすい
;  使い方：
;     最初に第１弾を有効にして使ってみる
;     すぐに思い出せるくらい使いこなせるようになったら第２弾以降を使ってみる
;     使い勝手の良い組み合わせを探してチューニングする
;  参考：
;    https://gist.github.com/kondei/87b5f783a6f84a653790
;    http://pheromone.hatenablog.com/entry/20130603/1370276768
;------------------------------------------------------------------------------
;  はじめに 実行準備
;------------------------------------------------------------------------------

; キーリピートの早いキーボードだと警告が出るので設定
#HotkeyInterval 100

; 主要なキーをホットキーとして検知可能にしておく
; A_ThisHotkey で検知可能にするための記述
; 検知だけしてAutoHotKey側では何も処理しない
*~a::
*~b::
*~c::
*~d::
*~e::
*~f::
*~g::
*~h::
*~i::
*~j::
*~k::
*~l::
*~m::
*~n::
*~o::
*~p::
*~q::
*~r::
*~s::
*~t::
*~u::
*~v::
*~w::
*~x::
*~y::
*~z::
*~1::
*~2::
*~3::
*~4::
*~5::
*~6::
*~7::
*~8::
*~9::
*~0::
*~F1::
*~F2::
*~F3::
*~F4::
*~F5::
*~F6::
*~F7::
*~F8::
*~F9::
*~F10::
*~F11::
*~F12::
*~`::
*~~::
*~!::
*~@::
*~#::
*~$::
*~%::
*~^::
*~&::
*~*::
*~(::
*~)::
*~-::
*~_::
*~=::
*~+::
*~[::
*~{::
*~]::
*~}::
*~\::
*~|::
*~;::
*~'::
*~"::
*~,::
*~<::
*~.::
*~>::
*~/::
*~?::
*~Esc::
*~Tab::
*~Space::
*~LAlt::
*~RAlt::
*~Left::
*~Right::
*~Up::
*~Down::
*~Enter::
*~PrintScreen::
*~Delete::
*~Home::
*~End::
*~PgUp::
*~PgDn::
    Return

; 変換を修飾キーとして扱うための準備
; 変換を押し続けている限りリピートせず待機
$vk1C::
    startTime := A_TickCount
    KeyWait, vk1C
    keyPressDuration := A_TickCount - startTime
    ; 変換を押している間に他のホットキーが発動した場合は入力しない
    ; 変換を長押ししていた場合も入力しない
    If (A_ThisHotkey == "$vk1C" and keyPressDuration < 200) {
        Send,{vk1C}
    }
    Return

; 無変換を修飾キーとして扱うための準備
; 無変換を押し続けている限りリピートせず待機
$vk1D::
    startTime := A_TickCount
    KeyWait, vk1D
    keyPressDuration := A_TickCount - startTime
    ; 無変換を押している間に他のホットキーが発動した場合は入力しない
    ; 無変換を長押ししていた場合も入力しない
    If (A_ThisHotkey == "$vk1D" and keyPressDuration < 200) {
        Send,{vk1D}
    }
    Return

; Tabを修飾キーとして扱うための準備
; Tabを押し続けている限りリピートせず待機
$Tab::
    startTime := A_TickCount
    KeyWait, Tab
    keyPressDuration := A_TickCount - startTime
    ; Tabを押している間に他のホットキーが発動した場合は入力しない
    ; Tabを長押ししていた場合も入力しない
    If (A_ThisHotkey == "$Tab" and keyPressDuration < 200) {
        Send,{Tab}
    }
    Return

; Alt + Tab に同じ動作のホットキーを割り当てることでウィンドウ切り替えをホットキー扱いにする
; Alt + Tab を入力した際にTabが入力されてしまうことを防ぐため
Alt & Tab::AltTabAndMenu

; Shift + Tabも同様にTab入力を防ぐためホットキー扱いにする
+Tab::Send,+{Tab}

; チューニングしてるとだんだんスクリプトの編集・ロードをこまめにやりたくなってくるので追加

; Editだとnotepad.exeが起動するが、VSCodeで編集したかったのでRunで記述
; フルパスを書く必要がある
; 環境変数は使わなくてもいいけどGistで公開する際のユーザー名マスク用途で使っている
; 同じキーマップを使いたくなったらコメントアウトする
; 無変換 + E = スクリプト編集
~vk1D & E::
    Run, "%USERPROFILE%\AppData\Local\Programs\Microsoft VS Code\Code.exe" "%USERPROFILE%\Documents\Gist\AutoHotkey"
    Return

; ReloadのR
~vk1D & R::Reload               ; 無変換 + R = スクリプトのリロード

;------------------------------------------------------------------------------
;   第１弾 カーソル移動
;       マウスを使わない場合真っ先に面倒になるのが移動、選択系の操作
;       通常位置のカーソルキーを使っていると手の移動がとても多くなってしまう
;       ホームポジションからカーソルキーが使えるとマウスよりも便利になる
;------------------------------------------------------------------------------

; Vimエディタ派生だけど他のアプリでもよく使われてるので慣れると流用しやすい
~vk1D & H::Send,{Blind}{Left}    ; 無変換 + H = 左カーソルキー
~vk1D & J::Send,{Blind}{Down}    ; 無変換 + J = 下カーソルキー
~vk1D & K::Send,{Blind}{Up}      ; 無変換 + K = 上カーソルキー
~vk1D & L::Send,{Blind}{Right}   ; 無変換 + L = 右カーソルキー

; 片手でカーソル操作したいこともあるので追加
~vk1C & H::Send,{Blind}{Left}    ; 変換 + H = 左カーソルキー
~vk1C & J::Send,{Blind}{Down}    ; 変換 + J = 下カーソルキー
~vk1C & K::Send,{Blind}{Up}      ; 変換 + K = 上カーソルキー
~vk1C & L::Send,{Blind}{Right}   ; 変換 + L = 右カーソルキー

; カーソルを一気に端に移動させられるようにしておく
; また、Excelのシート移動も可能にしておく
; 覚えやすさのため、左右のカーソルキー(H, L)の近くに置く
; 筆者のキーボード配列用
; ~vk1D & Y::Send,{Blind}{Home}    ; 無変換 + Y = Home
; ~vk1D & \::Send,{Blind}{End}     ; 無変換 + \ = End
; ~vk1C & Y::Send,{Blind}{PgUp}    ; 変換 + Y = Page Up
; ~vk1C & \::Send,{Blind}{PgDn}    ; 変換 + \ = Page Down

; 日本語キーボード用
; ~vk1D & Y::Send,{Blind}{Home}    ; 無変換 + Y = Home
; ~vk1D & vkBB::Send,{Blind}{End}  ; 無変換 + ; = End
; ~vk1C & Y::Send,{Blind}{PgUp}    ; 変換 + Y = Page Up
; ~vk1C & vkBB::Send,{Blind}{PgDn} ; 変換 + ; = Page Down

; 日本語キーボード用(微修正)
~vk1D & Y::Send,{Blind}{Home}       ; 無変換 + Y = Home
~vk1D & O::Send,{Blind}{End}        ; 無変換 + O = End
~vk1D & U::Send,{Blind}{PgDn}       ; 無変換 + U = Page Down
~vk1D & I::Send,{Blind}{PgUp}       ; 無変換 + I = Page Up
~vk1D & vkBB::Send,{Blind}{Enter}   ; 無変換 + ; = Enter
~vk1D & N::Send,{Blind}{BS}         ; 無変換 + N = Back Space
~vk1D & M::Send,{Blind}{Del}        ; 無変換 + M = Delete

; 英語キーボード用
; ~vk1D & Y::Send,{Blind}{Home}    ; 無変換 + Y = Home
; ~vk1D & vkBA::Send,{Blind}{End}  ; 無変換 + ; = End
; ~vk1C & Y::Send,{Blind}{PgUp}    ; 変換 + Y = Page Up
; ~vk1C & vkBA::Send,{Blind}{PgDn} ; 変換 + ; = Page Down

;------------------------------------------------------------------------------
;   第２弾 マウスカーソル
;       カーソルキーを使った移動、選択に慣れて来ると、画面をクリックしたり邪魔なマウスカーソルをどかすといった
;       ちょっとしたマウスの操作が面倒に感じるようになってくる
;       そこまで細かい操作を連続で必要としない場合、ホームポジションからマウス操作を代替できるようにする
;------------------------------------------------------------------------------

; 変換 + WASD = マウスカーソル上, 左, 下, 右
; そのままだと細かい操作には向くが大きな移動には遅すぎる
; カーソル操作中にCtrlキーを一瞬押すといい感じにブーストできる
; CtrlとShiftでの加速減速はWindowsのマウスキー機能を踏襲
; 精密操作がしたい時は 変換+Shift+WASD でカーソルをゆっくり動かせる
; ~vk1C & W::
; ~vk1C & A::
; ~vk1C & S::
; ~vk1C & D::
;     While (GetKeyState("vk1C", "P"))                 ; 変換キーが押され続けている間マウス移動の処理をループさせる
;     {
;         MoveX := 0, MoveY := 0
;         MoveY += GetKeyState("W", "P") ? -11 : 0     ; 変換キーと一緒にIJKLが押されている間はカーソル座標を変化させ続け;る
;         MoveX += GetKeyState("A", "P") ? -11 : 0
;         MoveY += GetKeyState("S", "P") ? 11 : 0
;         MoveX += GetKeyState("D", "P") ? 11 : 0
;         MoveX *= GetKeyState("Ctrl", "P") ? 10 : 1   ; Ctrlキーが押されている間は座標を10倍にし続ける(スピードアップ)
;         MoveY *= GetKeyState("Ctrl", "P") ? 10 : 1
;         MoveX *= GetKeyState("Shift", "P") ? 0.3 : 1 ; Shiftキーが押されている間は座標を30%にする（スピードダウン）
;         MoveY *= GetKeyState("Shift", "P") ? 0.3 : 1
;         MouseMove, %MoveX%, %MoveY%, 1, R            ; マウスカーソルを移動する
;         Sleep, 0                                     ; 負荷が高い場合は設定を変更 設定できる値は-1、0、10～m秒 詳細はSl;eep
;     }
;     Return

; 変換 + ESDF = マウスカーソル上, 左, 下, 右
; そのままだと細かい操作には向くが大きな移動には遅すぎる
; カーソル操作中にCtrlキーを一瞬押すといい感じにブーストできる
; CtrlとShiftでの加速減速はWindowsのマウスキー機能を踏襲
; 精密操作がしたい時は 変換+Shift+WASD でカーソルをゆっくり動かせる
~vk1C & E::
~vk1C & S::
~vk1C & D::
~vk1C & F::
    While (GetKeyState("vk1C", "P"))                 ; 変換キーが押され続けている間マウス移動の処理をループさせる
    {
        MoveX := 0, MoveY := 0
        MoveY += GetKeyState("E", "P") ? -11 : 0     ; 変換キーと一緒にIJKLが押されている間はカーソル座標を変化させ続け;る
        MoveX += GetKeyState("S", "P") ? -11 : 0
        MoveY += GetKeyState("D", "P") ? 11 : 0
        MoveX += GetKeyState("F", "P") ? 11 : 0
        MoveX *= GetKeyState("Ctrl", "P") ? 3 : 1   ; Ctrlキーが押されている間は座標を3倍にし続ける(スピードアップ)
        MoveY *= GetKeyState("Ctrl", "P") ? 3 : 1
        MoveX *= GetKeyState("Shift", "P") ? 0.3 : 1 ; Shiftキーが押されている間は座標を30%にする（スピードダウン）
        MoveY *= GetKeyState("Shift", "P") ? 0.3 : 1
        MouseMove, %MoveX%, %MoveY%, 1, R            ; マウスカーソルを移動する
        Sleep, 0                                     ; 負荷が高い場合は設定を変更 設定できる値は-1、0、10～m秒 詳細はSl;eep
    }
    Return


; 以下は筆者のキーボード配列向け
; 変換 + Del =  左クリック（押し続けるとドラッグ）
; ~vk1C & BS::MouseClick,left,,,,,D
; ~vk1C & BS Up::MouseClick,left,,,,,U

; 以下は日本語キーボード・英語キーボード向け
; 変換 + Enter = 左クリック（押し続けるとドラッグ）
~vk1C & Enter::MouseClick,left,,,,,D
~vk1C & Enter Up::MouseClick,left,,,,,U

; 変換 + E = 右クリック
; ~vk1C & E::MouseClick,right
; 変換 + W = 右クリック
~vk1C & W::MouseClick,right

; カーソルキーでファイルを選択した場合の右クリックメニュー表示
; Windows10のエクスプローラーの場合メニュー表示後ショートカットキーで項目を選択できる
~vk1D & F::Send,{Blind}{AppsKey}    ;無変換 + F = アプリケーションキー

;;------------------------------------------------------------------------------
;;   第３弾 ファンクションキー列
;;       マウスに手を伸ばさなくなると、今度は手首を動かす必要のあるキーが遠く感じるようになる。
;;       キーボードによってはファンクションキーは腕を伸ばさないと入力することができない。
;;       ホームポジションのままファンクションキーを入力できるようなマッピングを行う。
;;       最初は変換・無変換と数字キーの組み合わせで入力するが、慣れてきたらQキー行での入力に移行する
;;       特定の修飾キーとの組み合わせを多用する場合は専用のキーマップを設定する
;;       ESCキーがファンクションキー列にある場合遠いのでCtrlキーの空打ちで入力できるようにする
;;------------------------------------------------------------------------------
;
;
;; 最初は変換・無変換と数字キーでファンクションキーを入力する
;; 英語キーボード向け
;vk1C & 1::Send, {Blind}{F1}      ; 変換 + 1 = F1
;vk1C & 2::Send, {Blind}{F2}      ; 変換 + 2 = F2
;vk1C & 3::Send, {Blind}{F3}      ; 変換 + 3 = F3
;vk1C & 4::Send, {Blind}{F4}      ; 変換 + 4 = F4
;vk1C & 5::Send, {Blind}{F5}      ; 変換 + 5 = F5
;vk1C & 6::Send, {Blind}{F6}      ; 変換 + 6 = F6
;vk1C & 7::Send, {Blind}{F7}      ; 変換 + 7 = F7
;vk1C & 8::Send, {Blind}{F8}      ; 変換 + 8 = F8
;vk1C & 9::Send, {Blind}{F9}      ; 変換 + 9 = F9
;vk1C & 0::Send, {Blind}{F10}     ; 変換 + 0 = F10
;vk1C & -::Send, {Blind}{F11}     ; 変換 + - = F11
;vk1C & =::Send, {Blind}{F12}     ; 変換 + =キー = F12
;
;; 日本語キーボードの場合
;; vk1C & -::Send, {Blind}{F11}     ; 変換 + - = F11
;; vk1C & ^::Send, {Blind}{F12}     ; 変換 + ^ = F12
;
;; 英語キーボード向け
;vk1D & 1::Send, {Blind}{F1}      ; 無変換 + 1 = F1
;vk1D & 2::Send, {Blind}{F2}      ; 無変換 + 2 = F2
;vk1D & 3::Send, {Blind}{F3}      ; 無変換 + 3 = F3
;vk1D & 4::Send, {Blind}{F4}      ; 無変換 + 4 = F4
;vk1D & 5::Send, {Blind}{F5}      ; 無変換 + 5 = F5
;vk1D & 6::Send, {Blind}{F6}      ; 無変換 + 6 = F6
;vk1D & 7::Send, {Blind}{F7}      ; 無変換 + 7 = F7
;vk1D & 8::Send, {Blind}{F8}      ; 無変換 + 8 = F8
;vk1D & 9::Send, {Blind}{F9}      ; 無変換 + 9 = F9
;vk1D & 0::Send, {Blind}{F10}     ; 無変換 + 0 = F10
;vk1D & -::Send, {Blind}{F11}     ; 無変換 + - = F11
;vk1D & =::Send, {Blind}{F12}     ; 無変換 + =キー = F12
;
;; 日本語キーボードの場合
;; vk1D & -::Send, {Blind}{F11}     ; 無変換 + - = F11
;; vk1D & ^::Send, {Blind}{F12}     ; 無変換 + ^ = F12
;
;; Ctrlを空打ちした場合ESCキーを入力する
;$Ctrl::
;    startTime := A_TickCount
;    KeyWait, Ctrl
;    keyPressDuration := A_TickCount - startTime
;    ; Ctrlを押している間に他のホットキーが発動した場合は入力しない
;    ; Ctrlを長押ししていた場合も入力しない
;    If (A_ThisHotkey == "$Ctrl" and keyPressDuration < 200) {
;        Send,{Esc}
;    }
;    Return
;
;; Alt + F4 専用キーマップ
;; Ctrl + W がタブやウィンドウを閉じるショートカットであることが多いため
;~vk1D & W::Send, {Blind}!{F4}     ;無変換 + W = Alt + F4
;
;;------------------------------------------------------------------------------
;;   第４弾 記号入力関連
;;       ファンクションキーに手を伸ばさなくなると、次に入力が面倒になるのはと数字キー行と右手の記号類
;;       特に6, 7あたりのキーをShiftと一緒に入力しようとすると腕を動かす必要が出てくる
;;       そのため、腕を動かさずとも済むように変換・無変換+最下段キーで入力できるようにした
;;       覚えやすさのため、数字キー行からそのまま下に辿れば記号を入力できるようにしてある
;;       その他プログラミングやExcelで多用する記号はホームポジション付近に集めている
;;       キーが足りなくなったのでTabとの組み合わせでよく使う記号を入力可能にしている
;;------------------------------------------------------------------------------
;
;; BSキーとDelキーを同じ配置で使う
;~vk1D & BackSpace::Delete          ;無変換 + BS = Delete
;
;; 数字キー行と同じ列で記号キーを定義
;; 英語キーボード用
;~vk1C & Z::Send,{Blind}+{1}        ; 変換 + Z = !
;~vk1C & X::Send,{Blind}+{2}        ; 変換 + X = @
;~vk1C & C::Send,{Blind}+{3}        ; 変換 + C = #
;~vk1C & V::Send,{Blind}+{4}        ; 変換 + V = $
;~vk1C & B::Send,{Blind}+{5}        ; 変換 + B = %
;~vk1D & N::Send,{Blind}+{6}        ; 無変換 + N = ^
;~vk1D & M::Send,{Blind}+{7}        ; 無変換 + M = &
;~vk1D & ,::Send,{Blind}+{8}        ; 無変換 + , = *
;~vk1D & .::Send,{Blind}+{9}        ; 無変換 + . = (
;~vk1D & /::Send,{Blind}+{0}        ; 無変換 + / = )
;
;; 日本語キーボード用
;; 入力される記号が異なる
;; 0に記号が割り当てられていない
;; ~vk1C & Z::Send,{Blind}+{1}        ; 変換 + Z = !
;; ~vk1C & X::Send,{Blind}+{2}        ; 変換 + X = "
;; ~vk1C & C::Send,{Blind}+{3}        ; 変換 + C = #
;; ~vk1C & V::Send,{Blind}+{4}        ; 変換 + V = $
;; ~vk1C & B::Send,{Blind}+{5}        ; 変換 + B = %
;; ~vk1D & N::Send,{Blind}+{6}        ; 無変換 + N = &
;; ~vk1D & M::Send,{Blind}+{7}        ; 無変換 + M = '
;; ~vk1D & ,::Send,{Blind}+{8}        ; 無変換 + , = (
;; ~vk1D & .::Send,{Blind}+{9}        ; 無変換 + . = )
;
;; ホームポジション付近によく使う記号を集約
;; 日本語入力においては「ー」が打ちやすい位置にあるのが地味に便利
;; 英語キーボード用
;~vk1C & F::Send,{Blind}{-}         ; 変換 + F = -
;~vk1C & G::Send,{Blind}{=}         ; 変換 + G = =
;~vk1C & R::Send,{Blind}+{-}        ; 変換 + R = _
;~vk1C & T::Send,{Blind}+{=}        ; 変換 + T = +
;~vk1D & U::Send,{Blind}+{vkDE}     ; 無変換 + U = "
;~vk1D & I::Send,{Blind}{vkDE}      ; 無変換 + I = '
;~vk1D & O::Send,{Blind}+{vkBA}     ; 無変換 + O = :
;~vk1D & P::Send,{Blind}{vkBA}      ; 無変換 + P = ;
;
;; 日本語キーボード用
;; ~vk1C & F::Send,{Blind}{-}         ; 変換 + F = -
;; ~vk1C & G::Send,{Blind}+{=}        ; 変換 + G = =
;; ~vk1C & R::Send,{Blind}+{vkE2}     ; 変換 + R = _
;; ~vk1C & T::Send,{Blind}+{vkBB}     ; 変換 + T = +
;; ~vk1D & U::Send,{Blind}+{2}        ; 無変換 + U = "
;; ~vk1D & I::Send,{Blind}+{7}        ; 無変換 + I = '
;; ~vk1D & O::Send,{Blind}{vkBA}      ; 無変換 + O = :
;; ~vk1D & P::Send,{Blind}{vkBB}      ; 無変換 + P = ;
;
;; Tabとの組み合わせで括弧とその他の記号を入力する
;; 筆者のキーボード配列用
;~Tab & H::Send,{Blind}{[}          ; Tab + H = [
;~Tab & J::Send,{Blind}{]}          ; Tab + J = ]
;~Tab & K::Send,{Blind}+{[}         ; Tab + K = {
;~Tab & L::Send,{Blind}+{]}         ; Tab + L = }
;~Tab & N::Send,{Blind}+{9}         ; Tab + N = (
;~Tab & M::Send,{Blind}+{0}         ; Tab + M = )
;~Tab & ,::Send,{Blind}+{,}         ; Tab + , = <
;~Tab & .::Send,{Blind}+{.}         ; Tab + . = >
;~Tab & \::Send,{Blind}{vkC0}       ; Tab + \ = `
;~Tab & /::Send,{Blind}+{vkC0}      ; Tab + / = ~
;
;; 英語キーボード用
;; ~Tab & H::Send,{Blind}{[}          ; Tab + H = [
;; ~Tab & J::Send,{Blind}{]}          ; Tab + J = ]
;; ~Tab & K::Send,{Blind}+{[}         ; Tab + K = {
;; ~Tab & L::Send,{Blind}+{]}         ; Tab + L = }
;; ~Tab & N::Send,{Blind}+{9}         ; Tab + N = (
;; ~Tab & M::Send,{Blind}+{0}         ; Tab + M = )
;; ~Tab & ,::Send,{Blind}+{,}         ; Tab + , = <
;; ~Tab & .::Send,{Blind}+{.}         ; Tab + . = >
;; ~Tab & vkBA::Send,{Blind}{vkC0}    ; Tab + : = `
;; ~Tab & /::Send,{Blind}+{vkC0}      ; Tab + / = ~
;
;; 日本語キーボード用
;; ~Tab & H::Send,{Blind}{[}          ; Tab + H = [
;; ~Tab & J::Send,{Blind}{]}          ; Tab + J = ]
;; ~Tab & K::Send,{Blind}+{[}         ; Tab + K = {
;; ~Tab & L::Send,{Blind}+{]}         ; Tab + L = }
;; ~Tab & N::Send,{Blind}+{8}         ; Tab + N = (
;; ~Tab & M::Send,{Blind}+{9}         ; Tab + M = )
;; ~Tab & ,::Send,{Blind}+{,}         ; Tab + , = <
;; ~Tab & .::Send,{Blind}+{.}         ; Tab + . = >
;; ~Tab & vkBB::Send,{Blind}{vkC0}    ; Tab + ; = `
;; ~Tab & /::Send,{Blind}+{vkC0}      ; Tab + / = ~
;
;; 日本語キーボード用
;; \が打ちたいときは右上のキーを使う
;; スネークケースのコード書くときに割と便利
;; ~vkE2::+vkE2                       ;右下の\キー = アンダーバー
;
;;------------------------------------------------------------------------------
;;   第５弾 数字キー行
;;       数字キー行の記号をホームポジションから入力できるようになると、
;;       今度は数字キーも遠く感じるようになる。
;;       一方で、英数字を絡めた入力をする際には1キーで数字を入力できる方が効率的だと感じることもある
;;       できるだけ数字キー行と同じような入力体験を維持したままホームポジションから手を動かさない入力を行いたい
;;       上記を満たすため、Tabキーと数字キーの下の行の組み合わせで入力できるようにする
;;------------------------------------------------------------------------------
;
;; Tabとの組み合わせで数字キー入力
;~Tab & Q::Send,{Blind}{1}          ; Tab + Q = 1
;~Tab & W::Send,{Blind}{2}          ; Tab + W = 2
;~Tab & E::Send,{Blind}{3}          ; Tab + E = 3
;~Tab & R::Send,{Blind}{4}          ; Tab + R = 4
;~Tab & T::Send,{Blind}{5}          ; Tab + T = 5
;~Tab & Y::Send,{Blind}{6}          ; Tab + Y = 6
;~Tab & U::Send,{Blind}{7}          ; Tab + U = 7
;~Tab & I::Send,{Blind}{8}          ; Tab + I = 8
;~Tab & O::Send,{Blind}{9}          ; Tab + O = 9
;~Tab & P::Send,{Blind}{0}          ; Tab + P = 0