e!venv/bin/python3.9
from __future__ import annotations

import json
from typing import Any

from kitty.boss import Boss
from kittens.tui.handler import result_handler

TARGET_CMDLINE = ["node", "/opt/homebrew/bin/codex"]
SIDEBAR_RATIO = 0.30


def main(args: list[str]) -> None:
    pass



def load_session(boss: Boss, target_window_id: int) -> list[dict[str, Any]]:
    window = boss.window_id_map.get(target_window_id)
    raw_session = boss.call_remote_control(window, ("ls",))
    if not raw_session:
        return []
    try:
        return json.loads(raw_session)
    except json.JSONDecodeError:
        return []


def get_active_context(
    session: list[dict[str, Any]]
) -> tuple[dict[str, Any], int, dict[str, Any]] | None:
    for os_window in session:
        if not (os_window.get("is_active") or os_window.get("is_focused")):
            continue
        tabs = os_window.get("tabs", [])
        for index, tab in enumerate(tabs):
            if tab.get("is_active") or tab.get("is_focused"):
                return os_window, index, tab
    return None


def find_codex_in_tab(tab: dict[str, Any]) -> dict[str, Any] | None:
    for window in tab.get("windows", []):
        for process in window.get("foreground_processes", []):
            if process.get("cmdline") == TARGET_CMDLINE:
                return window
    return None


def move_window_to_tab(boss: Boss, window_id: int, target_spec: str) -> None:
    args = (
        "detach-window",
        f"--match=id:{window_id}",
        f"--target-tab={target_spec}",
        "--stay-in-tab=yes",
    )
    boss.call_remote_control(None, args)


def resize_codex_sidebar(boss: Boss, target_window_id: int) -> None:
    session = load_session(boss, target_window_id)
    context = get_active_context(session)
    if context is None:
        return
    _, _, active_tab = context
    codex_window = find_codex_in_tab(active_tab)
    if codex_window is None:
        return
    window_id = codex_window["id"]

    boss.call_remote_control(
        None,
        (
            "resize-window",
            f"--match=id:{window_id}",
            "--axis=reset",
        ),
    )

    session = load_session(boss, target_window_id)
    context = get_active_context(session)
    if context is None:
        return
    _, _, active_tab = context
    codex_window = find_codex_in_tab(active_tab)
    if codex_window is None:
        return

    row_lines = codex_window.get("lines")
    row_windows = [
        window
        for window in active_tab.get("windows", [])
        if window.get("lines") == row_lines
    ]
    total_columns = sum(window.get("columns", 0) for window in row_windows)
    current_columns = codex_window.get("columns", 0)
    if not total_columns or not current_columns:
        return

    desired_columns = max(1, int(round(total_columns * SIDEBAR_RATIO)))
    delta = desired_columns - current_columns
    if delta == 0:
        return

    boss.call_remote_control(
        None,
        (
            "resize-window",
            f"--match=id:{codex_window['id']}",
            "--axis=horizontal",
            f"--increment={delta}",
        ),
    )


def handle_result(args: list[str], answer: str, target_window_id: int, boss:
                  Boss) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        boss.call_remote_control(w, ("send-text", f'--match-id:{w.id}', 'hello world'))

@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    session = load_session(boss, target_window_id)
    context = get_active_context(session)
    if context is None:
        return
    os_window, active_index, active_tab = context
    tabs = os_window.get("tabs", [])
    right_tab = tabs[active_index + 1] if active_index + 1 < len(tabs) else None

    codex_window = find_codex_in_tab(active_tab)
    if codex_window is not None:
        target = f"id:{right_tab['id']}" if right_tab is not None else "new"
        move_window_to_tab(boss, codex_window["id"], target)
        return

    if right_tab is None:
        return

    codex_in_right_tab = find_codex_in_tab(right_tab)
    if codex_in_right_tab is None:
        return

    move_window_to_tab(boss, codex_in_right_tab["id"], f"id:{active_tab['id']}")
    resize_codex_sidebar(boss, target_window_id)
