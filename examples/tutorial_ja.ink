# Ink言語チュートリアル
# インタラクティブRPGアドベンチャー

// ============================================
// グローバル変数 - ファイルの先頭で宣言
// ============================================

// プレイヤーの統計と属性
VAR player_class = "Adventurer"
VAR strength = 5
VAR intelligence = 5
VAR agility = 5
VAR gold = 100
VAR health = 100
VAR max_health = 100
VAR experience = 0
VAR level = 1
VAR player_name = "Hero"
VAR walking_count = 0

// リスト変数（状態追跡用）
LIST inventory = sword, health_potion, magic_scroll, lockpick, shield, fireball_spell
VAR items = ()

LIST quest_status = not_started, in_progress, completed
VAR dragon_quest = not_started
VAR village_quest = not_started

LIST reputation = unknown, known, respected, legendary
VAR fame = unknown

LIST enemy_state = alive, wounded, defeated
VAR goblin_chieftain = alive
VAR goblin_count = 0
VAR battle_rounds = 0

// ============================================
// ストーリー開始
// ============================================
// ストーリーは最初のknotにダイバートすることで始まります

-> character_creation

// ============================================
// セクション1：基本テキストと選択肢
// ============================================

=== character_creation ===
勇敢な冒険者よ、ようこそ！このインタラクティブストーリーは、ファンタジー世界を探索しながらInk言語のすべてを教えます。

このチュートリアルは、RPGをテーマにした例でInk言語のすべての機能をカバーしています。各セクションは、Inkスクリプトの異なる側面を実演します。

あなたはギルドホールの前に立ち、冒険者として登録する準備ができています。

「ようこそ！」とギルドマスターが言います。「今日は何のご用ですか？」

// これは基本的な選択肢を実演します
// 選択肢は *（一度のみ）または +（繰り返し可能）で始まります
* [栄光と富を求めて]
    「ああ、野心的ですね！気に入りました。」
    -> choose_class
* [困っている人々を助けたい]
    「高潔な心ですね！あなたのような人がもっと必要です。」
    -> choose_class
* [ちょっと見ているだけです...]
    「そうですか、ごゆっくりどうぞ。準備ができたら、私を訪ねてください。」
    -> choose_class

// ============================================
// セクション2：KnotとStitch
// ============================================

=== choose_class ===
// Knotはストーリーの主要セクションです（===でマーク）
// Stitchはknot内のサブセクションです（=でマーク）

= class_selection
ギルドマスターが大きな書物を取り出します。

「それでは、あなたの天職は何ですか？」

* [戦士 - 戦闘の達人]
    -> warrior_path
* [魔法使い - 秘術の力の使い手]
    -> mage_path
* [盗賊 - 影と機敏さ]
    -> rogue_path

= warrior_path
~ player_class = "Warrior"
~ strength = 8
~ intelligence = 3
~ agility = 5

「戦士ですね！強くて勇敢だ。」
-> stats_confirmed

= mage_path
~ player_class = "Mage"
~ strength = 3
~ intelligence = 8
~ agility = 4

「魔法使いですね！賢明で強力だ。」
-> stats_confirmed

= rogue_path
~ player_class = "Rogue"
~ strength = 4
~ intelligence = 5
~ agility = 8

「盗賊ですね！素早くて賢い。」
-> stats_confirmed

// ============================================
// セクション3：変数
// ============================================
// すべてのグローバル変数はファイルの先頭で宣言されます
// 上記の変数宣言の例を参照してください：
// - VAR はグローバル変数用
// - LIST は列挙状態用
// 変数には数値、文字列、またはリスト値を格納できます

=== stats_confirmed ===
「あなたの道が決まりました！」

ギルドマスターがあなたの名前を登録簿に記入します。

<> # registration_complete

// これは変数に基づいた条件付きテキストを実演します
あなたは今、登録された{player_class}です。

あなたの統計：
- 筋力：{strength}
- 知力：{intelligence}
- 敏捷：{agility}
- ゴールド：{gold}コイン

* [続ける]
    -> training_ground

// ============================================
// セクション4：条件文とロジック
// ============================================

=== training_ground ===
あなたはギルドホールの裏にある訓練場に入ります。

// { 条件: テキスト } を使用した条件付きテキスト
{player_class == "Warrior": 武器棚が期待に輝いています。}
{player_class == "Mage": あなたは空気中の魔法エネルギーを感じます。}
{player_class == "Rogue": ステルスを練習できそうな影がいくつかあることに気づきます。}

インストラクターが近づいてきます。

// これは条件付き選択肢を実演します
{player_class == "Warrior":
    * [武器で訓練する]
        -> warrior_training
}
{player_class == "Mage":
    * [呪文書を学ぶ]
        -> mage_training
}
{player_class == "Rogue":
    * [開錠の練習をする]
        -> rogue_training
}
* [訓練をスキップして冒険を始める]
    「自信がおありですね？よろしい。」
    -> first_quest

=== warrior_training ===
~ strength = strength + 2
~ items += sword
~ items += shield

あなたは剣で訓練し、正しいフォームとテクニックを学びます。

あなたの筋力が2増加しました！（現在：{strength}）

入手：剣と盾！

* [訓練を終える]
    -> first_quest

=== mage_training ===
~ intelligence = intelligence + 2
~ items += magic_scroll
~ items += fireball_spell

あなたは古代の書物を学び、魔法エネルギーを操る方法を学びます。

あなたの知力が2増加しました！（現在：{intelligence}）

習得：基本魔法とファイアボールの呪文！

* [訓練を終える]
    -> first_quest

=== rogue_training ===
~ agility = agility + 2
~ items += lockpick

あなたは静かに動き、鍵を開ける練習をします。

あなたの敏捷が2増加しました！（現在：{agility}）

入手：ロックピックセット！

* [訓練を終える]
    -> first_quest

// ============================================
// セクション5：GatherとWeave
// ============================================

=== first_quest ===
ギルドマスターがあなたを呼びます。

「あなたの最初のクエストです！ミルヘイブン村が助けを必要としています。」

// Gatherポイント（-でマーク）は複数の選択肢パスを集めます
* 「何が問題なのですか？」
    「ゴブリンたちが物資を襲撃しています。」
    - - 「なるほど。」
* 「報酬はいくらですか？」
    「金貨50枚、それに見つけたものは何でも。」
    - - 「妥当ですね。」
* 「準備できています！」
    - - 「素晴らしい！」

// すべてのパスがここに集まります
- ギルドマスターがあなたのクエストログに記録します。

~ village_quest = in_progress

* [ミルヘイブンに向けて出発する]
    -> journey_to_millhaven

// ============================================
// セクション6：代替案とシーケンス
// ============================================

=== journey_to_millhaven ===
あなたはミルヘイブンに向かって森の道を歩きます。

// シーケンスは {} を使用します
// & はサイクル代替案を作成します
// ! は一度のみの代替案を作成します
// {} は停止代替案を作成します

// サイクルシーケンス（最初から繰り返す）
{&太陽が木々の間から差し込んでいます。|鳥が天蓋でさえずっています。|穏やかな風が葉をそよがせています。|森の小道が先に続いています。}

{walking_count < 3:
    * [歩き続ける]
        ~ walking_count++
        -> journey_to_millhaven
}

// 十分歩いた後、続ける
{walking_count >= 3:
    あなたは道の分岐点に到着します。
    
    風化した道標が三つの方向を指しています。
    
    * [大通りを行く]
        -> main_road
    * [森の小道を辿る]
        -> forest_trail
    * [古い遺跡の道を調査する]
        -> ruins_path
}

// ============================================
// セクション7：一時変数とロジック
// ============================================

=== main_road ===
あなたはよく通られた大通りを進みます。

// 一時変数（このknot内でのみ存在）
~ temp time_taken = 2
~ temp encounters = 0

{time_taken}時間後、あなたは無事にミルヘイブンに到着します。

{player_class == "Rogue": あなたの鋭い目がトラブルを避けるのに役立ちました。}

-> millhaven_arrival

=== forest_trail ===
あなたはより深い森に踏み込みます。

~ temp encounter_roll = RANDOM(1, 10)
~ temp combat_success = false

// 比較演算子の実演
{encounter_roll >= 7:
    野生のイノシシがあなたに突進してきます！
    
    {player_class == "Warrior" and strength >= 8:
        ~ combat_success = true
        あなたは巧みに避けて剣で反撃します！
    }
    {player_class == "Mage" and intelligence >= 8:
        ~ combat_success = true
        あなたは呪文を唱えてイノシシを追い払います！
    }
    {player_class == "Rogue" and agility >= 8:
        ~ combat_success = true
        あなたは軽やかに跳び避け、影に消えます！
    }
    {not combat_success:
        あなたは何とか逃げますが、いくらかダメージを受けます。
        ~ health = health - 15
        ヘルス：{health}/{max_health}
    }
}

あなたは最終的にミルヘイブンに到着します。

-> millhaven_arrival

=== ruins_path ===
好奇心があなたを古代遺跡の探索に導きます。

~ temp treasure_found = RANDOM(1, 6)

{treasure_found >= 4:
    瓦礫の中に、あなたは古い宝箱を見つけます！
    
    {items has lockpick:
        あなたはロックピックを使って開けます。
        ~ gold = gold + 50
        ~ items += health_potion
        中身：金貨50枚と回復ポーション！
    - else:
        残念ながら、鍵のかかった宝箱を開けることができません。
    }
}

あなたはミルヘイブンに向かいます。

-> millhaven_arrival

// ============================================
// セクション8：高度な条件文
// ============================================

=== millhaven_arrival ===
あなたは{time_of_day()}にミルヘイブン村に到着します。

// 複数の条件
{village_quest == in_progress and health < max_health:
    年配の治療師があなたの傷に気づきます。
    「お手伝いしましょう、冒険者さん。」
    ~ health = max_health
    あなたの体力が回復しました！
}

村は質素ですが手入れが行き届いています。村人たちは希望を持ってあなたを見つめます。

* [村の長老を探す]
    -> meet_elder
* {items has health_potion} [最初に回復ポーションを使う]
    -> use_health_potion
* [村を探索する]
    -> explore_village

// ============================================
// セクション9：関数
// ============================================

// 関数は値を返し、パラメータを受け取ることができます
=== function time_of_day()
~ temp hour = RANDOM(6, 20)
{
    - hour < 12:
        ~ return "朝"
    - hour < 17:
        ~ return "午後"
    - else:
        ~ return "夕方"
}

=== function calculate_damage(attacker_stat)
~ temp base_damage = attacker_stat * 2
~ temp variance = RANDOM(0, 5)
~ return base_damage + variance

=== function skill_check(stat, difficulty)
~ temp roll = RANDOM(1, 20)
~ return roll + stat >= difficulty

// ============================================
// セクション10：トンネル
// ============================================

=== use_health_potion ===
// トンネルは戻ってくる一時的な転換のようなものです
// -> と ->-> 構文を使用します

あなたは回復ポーションを飲みます。

~ items -= health_potion
~ health = max_health

体力が{health}に回復しました！

* [続ける]
    ->->

=== explore_village ===
あなたは村の通りを歩き回ります。

* [鍛冶屋を訪れる]
    -> blacksmith_shop ->
* [酒場を調べる]
    -> village_tavern ->
* [長老のところへ行く]
    -> meet_elder

=== blacksmith_shop ===
鍛冶屋の炉が熱で輝いています。

「装備をお探しですか？」と鍛冶師が尋ねます。

* {gold >= 50} [防具のアップグレードを買う（金貨50枚）]
    ~ gold -= 50
    ~ max_health += 20
    ~ health += 20
    「良い選択だ！これでよく守られるでしょう。」
    最大体力が増加しました！
    ->->
* {gold < 50} [何も買えない]
    「もっと金貨を持ってきたら来てください。」
    ->->
* [去る]
    ->->

=== village_tavern ===
酒場は温かく居心地が良いです。

// 代替シーケンス - 一度のみ
{!バーテンダーがあなたに頷きます。|何人かの客があなたを見ます。|酒場は会話で賑わっています。}

* [飲み物を買う（金貨5枚）]
    {gold >= 5:
        ~ gold -= 5
        あなたは爽快な飲み物を楽しみます。
        山にドラゴンがいるという噂を小耳に挟みます...
        ~ dragon_quest = not_started
    - else:
        「すみません、金貨5枚が必要です。」
    }
    ->->
* [去る]
    ->->

// ============================================
// セクション11：メインクエストとスレッド
// ============================================

=== meet_elder ===
あなたは町役場で村の長老を見つけます。

「神に感謝！来てくれたのですね！」と彼は切迫して言います。

「ダークウッドのゴブリンたちが我々の物資を盗んでいます。食料が尽きそうなのです！」

* 「任せてください。」
    「恩に着ます、冒険者よ！ゴブリンの陣営はここから北です。」
* 「このゴブリンについてもっと教えてください。」
    「彼らは狡猾な族長に率いられています。気をつけてください！」
    ** 「準備できています。」

- 「幸運がありますように！」

~ fame = known

* [ゴブリンの陣営に向かう]
    -> goblin_camp

// ============================================
// セクション12：リストを使った戦闘システム
// ============================================
// リストと変数はファイルの先頭で宣言されています
// 敵の状態追跡については goblin_chieftain 変数を参照してください

=== goblin_camp ===
あなたは慎重にゴブリンの野営地に近づきます。

粗末な木製の柵がいくつかのテントを囲んでいます。ゴブリンたちが周囲を巡回しています。

* {agility >= 8} [静かに潜入する]
    -> stealth_approach
* [大胆に突撃する]
    -> direct_approach
* [魔法で陽動を作る]
    {items has fireball_spell}
    -> magic_approach

=== stealth_approach ===
あなたは影のように警備兵を通り過ぎます。

~ temp stealth_success = skill_check(agility, 15)

{stealth_success:
    あなたは発見されずに族長のテントに到達します！
    -> chieftain_tent
- else:
    警備兵があなたを見つけます！
    「侵入者だ！」
    -> goblin_battle
}

=== direct_approach ===
あなたは武器を構えて門を突き抜けます！

{player_class == "Warrior":
    あなたの武芸の腕前は威圧的です。
    数匹のゴブリンがあなたを見て逃げ出します。
}

-> goblin_battle

=== magic_approach ===
あなたはファイアボールを召喚し、陣営の反対側に投げつけます！

~ items -= fireball_spell

爆発がすべての警備兵を引き寄せます。

あなたは混乱の中を滑り込みます！

-> chieftain_tent

// ============================================
// セクション13：戦闘メカニクス
// ============================================

=== goblin_battle ===
~ goblin_count = 3
~ battle_rounds = 0

3匹のゴブリンがあなたを攻撃します！

= battle_loop

{goblin_count <= 0:
    -> battle_won
}

{health <= 0:
    -> battle_lost
}

~ battle_rounds++

ゴブリンたちが唸って攻撃してきます！（ラウンド{battle_rounds}）

* {player_class == "Warrior" and items has sword} [剣を振る]
    -> warrior_attack
* {player_class == "Mage" and items has magic_scroll} [呪文を唱える]
    -> mage_attack
* {player_class == "Rogue" and agility >= 8} [素早い攻撃]
    -> rogue_attack
* [防御する]
    -> defend

= warrior_attack
~ temp damage = calculate_damage(strength)

あなたは剣で攻撃します！ダメージ：{damage}

{damage >= 15:
    あなたはゴブリンを倒しました！残り{goblin_count - 1}匹。
    ~ goblin_count--
}

~ temp goblin_damage = RANDOM(3, 8)
~ health = health - goblin_damage

ゴブリンたちが反撃します！あなたは{goblin_damage}ダメージを受けます。体力：{health}/{max_health}

* [戦い続ける]
    -> battle_loop

= mage_attack
~ temp damage = calculate_damage(intelligence)

あなたの呪文が力を爆発させます！ダメージ：{damage}

{damage >= 15:
    あなたはゴブリンを倒しました！残り{goblin_count - 1}匹。
    ~ goblin_count--
}

~ temp goblin_damage = RANDOM(3, 8)
~ health = health - goblin_damage

ゴブリンたちが反撃します！あなたは{goblin_damage}ダメージを受けます。体力：{health}/{max_health}

* [戦い続ける]
    -> battle_loop

= rogue_attack
~ temp damage = calculate_damage(agility)

あなたは影から攻撃します！ダメージ：{damage}

{damage >= 15:
    あなたはゴブリンを倒しました！残り{goblin_count - 1}匹。
    ~ goblin_count--
}

~ temp goblin_damage = RANDOM(2, 6)
~ health = health - goblin_damage

ゴブリンたちが攻撃しますが、あなたはほとんどの攻撃を避けます！あなたは{goblin_damage}ダメージを受けます。体力：{health}/{max_health}

* [戦い続ける]
    -> battle_loop

= defend
あなたは防御態勢をとります！

~ temp goblin_damage = RANDOM(1, 4)
~ health = health - goblin_damage

あなたはダメージを最小限に抑えます！あなたは{goblin_damage}ダメージを受けます。体力：{health}/{max_health}

* [反撃する]
    -> battle_loop

= battle_won
あなたはゴブリンたちを倒しました！

~ experience += 30
~ gold += 20

30XPと金貨20枚を獲得しました！

-> chieftain_tent

= battle_lost
あなたはゴブリンの刃に倒れます...

「もっと訓練が必要かもしれませんね」と声が言います。

ギルドマスターがあなたを救出しました！

~ health = max_health / 2

「諦めるな、若き{player_class}よ。」

-> guild_hall_return

// ============================================
// セクション14：ストーリークライマックス
// ============================================

=== chieftain_tent ===
あなたは族長のテントに入ります。

ゴブリンの族長が盗んだ村の家具で作られた玉座に座っています。

「ほう、村が{player_class}を送ってきたか」と彼は嘲笑します。「思っていたより勇敢だな。」

* 「盗んだ物資を返せ！」
    「さもないと？」
    ** [攻撃する]
        -> chieftain_battle
    ** [交渉する]
        -> negotiate_with_chieftain
* 「これは平和的に解決できます。」
    -> negotiate_with_chieftain

=== negotiate_with_chieftain ===
{intelligence >= 8:
    あなたは相互利益について説得力のある議論を展開します。
    
    族長はあなたの言葉を慎重に検討します。
    
    「ふむ...あなたの言うことは理にかなっているかもしれない。物資を持って行け。我々は他で食料を見つけよう。」
    
    ~ village_quest = completed
    ~ experience += 50
    ~ gold += 100
    ~ fame = respected
    
    族長はゴブリンたちに物資を返すよう命じます。
    
    外交的勝利！+50XP、+金貨100枚！
    
    -> quest_complete
- else:
    あなたの交渉はうまくいきません。
    
    「ふん！もう話は十分だ！」
    
    -> chieftain_battle
}

=== chieftain_battle ===
「物資が欲しいなら、力ずくで奪ってみろ！」

~ goblin_chieftain = alive

= battle_start
族長は熟練の戦士です！

* {strength >= 10} [力で圧倒する]
    -> strength_victory
* {agility >= 10} [速さで翻弄する]
    -> agility_victory
* {intelligence >= 10} [戦術で出し抜く]
    -> intelligence_victory
* [全力を尽くす！]
    -> standard_victory

= strength_victory
あなたの強力な攻撃が族長を圧倒します！

~ goblin_chieftain = defeated
~ experience += 75
~ gold += 150

あなたは壊滅的な一撃を与えます！

族長が降参します！

-> chieftain_defeated

= agility_victory
あなたは速すぎて族長は攻撃できません！

~ goblin_chieftain = defeated
~ experience += 75
~ gold += 150

あなたはあらゆる角度から攻撃します！

族長が降参します！

-> chieftain_defeated

= intelligence_victory
あなたはすべての動きを予測します！

~ goblin_chieftain = defeated
~ experience += 75
~ gold += 150

あなたは族長を罠に誘い込みます！

族長が降参します！

-> chieftain_defeated

= standard_victory
あなたは決意を持って戦います！

~ temp victory_roll = skill_check(strength + agility, 18)

{victory_roll:
    ~ goblin_chieftain = defeated
    ~ experience += 60
    ~ gold += 120
    
    激しい戦いの後、あなたは勝利を収めます！
    
    -> chieftain_defeated
- else:
    族長が強力な一撃を与えます！
    ~ health = health - 20
    
    {health <= 0:
        -> goblin_battle.battle_lost
    - else:
        体力：{health}/{max_health}
        
        * [戦い続ける！]
            -> battle_start
    }
}

=== chieftain_defeated ===
ゴブリンの族長が敗北を認めて頭を下げます。

「お前は...強い。物資は持って行け。」

~ village_quest = completed
~ fame = respected

ゴブリンたちは盗んだ品物を返します。

-> quest_complete

// ============================================
// セクション15：マルチエンディングとタグ
// ============================================

=== quest_complete ===
あなたは盗まれた物資を携えてミルヘイブンに戻ります。 # triumphant_return

あなたが到着すると村人たちが歓声を上げます！

長老が急いであなたを迎えます。「あなたが私たちを救ってくれた！ありがとう！」

~ gold += 50

あなたは報酬を受け取ります：金貨50枚！

総資産：金貨{gold}枚

{fame >= respected:
    「あなたの名声が大地に広がります！」
    あなたの行いの噂が遠く広く伝わります。
}

= check_level_up
{experience >= 100:
    ~ level++
    ~ experience = experience - 100
    ~ max_health += 20
    ~ health = max_health
    
    *** レベルアップ！ ***
    あなたは今レベル{level}です！
    最大体力が{max_health}に増加しました！
    
    -> check_level_up
}

* [ドラゴンの噂について聞く]
    {dragon_quest == not_started:
        「ああ、そうだ、山で目撃情報がありました。」
        「しかし、それは別の日のクエストですね...」
        ~ dragon_quest = in_progress
    }
* [休息して祝う]
    -> celebration

=== celebration ===
その夜、村はあなたの栄誉を讃える祝宴を開きます。

{player_class == "Warrior": あなたは村の警備兵たちと戦いの物語を共有します。}
{player_class == "Mage": あなたは子供たちに簡単な魔法のトリックを実演します。}
{player_class == "Rogue": あなたは村の若者たちに...無害なトリックを教えます。}

= feast
祝宴は{&美味しく|壮大で|素晴らしく}楽しいです！

{items has health_potion:
    感謝する村人があなたのポーションと引き換えに治癒魔法を教えると申し出ます。
    
    * [取引を受け入れる]
        ~ items -= health_potion
        ~ intelligence += 1
        あなたは治癒魔法の基礎を学びます！
        知力+1！
        -> ending_choice
}

* [夜を楽しむ]
    -> ending_choice

// ============================================
// セクション16：バリエーション付きエンディング
// ============================================

=== ending_choice ===
月が昇る中、あなたは次の行動を考えます。

* [冒険を続ける]
    -> continue_adventure
* [ギルドホールに戻る]
    -> guild_hall_return
* [ドラゴンクエストを追う]
    {dragon_quest == in_progress}
    -> dragon_tease

=== continue_adventure ===
あなたは旅を続けることに決めます。

世界は広大で、多くの冒険が待っています！

// 条件付きエンディングテキスト
{level >= 2:
    レベル{level}の{player_class}として、あなたはより大きな挑戦に備えています！
}

{gold >= 200:
    あなたの財布は金貨{gold}枚で重たくなっています。
}

{fame == legendary:
    あなたの伝説的な地位はどこでも扉を開きます。
- else:
    {fame == respected:
        あなたはこの地で尊敬されています。
    - else:
        {fame == known:
            あなたの名前は知られ始めています。
        - else:
            あなたはまだ評判を築いているところです。
        }
    }
}

前方の道が呼んでいます...

# the_journey_continues

-> END

=== guild_hall_return ===
あなたは成功を報告するためにギルドホールに戻ります。

ギルドマスターが温かくあなたを迎えます。「よくやった！あなたには才能があると思っていました。」

{village_quest == completed:
    あなたのクエストはギルドの記録に完了として記載されます。
}

「常により多くのクエストが利用可能です、{player_class}さん。」

{fame >= respected:
    「実際、あなたの評判にふさわしい特別な任務があります。」
}

* [利用可能なクエストを見る]
    「どれどれ...」
    
    {dragon_quest == in_progress:
        - 山のドラゴン（危険！）
    }
    - 商人キャラバンの護衛
    - 盗賊の洞窟の掃討
    - 幽霊屋敷の調査
    
    「たくさんの機会がありますよ！」
    
* [彼らに感謝して去る]
    -> end_for_now

=== dragon_tease ===
あなたは山に目を向けます。

ドラゴンクエスト！これは伝説的になるかもしれません！

しかし、それはまた別の物語...

{level >= 3:
    あなたのスキルと経験があれば、チャンスがあるかもしれません。
}

# dragon_quest_begun

-> END

=== end_for_now ===
あなたの冒険は続きます...

# to_be_continued

-> END

// ============================================
// チュートリアル完了！
// ============================================

// このチュートリアルでは以下を実演しました：
// 1. 基本テキストと選択肢（* は一度のみ、+ は繰り返し可能）
// 2. Knot（===）とStitch（=）
// 3. Divert（->）
// 4. Gather（-）
// 5. 変数（VAR はグローバル、~ temp は一時）
// 6. 条件文 { 条件: テキスト }
// 7. 関数（=== function 名前）
// 8. Tunnel（->->）
// 9. List（LIST とメンバーシップ）
// 10. Tag（#）
// 11. ロジック（and、or、not、==、>=、など）
// 12. 代替案（&、!、{}、サイクル/停止）
// 13. ランダム数 RANDOM()
// 14. 戦闘システム
// 15. マルチエンディング

// このチュートリアルをプレイしていただきありがとうございました！
// これでInkのすべてのコア機能を知りました！
// 自分自身のインタラクティブストーリーを書き始めましょう！
