from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: list[str]) -> None:
    pass


@result_handler(no_ui=True)
def handle_result(args: list[str], target_window_id: int, boss: Boss) -> None:
    win = boss.window_id_map.get(target_window_id)
