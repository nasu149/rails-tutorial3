# rails-tutorial3

[参考]
https://www.youtube.com/watch?v=lZD1MIHwMBY&list=LL&index=4&t=4803s

## gitの環境を作成する。
1. githubでリポジトリーを作成する。
　　このとき、１READMEを作成するにチェックをする。
　　→クローンがしやすくなる。
2. githubでブランチを作成する。

3. 作成したブランチを選択して、git cloneする。
    - -bでブランチを選択する。
    - URLは、githubのリポジトリのcodeから取ってくる。
    　  一応、認証tokenを使うといいかもしれない。
        →ここで、確認できる。　https://github.com/settings/tokens/
    - cloneするとフォルダ内に.gitもできるので便利。ブランチは勝手にdevelopL1になる。
        例) git clone -b developL1 https://<token>@github.com/nasu149/rails-tutorial3.git

4. pushしてみる。
    - cd でまずはcloneしたディレクトリに移動する。
    - add、commitする。
        git add -A
        git commit
        →commitは-mつけないと自動でメッセージをかくエディタが起動する。
    - pushする前に、tokenを変更しないとできないかも。
      https://github.com/settings/tokens/
      上に行って、regenerateしてtokenを発行する。
      その後、urlをセットする。
        git remote set-url origin https://<token>@github.com/nasu149/rails-tutorial3.git
      これでoriginにtokenつきのURLが設定された。
    - あとはpushする。
        git push origin developL1:developL1
        →ローカルブランチdevelopL1からリモートブランチdevelopL1にpushする。
        -uオプションを付けると次からはgit pushだけでできるようになる。


## dockerでrails環境の作成方法

1. dockerを起動する。
    docker for desktopを起動する。

2. Dockerfileを作成する。
    ```docker: Dockerfile
    FROM ruby:2.6.10
    #ENV RAILS_ENV=production
    RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
    RUN mkdir /myapp
    WORKDIR /myapp
    COPY ./src /myapp
    RUN bundle config --local set path 'vendor/bundle'
    RUN bundle install
    COPY start.sh /start.sh
    RUN chmod 744 /start.sh
    CMD ["sh", "/start.sh"]
    ```

3. docker-compose.ymlを作成する。
    ```docker docker-compose.yaml
    version: '3'

    services:
        db:
            image: mysql:5.7
            environment:
                MYSQL_USER: 
                MYSQL_ROOT_PASSWORD: password
                MYSQL_PASSWORD: password
                MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
            ports:
                - "3306:3306"
            volumes:
                - ./src/db/mysql/volumes:/var/lib/mysql

        web:
            build: .
            command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
            volumes:
                - ./src:/myapp
                # - gem_data:/usr/local/bundle
            ports:
                - 3000:3000
            depends_on:
                - db 
            tty: true
            stdin_open: true
    volumes:
    gem_data:
    ```

4. start.shを作成
    ```shell: start.sh
    #!/bin/sh

    if [ "${RAILS_ENV}" = "production" ]
    then
        bundle exec rails assets:precompile
    fi
    bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0
    ```

5. srcディレクトリを作成して、Gemfileだけ入れておく。
    - mkdir src
    - cd src
    - touch Gemfile
    - cd ..

    ```ruby: Gemfile
    source 'https://rubygems.org'
    ruby '2.6.10'
    gem 'rails', '~> 5.2.8', '>= 5.2.8.1'
    ```

6. コンテナをrunして、railsをnewする。
    ```cmd: new
    docker-compose run web rails new . --force --database=mysql
    ```

7. gitignoreの場所を変更する。
    - mv ./src/.gitignore .
    - で、すべてディレクトリが変わるので、頭にsrcをつける。

8. 新しくできたsrcの中の.gitを消す。
    - cd src 
    - rm -rf .git
    - cd ..

9. src/config/database.ymlの内容を変更する。
        password: password
        host: db
        →passwordを設定して、hostをdbにする。

10. dbを使えるようにする。
    docker-compose run web rails db:create

11. コンテナを起動する。
    docker-compose up

    http://localhost:3000 にアクセスする。
