# rails-tutorial3

[gitの初期設定手順書]
1. githubでリポジトリーを作成する。
　　このとき、１READMEを作成するにチェックをする。
　　→クローンがしやすくなる。
2. githubでブランチを作成する。

3. 作成したブランチを選択して、git cloneする。
    ・-bでブランチを選択する。
    ・URLは、githubのリポジトリのcodeから取ってくる。
    　  一応、認証tokenを使うといいかもしれない。
        →ここで、確認できる。　https://github.com/settings/tokens/
    ・cloneするとフォルダ内に.gitもできるので便利。ブランチは勝手にdevelopL1になる。
    例) git clone -b developL1 https://<token>@github.com/nasu149/rails-tutorial3.git

4. pushしてみる。
    ・cd でまずはcloneしたディレクトリに移動する。
    ・add、commitする。
        git add -A
        git commit
        →commitは-mつけないと自動でメッセージをかくエディタが起動する。