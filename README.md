# BLOG14

## 機能紹介

### アカウント

- adminあり
- lock可能
- 複数セッション対応
- セッション管理可能

### 投稿

- タイトル、内容あり
- 投稿者名あり
- 作成日時、更新日時あり
- draftあり

### その他

- 規約、ポリシー、免責事項記入欄あり
- 問い合わせフォームあり

### 今後実装

- コメント
- アイコン
- ページング
- admin(role,deletedの処理)
- API

### バグ

- 編集でID変更を一回失敗してエラー画面に入ると変更を送信できなくなる。(宛先が編集後保存前のIDになってしまっている)

=>ID変更を失敗しない。(5字以上、被りなし)

- Turbo系のせいでEasyMDEのCDNが読み込まれないときがある。

=>エディタ画面に行くリンクで

```
data: { turbo: false }
```

を使用する。