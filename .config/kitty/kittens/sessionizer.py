import json

import os
import sys

from kitty.boss import Boss

SHELL = "fish"
SESSIONS_LOCATION = "~/.config/kitty/sessions"


def main(args: list[str]) -> str:
    while True:
        try:
            answer = input("Enter session name: ")
            if session_file_exists(answer):
                action = input("Overwrite session file? (y or n): ")
                if action == "y":
                    return answer
            else:
                return answer
        except KeyboardInterrupt:
            sys.exit(0)


def session_file_exists(file_name: str) -> bool:
    path = os.path.expanduser(SESSIONS_LOCATION)
    return os.path.exists(f"{path}/{file_name}")


def env_to_str(env: dict):
    return " ".join(f"--env {k}={v}" for k, v in env.items())


def cmdline_to_string(cmdline: list):
    return " ".join(cmdline)


def fg_process_to_string(fg_processes: list):
    fg = fg_processes[0]
    result = ""

    result += cmdline_to_string(fg["cmdline"])

    if result == "kitty @ ls":
        return SHELL

    return result


def is_python_project(directory: str) -> bool:
    common_files = ["setup.py", "pyproject.toml", "requirements.txt", "Pipfile"]
    for file in common_files:
        if os.path.isfile(os.path.join(directory, file)):
            return True

    for file in os.listdir(directory):
        if file.endswith(".py"):
            return True


def get_venv_command(directory: str) -> str:
    venv_dirs = [".venv", ".env", "env", ".virtualenv"]

    for venv_dir in venv_dirs:
        venv_path = os.path.join(directory, venv_dir)
        if os.path.isdir(venv_path):
            activate_bin = "activate"
            if SHELL == "nu":
                activate_bin = "activate.nu"
            elif SHELL == "fish":
                activate_bin = "activate.fish"

            if os.name == "nt":
                activate_script = os.path.join(venv_path, "Scripts", activate_bin)
            else:
                activate_script = os.path.join(venv_path, "bin", activate_bin)

            if SHELL == "nu":
                return f"overlay use {activate_script}"

            return f"source {activate_script}"


def get_session_file_string(session_info: list[dict]) -> str:
    session_file_commands = []
    for os_window in session_info:
        if os_window != session_info[0]:
            session_file_commands.append("new_os_window")
        if os_window.get("is_focused"):
            session_file_commands.append("focus_os_window")

        for tab in os_window["tabs"]:
            tab_title = tab.get("title")
            if tab_title and tab_title != "kitty":
                session_file_commands.append(f"new_tab {tab.get('title') or ''}")

            if tab.get("enabled_layouts"):
                session_file_commands.append(
                    f"enabled_layouts {','.join(tab['enabled_layouts'])}"
                )
            if tab.get("layout"):
                session_file_commands.append(f"layout {tab['layout']}")

            for window in tab["windows"]:
                # Pass if its the sessionizer script
                if "kittens/sessionizer.py" in window["cmdline"]:
                    continue
                directory = window["cwd"]
                session_file_commands.append(f"cd {directory}")
                command_str = fg_process_to_string(window["foreground_processes"])
                if is_python_project(directory):
                    venv_command = get_venv_command(directory)
                    if SHELL == "nu":
                        command_str = f"nu -e '{venv_command}; {command_str}'"
                    elif SHELL == "fish":
                        command_str = f"fish -C '{venv_command}; {command_str}'"
                    else:
                        command_str = (
                            f"${os.getenv('SHELL')} -C '{venv_command}; {command_str}'"
                        )

                launch_command_str = f"launch {env_to_str(window['env'])} --hold {'--keep-focus' if window['is_focused'] else ''} {command_str}"
                session_file_commands.append(launch_command_str)

                # command = " ".join(window["foreground_processes"][0]["cmdline"])
                # session_file_commands.append(
                #     "launch {} -C '{} -c \"{}\"'".format(SHELL, SHELL, command)
                # )

    return "\n".join(session_file_commands)


def write_session_file(session_string: str, session_name: str):
    session_path = os.path.expanduser(SESSIONS_LOCATION or "~/.config/kitty/sessions")
    if not os.path.exists(session_path):
        os.mkdir(session_path)

    with open(f"{session_path}/{session_name}", "w") as f:
        f.writelines(session_string)


def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    result = boss.call_remote_control(w, ("ls",))

    session_file_string = get_session_file_string(json.loads(result))

    write_session_file(session_file_string, answer)
