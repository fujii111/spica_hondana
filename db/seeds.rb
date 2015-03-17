# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Genre.create(name: "新書・文庫", description: "文学・評論・政治・社会・歴史・地理・旅行・ビジネス・経済・科学・コンピュータ・インターネット・アート・エンターテイメント・実用・スポーツ・趣味・暮らし・語学・こども・ライトノベル・ノンフィクション", delete_flg: false, sort: 1)
Genre.create(name: "ビジネス", description: "経済学・マーケティング・セールス・経理・アカウンティング・金融・オペレーションズ・マネジメント・人材管理・統計学・経営学・キャリア・リーダーシップ・ビジネス人物伝・ビジネス読み物・ビジネス実用", delete_flg: false, sort: 2)
Genre.create(name: "文学・評論", description: "文芸作品・時代小説・社会小説・ミステリー・サスペンス・ハードボイルド・SF・ホラー・ファンタジー・ロマンス・エッセー・随筆・古典・詩歌・戯曲・シナリオ・評論・文学研究・伝承・神話", delete_flg: false, sort: 3)
Genre.create(name: "人文・思想", description: "哲学・思想・倫理・道徳・宗教・心理学・文化人類学・民俗学・言語学・女性学・教育学", delete_flg: false, sort: 4)
Genre.create(name: "社会・政治", description: "政治・外交・国際関係・軍事・法律・社会学・女性学・福祉・コミュニティ・環境・エコロジー・NGO・NPO・マスメディア", delete_flg: false, sort: 5)
Genre.create(name: "ノンフィクション", description: "事件・犯罪・歴史・地理・旅行記・ビジネス・経済・科学・スポーツ・教育・自伝・伝記", delete_flg: false, sort: 6)
Genre.create(name: "歴史・地理", description: "歴史学・日本史・世界史・考古学・歴史読み物・地理・地域研究・地図", delete_flg: false, sort: 7)
Genre.create(name: "投資・金融", description: "投資読み物・株式投資・投資信託・不動産投資・債券・為替・外貨預金・銀行・金融業・証券・金融市場・年金・保険・税金・会社経営", delete_flg: false, sort: 8)
Genre.create(name: "自然科学", description: "科学読み物・数学・物理学・化学・宇宙学・天文学・地球科学・エコロジー・金属・鉱学・生物・バイオテクノロジー・工学・エネルギー・電気・通信・農学・海洋学・科学史・科学者", delete_flg: false, sort: 9)
Genre.create(name: "医学・薬学", description: "医学一般・基礎医学・臨床内科・臨床外科・泌尿器科学・産科・婦人科学・小児科学・老年医学・皮膚科学・眼科学・耳鼻咽喉科学・頭頸部外科学・救急医学・集中治療・麻酔科学・ペインクリニック・放射線医学・核医学・がん・腫瘍・整形外科学・リハビリテーション医学・精神医学・医療関連科学・伝統医学・東洋医学・薬学・看護学・歯科学・医療関連語学", delete_flg: false, sort: 10)
Genre.create(name: "コンピュータ・IT", description: "プログラミング・アプリケーション・OS・Web作成・開発・ネットワーク・データベース・パソコン・周辺機器・モバイル・コンピュータサイエンス・インターネット・eビジネス・グラフィックス・DTP・音楽", delete_flg: false, sort: 11)
Genre.create(name: "アート・デザイン", description: "写真・絵画・彫刻・工芸・コンテンポラリーアート・作品集・建築・住宅建築・家づくり・インテリアデザイン・デザイン・日本の伝統文化・古美術・骨董・美術館・博物館・モード・画家・写真家・建築家", delete_flg: false, sort: 12)
Genre.create(name: "趣味・実用", description: "自己啓発・素材・デザイン集・手芸・クラフト・フラワーアレンジメント・絵画・絵手紙・ラッピング・ペン字・書道・陶芸・茶道・華道・香道・車・バイク・鉄道・カメラ・ビデオ・オーディオ・ビジュアル・収集・コレクション・フィギュア・コレクタードール・模型・プラモデル・ラジコン・アマチュア無線・占い・雑学・クイズ・パズル・ゲーム・手品・ビリヤード・ダーツ・囲碁・将棋・ギャンブル", delete_flg: false, sort: 13)
Genre.create(name: "スポーツ・アウトドア", description: "キャンプ・登山・サイクリング・釣り・カヌー・カヤック・クライミング・ボルダリング・ 野球・サッカー・フットサル・ テニス・ゴルフ・バレーボール・ バスケットボール・ マラソン・ランニング・陸上競技・ 筋力トレーニング・ストレッチ・ プロレス・ボクシング・アイススケート・スキー・スノーボード・モータースポーツ・水泳・ラグビー・オリンピック", delete_flg: false, sort: 14)
Genre.create(name: "資格・就職", description: "資格ガイド・公務員試験・教員採用試験・学生の就職・法律関連・ビジネス関連・事務関連・コンピュータ・情報処理・医療・看護・建築・土木・食品・衛生・福祉・工学・環境・運輸・船舶・通信・語学検定・通訳・美容", delete_flg: false, sort: 15)
Genre.create(name: "暮らし・健康", description: "クッキング・レシピ・ワイン・お酒・住まい・インテリア・ガーデニング・ペット・家事・生活の知識・女性と仕事・家庭医学・健康・美容・恋愛・結婚・離婚・妊娠・出産・子育て・ファッション・着物・介護・防災", delete_flg: false, sort: 16)
Genre.create(name: "旅行ガイド", description: "海外旅行・国内旅行・時刻表・交通情報・シティマップ・ロードマップ", delete_flg: false, sort: 17)
Genre.create(name: "語学", description: "英語・日本語・韓国・朝鮮語・中国語・フィリピン語・トルコ語・アラビア語・タイ語・ベトナム語・ドイツ語・ゲルマン諸語・フランス語・スペイン語・ポルトガル語・イタリア語・ロマンス諸語・ロシア語・ギリシア語・ラテン語・その他の外国語・国際共通語・外国語学習法・旅行会話集・復刻雑誌・英語辞典・国語辞典・人名事典・百科事典・通訳・翻訳", delete_flg: false, sort: 18)
Genre.create(name: "教育・受験", description: "幼児教育・小学教科書・参考書・中学教科書・参考書・高校教科書・参考書・大学・大学院・専門学校受験・ガイド・海外留学対策・勉強法", delete_flg: false, sort: 19)
Genre.create(name: "絵本・児童書", description: "絵本・読み物・ノンフィクション・伝記・学習・お絵かき・うた・音楽・実用・工作・趣味・クイズ・パズル・ゲーム・スポーツ・図鑑・事典・年鑑・超能力・不思議・占い・シールブック・マグネットブック・学習まんが・紙しばい", delete_flg: false, sort: 20)
Genre.create(name: "ゲーム", description: "ゲーム攻略本・リプレイノベル・ファンブック・TRPG・カードゲーム", delete_flg: false, sort: 21)
Genre.create(name: "エンターテイメント", description: "映画・音楽・ステージ・ダンス・テレビ・タレント本・落語・寄席・演芸・演劇・舞台・サブカルチャー", delete_flg: false, sort: 22)
Genre.create(name: "楽譜・音楽書", description: "クラシック・J-POP・洋楽・ジャズ・ヴォーカル・ワールド・映画音楽・アニメ＆ゲーム音楽・ラブ＆ウエディング・その他・コンピュータミュージック・楽器別・作曲家別・アーティスト別・シリーズ別・音楽理論・音楽論・メソッド", delete_flg: false, sort: 23)
Genre.create(name: "その他", description: "その他", delete_flg: false, sort: 24)

Property.create(inquiry_mail: "info@spica-travel.com", clickpost_url: "http://www.post.japanpost.jp/service/clickpost/index.html", request_limit: 30, default_point: 0)
