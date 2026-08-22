#!/bin/sh

HIDDEN=$(sketchybar --query bar | grep hidden | cut -d'"' -f4)

if [ "$HIDDEN" = "on" ]; then
  sketchybar --bar hidden=off
  osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to true'
else
  sketchybar --bar hidden=on
  osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to false'
fi

# メニューバーの自動非表示切替で screen の visibleFrame が変わり、paneru が
# 古いフレームのままタイル計算した状態が残ってウィンドウが重なって見えることが
# ある（ワークスペース切替で直るのはその際にフレームを再取得するため）。
# アニメーションが収まってから window balance でレイアウトを再計算させる。
( sleep 0.5; paneru send-cmd window balance ) >/dev/null 2>&1 &
