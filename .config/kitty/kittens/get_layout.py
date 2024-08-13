from __future__ import annotations
from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main():
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str], result: str, target_window_id: int, boss: Boss
) -> str | None:
    active_tab = boss.active_tab
    if active_tab is None:
        return None

    return active_tab.current_layout.name
