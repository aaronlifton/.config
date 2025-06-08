const capsToHyper = {
                        "description": "Change caps_lock key to command+control+option+shift. (Use shift+caps_lock as caps_lock)",
                        "manipulators": [
                            {
                                "from": {
                                    "key_code": "caps_lock",
                                    "modifiers": {
                                        "mandatory": ["shift"],
                                        "optional": ["caps_lock"]
                                    }
                                },
                                "to": [{ "key_code": "caps_lock" }],
                                "type": "basic"
                            },
                            {
                                "conditions": [
                                    {
                                        "bundle_identifiers": [
                                            "net.kovidgoyal.kitty",
                                            "io.alacritty",
                                            "com.mitchellh.ghostty"
                                        ],
                                        "type": "frontmost_application_unless"
                                    }
                                ],
                                "from": {
                                    "key_code": "caps_lock",
                                    "modifiers": { "optional": ["any"] }
                                },
                                "to": [
                                    {
                                        "key_code": "left_shift",
                                        "modifiers": ["left_command", "left_control", "left_option"]
                                    }
                                ],
                                "type": "basic"
                            }
                        ]
                    }
const capsToEsc = {
                        "description": "CapsLock to Esc when press & to Control when hold",
                        "manipulators": [
                            {
                                "conditions": [
                                    {
                                        "bundle_identifiers": [
                                            "net.kovidgoyal.kitty",
                                            "io.alacritty",
                                            "com.mitchellh.ghostty"
                                        ],
                                        "type": "frontmost_application_if"
                                    }
                                ],
                                "from": {
                                    "key_code": "caps_lock",
                                    "modifiers": { "optional": ["any"] }
                                },
                                "to": [{ "key_code": "right_control" }],
                                "to_if_alone": [{ "key_code": "escape" }],
                                "type": "basic"
                            },
                            {
                                "from": {
                                    "key_code": "caps_lock",
                                    "modifiers": { "optional": ["any"] }
                                },
                                "to": [{ "key_code": "right_gui" }],
                                "to_if_alone": [{ "key_code": "escape" }],
                                "type": "basic"
                            }
                        ]
                    }
