#!/usr/bin/env python3
"""
generate_templates.py
Reads config.yml and prints:
  tab_title_template "..."
  active_tab_title_template "..."
The printed templates keep runtime expressions (title, index, num_windows, layout_name, fmt) as-is.
"""

import sys
from pathlib import Path
import yaml
from typing import TypedDict, cast
# from pydantic import BaseModel, StrictStr
# import textwrap

class TabYamlConfig(TypedDict):
    colors: "ColorsConfig"
    symbols: "SymbolsConfig"
    format: "FormatConfig"
    title_selector: "Node"
    title_presentation: "Node"

class ColorsConfig(TypedDict):
    fg_default: str
    fg_active: str
    fg_tab: str
    bold_token: str

class SymbolsConfig(TypedDict):
    stack_symbol: str

class FormatConfig(TypedDict):
    max_title_len: int
    truncate_to: int
    center_width_even: int
    center_width_odd: int

class Node(TypedDict):
    type: str
    cond: str | None
    then: "Node"
    # Can't use keyword `else`
    _else: "Node"
    code: str



# Helpers to render nodes in the decision tree into inline python expressions (strings)
def render_node(node: Node) -> str | None:
    """
    node: dict with keys:
      - type: "if" or "value"
      - cond: condition string (for if)
      - then: node
      - else: node
      - code: code string (for value)
    Returns: a python expression string that can be embedded in an f-string.
    """
    ntype = node.get("type")
    if ntype == "value":
        return node["code"]
    if ntype == "if":
        cond = node["cond"]
        then_node = node["then"]
        else_node = node["_else"]
        then_expr = render_node(then_node)
        else_expr = render_node(else_node)
        # Build a python conditional expression string: (then) if (cond) else (else)
        # Wrap subexpressions with parentheses to be safe.
        return f"(({then_expr})) if ({cond}) else (({else_expr}))"
    raise ValueError(f"Unknown node type: {ntype}")

def set_config(cfg: TabYamlConfig) -> dict[str,str] | None:
# Render title_selector to obtain 'display' expression
        title_selector_node = cfg["title_selector"]
        display_expr = render_node(title_selector_node)
# To avoid duplication we will embed this as a small inline assignment expression
# but many config/template systems do not support assignment; instead we'll inline where needed.
# For readability in the generated templates, we'll place the expression as a parenthesized subexpr named display:
#   ( (title.split('/')[-1]) if title.startswith(...) else (title) )
        display_paren = f"({display_expr})"

# Render presentation tree but replace uses of "display" with the parenthesized expression
        presentation_node = cfg["title_presentation"]
        presentation_expr = render_node(presentation_node)
# Replace literal "display" tokens with the actual expression (safe replace)
        if presentation_expr:
            presentation_expr = presentation_expr.replace("display", display_paren)

# Stack prefix expression (same for both templates)
        stack_symbol = cfg["symbols"]["stack_symbol"]
        stack_expr = f"{{'{' + repr(stack_symbol) + '}'}}"  # temporary form not used
# but we want exact conditional: {' ' if num_windows > 1 and layout_name == 'stack' else ''}
        stack_expr = f"{{'{' + repr(stack_symbol) + '}'}}"  # unused alternative
# Direct building:
        stack_expr = f"{{'${stack_symbol}' if num_windows > 1 and layout_name == 'stack' else ''}}"  # placeholder won't be used
# We need the literal desired expression (no extra $). Build directly:
        stack_expr = f"{{'{' + repr(stack_symbol) + '}'}}"  # repr adds quotes; fix next
# Final correct literal:
        stack_expr = f"{{'{stack_symbol}' if num_windows > 1 and layout_name == 'stack' else ''}}"

# Compose prefix (index, fg colors, bold token, tab fg)
        fg_default = cfg["colors"]["fg_default"]
        fg_active = cfg["colors"]["fg_active"]
        fg_tab = cfg["colors"]["fg_tab"]
        bold_token = cfg["colors"]["bold_token"]

# The presentation_expr may contain format.X references; replace those occurrences
# so they become literal numbers in the template (we want the template to refer to fmt at runtime,
# so keep format references as strings that will be present in output).
# Our config used references like format.max_title_len, but the template should NOT try to evaluate them;
# instead we already used them to shape the final expressions. Because the YAML used those names inside
# code strings (e.g., 'format.max_title_len'), we should replace 'format.' with the numeric values.
# Simpler: read numeric values and replace 'format.max_title_len' etc with their numeric literals.
        fmt_cfg = cfg["format"]
        replacements = {
            "format.max_title_len": str(fmt_cfg["max_title_len"]),
            "format.truncate_to": str(fmt_cfg["truncate_to"]),
            "format.center_width_even": str(fmt_cfg["center_width_even"]),
            "format.center_width_odd": str(fmt_cfg["center_width_odd"]),
        }
        for k, v in replacements.items():
            if presentation_expr:
                presentation_expr = presentation_expr.replace(k, v)

# The presentation_expr is an expression string like:
#   ((f'{((title.split('/')[-1]) if title.startswith(('nvim', '~/')) else title)[:30]}…') if (title.rindex(title[-1]) + 1 > 30) else (((... ).center(6)) if ((...) % 2 == 0) else ((...).center(5))))
# We want to wrap it inside the outer template with colors and index:
        common_prefix = f"{{fmt.fg.{fg_default}}}{{index}} {{fmt.fg.{fg_tab}}}{bold_token}"
        active_prefix = f"{{fmt.fg.{fg_active}}}{{index}} {{fmt.fg.{fg_tab}}}{bold_token}"

# Build final lines; ensure any double quotes inside are handled by using double-quoted outer string
# and leaving internal single quotes intact.
        tab_line = f'tab_title_template \"{common_prefix}{stack_expr}{presentation_expr}\"'
        active_line = f'active_tab_title_template \"{active_prefix}{stack_expr}{presentation_expr}\"'

# Clean up accidental placeholders: ensure no stray Python-level repr artifacts
        tab_line = tab_line.replace("'${stack_symbol}'", f"'{stack_symbol}'")
        active_line = active_line.replace("'${stack_symbol}'", f"'{stack_symbol}'")

# Print
        print(tab_line)
        print(active_line)

def main() -> None:
    """Generate kitty tab title templates."""
    # print(TAB_TEMPLATE)
    # print(ACTIVE_TAB_TEMPLATE)

    # print('''
    # tab_title_template "{fmt.fg._40486A}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:0]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"
    # active_tab_title_template "{fmt.fg._6E7698}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"
    #     ''')
# Load YAML
    cfg_path = Path("tab_config.yml")
    if not cfg_path.exists():
        print("config.yml not found", file=sys.stderr)
        sys.exit(1)

    cfg = cast(TabYamlConfig, yaml.safe_load(cfg_path.read_text()))
    with open(cfg_path, "r") as f:
        cfg = cast(TabYamlConfig, yaml.safe_load(f))
    #
    # print(cfg)
    # print("After\n\n")

    kitty_cfg = set_config(cfg)
    # print(kitty_cfg)

    print('''
tab_title_template "{fmt.fg._40486A}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:0]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"
active_tab_title_template "{fmt.fg._6E7698}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"
        ''')



if __name__ == "__main__":
    main()
