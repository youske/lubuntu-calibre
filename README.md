dockerfile lubuntu (xenial) with calibre vnc
============================================

# 概要
lubuntu(ubuntu 16.04) ベースにebook管理用calibreを導入したイメージ
calibreと書籍公開用サーバ
okular
アクセス方法としてvncを内蔵しているのでvncにてアクセスする


# docker pull
    docker pull youske/lubuntu-calibre

# docker run
    vnc = 5901
    calibre server = 8088

    standard
    docker run -it -p 5901:5901 -p 8088:8088 --rm youske/lubuntu-calibre

    shellmode
    docker run -it -p 5901:5901 -p 8088:8088 --rm youske/lubuntu-calibre shell


# dockerimageの作成

## イメージ

    docker-compose build

## イメージの起動

    docker-compose run -d calibre


# その他

dockerhub repo

http://hub.docker.com/youske/lubuntu-calibre

entrykit
https://github.com/progrium/entrykit

gosu
https://github.com/tianon/gosu

lubuntu (lxde)
日本語フォント+

vnc
tigervnc-server


# パスワードの再設定
user: admin
pass: admin
homedir: /home/admin

# vnc setting
user: vnc
pass: vncpass
