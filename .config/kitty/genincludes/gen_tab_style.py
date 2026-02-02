"""
Generate kitty tab title templates (no external packages).

This prints:
  tab_title_template "..."
  active_tab_title_template "..."

The expressions inside {...} are left intact for kitty to evaluate at runtime.
"""

from dataclasses import dataclass


@dataclass(frozen=True)
class TemplateConfig:
    fg_default: str
    fg_active: str
    fg_tab: str
    bold_token: str
    stack_symbol: str
    max_title_len: int
    truncate_inactive_to: int
    truncate_active_to: int
    center_width_even: int
    center_width_odd: int


DEFAULTS = TemplateConfig(
    fg_default="_40486A",
    fg_active="_6E7698",
    fg_tab="tab",
    bold_token="{fmt.bold}",
    stack_symbol=" ",
    max_title_len=30,
    truncate_inactive_to=28,
    truncate_active_to=30,
    center_width_even=6,
    center_width_odd=5,
)


def display_expr() -> str:
    # Show last path segment for nvim/~/ titles, otherwise full title.
    return (
        "((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) "
        "if title.startswith(('nvim', '~/')) else title)"
    )


def length_expr() -> str:
    # Equivalent to len(title) but matches the original template logic.
    return "title.rindex(title[-1]) + 1"


def presentation_expr(max_len: int, truncate_to: int, even_width: int, odd_width: int) -> str:
    display = display_expr()
    length = length_expr()
    length_paren = f"({length})"
    truncate = f"f'{{{display}[:{truncate_to}]}}…'"
    center_even = f"{display}.center({even_width})"
    center_odd = f"{display}.center({odd_width})"
    return (
        f"{truncate} if {length} > {max_len} "
        f"else ({center_even} if {length_paren} % 2 == 0 else {center_odd})"
    )


def presentation_expr_prefix_ellipsis(
    max_len: int,
    truncate_to: int,
    even_width: int,
    odd_width: int,
) -> str:
    display = display_expr()
    length = length_expr()
    length_paren = f"({length})"
    truncate = f"f'…{{{display}[:{truncate_to}]}}'"
    center_even = f"{display}.center({even_width})"
    center_odd = f"{display}.center({odd_width})"
    return (
        f"{truncate} if {length} > {max_len} "
        f"else ({center_even} if {length_paren} % 2 == 0 else {center_odd})"
    )


def template_lines(cfg: TemplateConfig) -> tuple[str, str]:
    prefix_inactive = f"{{fmt.fg.{cfg.fg_default}}}{{index}} {{fmt.fg.{cfg.fg_tab}}}{cfg.bold_token}"
    prefix_active = f"{{fmt.fg.{cfg.fg_active}}}{{index}} {{fmt.fg.{cfg.fg_tab}}}{cfg.bold_token}"
    stack_expr = f"{{'{cfg.stack_symbol}' if num_windows > 1 and layout_name == 'stack' else ''}}"

    inactive_expr = presentation_expr_prefix_ellipsis(
        cfg.max_title_len,
        cfg.truncate_inactive_to,
        cfg.center_width_even,
        cfg.center_width_odd,
    )
    active_expr = presentation_expr(
        cfg.max_title_len,
        cfg.truncate_active_to,
        cfg.center_width_even,
        cfg.center_width_odd,
    )

    tab_line = f'tab_title_template "{prefix_inactive}{stack_expr}{{{inactive_expr}}}"'
    active_line = f'active_tab_title_template "{prefix_active}{stack_expr}{{{active_expr}}}"'
    return tab_line, active_line


def main() -> None:
    tab_line, active_line = template_lines(DEFAULTS)
    print(tab_line)
    print(active_line)


if __name__ == "__main__":
    main()
