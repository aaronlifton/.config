#!/usr/bin/env rust-script

use std::io::{self, BufRead, BufReader, Write};
use std::process::{Command, Stdio};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Get all windows with details
    let output = Command::new("aerospace")
        .args(&[
            "list-windows",
            "--all",
            "--format",
            "%{window-id}|%{app-name}|%{window-title}|%{workspace}",
        ])
        .output()?;

    if !output.status.success() {
        eprintln!("Failed to get window list");
        return Ok(());
    }

    let windows = String::from_utf8(output.stdout)?;

    // Use fzf to select a window
    let mut fzf = Command::new("fzf")
        .args(&[
            "--delimiter=|",
            "--with-nth=2,3,4",
            "--preview=echo \"App: {2}\\nTitle: {3}\\nWorkspace: {4}\"",
            "--preview-window=up:3:wrap",
            "--header=Select window to focus",
            "--prompt=Window> ",
        ])
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()?;

    // Write windows to fzf stdin
    if let Some(stdin) = fzf.stdin.as_mut() {
        stdin.write_all(windows.as_bytes())?;
    }

    let output = fzf.wait_with_output()?;

    if !output.status.success() {
        // User cancelled or fzf failed
        return Ok(());
    }

    let selected = String::from_utf8(output.stdout)?.trim().to_string();

    // Focus the selected window
    if !selected.is_empty() {
        let window_id = selected.split('|').next().unwrap_or("");
        if !window_id.is_empty() {
            Command::new("aerospace")
                .args(&["focus", "--window-id", window_id])
                .status()?;
        }
    }

    Ok(())
}
