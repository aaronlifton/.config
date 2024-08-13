#!venv/bin/python3.9
from __future__ import annotations
from typing import cast
from kitty.boss import Boss, Window
from kittens.tui.handler import result_handler
from kitty.window import ChildType, ProcessDesc
from kitty.types import WindowGeometry
# import pynvim as nvim

# from kitty.fast_data_types import (
#     GLFW_EDGE_BOTTOM,
#     GLFW_EDGE_LEFT,
#     GLFW_EDGE_RIGHT,
#     GLFW_EDGE_TOP,
#     GLFW_LAYER_SHELL_BACKGROUND,
#     GLFW_LAYER_SHELL_PANEL,
#     glfw_primary_monitor_size,
#     make_x11_window_a_dock_window,
# )
# import subprocess


def main(args: list[str]) -> None:
    pass


# def get_current_buffer():
#     nvim.Nvim = nvim.attach("socket", path="/tmp/nvim")
#     buffer = nvim.current.buffer  # Get the current buffer
#     filename = buffer.


# Docs: kitten @ --help
@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    # global window_width, window_height
    # monitor_width, monitor_height = glfw_primary_monitor_size()
    win = boss.window_id_map.get(target_window_id)
    tab = boss.active_tab
    if tab is None:
        return
    if win is None:
        return

    tab_wins: list[Window] = tab.windows.all_windows
    if len(tab_wins) > 1:
        _ = boss.call_remote_control(None, ("close-window", "--match=neighbor:right"))
        return

    new_win = boss.call_remote_control(
        None,
        (
            "launch",
            "--type=window",
            "--cwd=current",
            "--title=current",
        ),
    )
    if new_win is not None:
        _ = boss.call_remote_control(
            win, ("send-text", f"--match=id:{new_win}", "ls\r")
        )
        if tab.current_layout.name != "tall":
            _ = boss.call_remote_control(
                win, ("goto-layout", "--match=state:focused", "tall")
            )
        _ = boss.call_remote_control(
            win, ("focus-window", "--match=neighbor:left", "--no-response")
        )
        _ = boss.call_remote_control(
            win, ("resize-window", f"--match=id:{new_win}", "--axis=reset")
        )

        _ = boss.call_remote_control(
            win,
            (
                "resize-window",
                f"--match=id:{new_win}",
                "--axis=horizontal",
                "--increment=-40",
            ),
        )

        if len(args):
            cmd = " ".join(args[1:])
            _ = boss.call_remote_control(
                None,
                ("send-text", f"--match=id:{new_win}", f"{cmd}\r"),
            )
