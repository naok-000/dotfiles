# Emacs

## package.el archive cache

`package-initialize` は，ローカルにある installed package と archive cache を読むだけで，起動時に `package-refresh-contents` は実行しない．

新しいパッケージを追加するときや，MELPA/ELPA の tarball が `Not found` になるときは，先に package archive の索引を更新する．

```text
M-x package-refresh-contents
M-x package-install RET package-name RET
```

例: `nerd-icons-dired` を追加する場合．

```text
M-x package-refresh-contents
M-x package-install RET nerd-icons-dired RET
```

`package-refresh-contents` を init に入れて毎回起動時に実行するのは避ける．Emacs 起動がネットワークと外部 package archive の状態に依存し，起動失敗の原因になるため．
