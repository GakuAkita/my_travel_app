- done:::ログイン画面の作成(ログインしていたらメイン画面に自動で遷移か、最初からメインへ)
- done::StartScreenの作成
- done:::Login画面の作成
- done:::Settings画面のメニュー作成
- done:::割り勘のUI作成。編集(done)、削除、もできるようにする
- done:::割り勘の結果表示UI(デザインは改善の余地あり!)
- done:::グループ作成
- done:::CloudFunctionで割り勘計算
- itinerary mdファイルを取り込む
- done:::itinerary 横にスワイプして削除
- done:::itinerary 長プレスで順番を入れ替え。
- done:::itinerary DBに保存する
- done:::表示旅行選択を切り替えたときにitineraryも変わるか
- done:::エラー時の表示
- done:::publicにできるようにgitignoreを整備
- done:::itineraryのURLがリンクがちゃんと動くか
- done::Expenseの編集を開くときの挙動が遅い
- done:::下へドラッグで更新
- done::何時にログインしたかを記録する
- done::割り勘の明細作成(functions側か？)
- done:::自動デプロイ with actionsj
- done:::itinerary同時編集ロック
- done:::はみ出しのエラーが出ている。動いてはいるが、、
- done:::費用概要の自動計算 -> itineraryから読み取る
- done:::参加者更新でitineraryやexpenseのallParticipantsが更新されていない？？
- done::グループメンバーは全員選択肢に出るようにしておく。でも、デフォルトでは参加者のみチェック
- vを上げたいときに正しく挙げられるようにする。
- Storeのリファクタリング。
- firebase emulatorのセットアップ

- functionsで夜中に一度onEditをリセットする
- 外貨対応

- UXバグ：
- done:::表示旅行の設定でデフォルト値がshown travelIdになっていない。
- done:::表示旅行の設定で、まだ旅行が作成されていないときに旅行が作成されていないという案内がない
- done:::旅行の参加者が設定されていない時、経費を追加しようとしても何もお知らせがない。
- done:::グループ名がかぶるときに弾く
- done:::グループ削除のときの対応
- done:::listener(特に割り勘の部分)変更を通知を受けたときに自動で更新
- done:::dependabotにワーニング解決。axiosやな
- 削除をするのは一番最後しか消せない
- ItineraryScreenのEdit画面が右にはみ出ている
- Github警告js-yaml has prototype pollution in merge

optional

- ViewModel化
- 今nullで返しているところをエラー情報も含めて返す
- バックエンドを自作する