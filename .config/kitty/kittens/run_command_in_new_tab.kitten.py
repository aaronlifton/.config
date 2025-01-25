#!venv/bin/python3.9
from __future__ import annotations
from typing import cast
from kitty.boss import Boss, Window
from kittens.tui.handler import result_handler
from kitty.window import ChildType, ProcessDesc
from kitty.types import WindowGeometry
# import pynvim as nvim


def main(args: list[str]) -> None:
    pass


# def get_current_buffer():
#     nvim.Nvim = nvim.attach("socket", path="/tmp/nvim")
#     buffer = nvim.current.buffer  # Get the current buffer
#     filename = buffer.


# https://github.com/search?q=path%3A**%2Fkitty%2F**%2F*.py+focus-tab&type=code
# Docs: kitten @ --help
@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    win = boss.window_id_map.get(target_window_id)
    tab = boss.active_tab
    if tab is None:
        return
    if win is None:
        return

    # /Users/alifton/Code/kitty/kitty/launch.py:696
    new_win = boss.call_remote_control(None, ("launch", "--cwd=current", "--type=tab"))
    if len(args):
        cmd = " ".join(args[1:])
        _ = boss.call_remote_control(
            None,
            ("send-text", f"--match=id:{new_win}", f"{cmd}\r"),
        )
