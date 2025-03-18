#!.venv/bin/python3.13
from __future__ import annotations
from typing import cast
from kitty.boss import Boss, Window, json
from kittens.tui.handler import result_handler
from kitty.window import ChildType, ProcessDesc
from kitty.types import WindowGeometry
from kitty.fast_data_types import get_boss, get_options
# import pynvim as nvim


def main(args: list[str]) -> None:
    pass


def get_window_by_id(window_id: int) -> Optional["Window"]:
    return get_boss().window_id_map.get(window_id)


def get_tab_by_id(tab_id: int) -> Optional["Tab"]:
    return get_boss().tab_for_id(tab_id)


# def get_current_buffer():
#     nvim.Nvim = nvim.attach("socket", path="/tmp/nvim")
#     buffer = nvim.current.buffer  # Get the current buffer
#     filename = buffer.

# https://github.com/search?q=path%3A**%2Fkitty%2F**%2F*.py+focus-tab&type=code


# /Users/$USER/Code/kitty_launch_config.json
def read_config(path: str) -> dict[str, list[dict[str, str]]]:
    try:
        with open(path, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Config file not found at {path}")
        return {"tabs": []}  # Return empty tabs list as default
    except json.JSONDecodeError:
        print(f"Invalid JSON format in config file {path}")
        return {"tabs": []}


def setup_tab(dir: str, cmd: str, name: str, boss: Boss):
    winid = boss.call_remote_control(None, ("launch", "--cwd=current", "--type=tab"))
    remote_cmd: str | None = ""
    if cmd:
        remote_cmd = f"cd {dir}; {cmd}"
    else:
        remote_cmd = f"cd {dir};"

    _ = boss.call_remote_control(
        None,
        (
            "send-text",
            f"--match=id:{winid}",
            f"{remote_cmd}\r",  # or '\x0d'
        ),
    )
    boss = get_boss()
    _ = boss.set_tab_title(name)


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

    # /Users/$USER/Code/kitty/kitty/launch.py:696
    # /Users/$USER/Code/kitty/docs/remote-control.rst
    setup_tab("~/synack/frontend_researcher", "nvim .", "frontend_researcher ", boss)
    setup_tab("~/synack/frontend_client", "nvim .", "frontend_client ", boss)


# window = get_boss().window_id_map.get(winid)
# tab = get_boss().tab_for_id(winid)
# tab.set_title("frontend_researcher")
