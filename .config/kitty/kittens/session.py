#!.venv/bin/python3.13
from __future__ import annotations
from typing import TypedDict, List
import json
# import pynvim as nvim

# import math
# import re
from itertools import islice
from os.path import expanduser
from typing import cast

from kittens.tui.handler import Handler, result_handler
from kittens.tui.loop import Loop
from kittens.tui.operations import repeat, styled
from kitty.boss import Boss, Window, json
from kitty.fast_data_types import current_focused_os_window_id, get_boss, get_options
from kitty.key_encoding import RELEASE
from kitty.remote_control import create_basic_command, encode_send
from kitty.types import KeyEventType, WindowGeometry
from typing_extensions import NotRequired  # for Python < 3.11
from kitty.window import ChildType, ProcessDesc
from pathlib import Path

import subprocess



def notify(message: str) -> None:
    subprocess.check_call(['notify-send', message])

def main(args: list[str]) -> None:
    pass


def get_window_by_id(window_id: int) -> Window|None:
    return get_boss().window_id_map.get(window_id)


def get_tab_by_id(tab_id: int) -> Tab|None:
    return get_boss().tab_for_id(tab_id)




# window: OsWindow = {
# 'id': 1,
# 'is_focused': True,
# 'tabs': [
#     {
#         'id': 1,
#         'active_window_idx': 0,
#         'windows': []
#     }
# ],
# 'active_tab_idx': 0
# }
class Window(TypedDict):
    cmdline: str
    foreground_processes: list[dict[str, str]]

class Tab(TypedDict):
    id: int;
    title: str;
    active_window_idx: int;
    windows: list[Window]  # You can create a Window type if needed
    layout: str;
    enabled_layouts: list[str]

class OsWindow(TypedDict):
    id: int;
    is_focused: bool;
    tabs: list[Tab];
    geometry: NotRequired[WindowGeometry];
    active_tab_idx: int;

class SessionState():
    session_names: list[str];
    selected_session_idx: int;
    cmds: list[str];
    windows_text: dict[str, str];
    def __init__(self):
        self.session_names: list[str] = {}
        self.os_windows: list[OsWindow] = []
        # self.selected_session_idx = None
        self.cmds = []
        self.windows_text = {}

class GlobalState():
    session_state: SessionState
    def __init__(self):
        self.session_state = SessionState()
        self.session_state.session_names = []
        self.session_state.selected_session_idx = None
        self.session_state.cmds = []
        self.session_state.windows_text = {}


def get_session_file_string(session_info: list[OsWindow]) -> str:
    commands = []
    state = {}
    for i, os_window in enumerate(session_info):
        state = { window = os_window}
        if i != 0:
            state["os_windows"] << os_window
        if os_window.get("is_focused"):

        for tab in os_window["tabs"]:
            title = tab.get("title")
            if title and title != "kitty":
                commands.append(f"new_tab {title}")

            if tab.get("enabled_layouts"):
                commands.append(f"enabled_layouts {','.join(tab['enabled_layouts'])}")
            if tab.get("layout"):
                commands.append(f"layout {tab['layout']}")

            for window in tab["windows"]:
                if "kittens/sessionizer.py" in window["cmdline"]:
                    continue

                cwd = window["cwd"]
                commands.append(f"cd {cwd}")
                cmd = fg_process_to_string(window["foreground_processes"])

                if is_python_project(cwd):
                    venv_cmd = get_venv_command(cwd)
                    shell_arg = f"'{venv_cmd}; {cmd}'"
                    if SHELL == "nu":
                        cmd = f"nu -e {shell_arg}"
                    elif SHELL == "fish":
                        cmd = f"fish -C {shell_arg}"
                    else:
                        cmd = f"${os.getenv('SHELL')} -C {shell_arg}"

                launch_cmd = f"launch {env_to_str(window['env'])} --hold {'--keep-focus' if window['is_focused'] else ''} {cmd}"
                commands.append(launch_cmd)

    return "\n".join(commands)

@result_handler()
def handle_result(args: List[str], data: Response, target_window_id: int, boss: BossType) -> None:
    # if data['response'] is not None:
    #     func, *args = data['items']
    #     getattr(boss, func)(data['response'], *args)
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        return

    result = boss.call_remote_control(w, ("ls",))
    session_file_string = get_session_file_string(json.loads(result))
