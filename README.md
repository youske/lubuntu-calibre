dockerfile lubuntu with calibre
===============================

# 概要
lubuntu(ubuntu 16.04) ベースにebook管理用calibreを導入したイメージ
calibreと書籍公開用サーバ


# 導入
base image
youske/lubuntu-calibre


# 起動
  docker run -it -p 5901:5901 -p 8808:8808 --rm youske/lubuntu-calibre
  docker run -it -p 5901:5901 -p 8808:8808 --rm youske/lubuntu-calibre shell



# その他

entrykit
https://github.com/progrium/entrykit

gosu
https://github.com/tianon/gosu

lubuntu (lxde)
日本語フォント+

# パスワードの再設定
user: admin
pass: admin
homedir: /home/admin
