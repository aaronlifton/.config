from kittens.tui.handler import result_handler

# https://github.com/sxyazi/dotfiles/blob/18ce3eda7792df659cb248d9636b8d7802844831/kitty/window.py
# https://github.com/chancez/dotfiles/blob/master/kitty/.config/kitty/relative_resize.py


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    if window is None:
        return

    def resize(direction):
        neighbors = boss.active_tab.current_layout.neighbors_for_window(
            window, boss.active_tab.windows
        )
        top, bottom = neighbors.get("top"), neighbors.get("bottom")
        left, right = neighbors.get("left"), neighbors.get("right")

        if direction == "top":
            if top and bottom:
                boss.active_tab.resize_window("shorter", 10)
            elif top:
                boss.active_tab.resize_window("taller", 10)
            elif bottom:
                boss.active_tab.resize_window("shorter", 10)
        elif direction == "bottom":
            if top and bottom:
                boss.active_tab.resize_window("taller", 10)
            elif top:
                boss.active_tab.resize_window("shorter", 10)
            elif bottom:
                boss.active_tab.resize_window("taller", 10)
        elif direction == "left":
            if left and right:
                boss.active_tab.resize_window("narrower", 10)
            elif left:
                boss.active_tab.resize_window("wider", 10)
            elif right:
                boss.active_tab.resize_window("narrower", 10)
        elif direction == "right":
            if left and right:
                boss.active_tab.resize_window("wider", 10)
            elif left:
                boss.active_tab.resize_window("narrower", 10)
            elif right:
                boss.active_tab.resize_window("wider", 10)

    resize(args[1])
