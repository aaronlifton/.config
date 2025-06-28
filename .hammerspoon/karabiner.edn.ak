; check https://github.com/alex35mil/dotfiles/blob/98c4539994572df10c4b941b04d43a14c6024ccc/home/.config/karabiner.edn
; for integration between karabiner and hammerspoon
{
 :devices {:mode65 [{:vendor_id 222 :product_id 22356}]}
 
 :applications {:terminals ["^net\\.kovidgoyal\\.kitty$" 
                            "^io\\.alacritty$" 
                            "^com\\.mitchellh\\.ghostty$"]}
 
 :main [
   ;; Change caps_lock key to command+control+option+shift. (Use shift+caps_lock as caps_lock)
        {:des "Change caps_lock key to command+control+option+shift. (Use shift+caps_lock as caps_lock)"
         :rules [[:!Scaps_lock :caps_lock]
                 [:##caps_lock :!CTOleft_shift :!terminals]]}
   
   ;; Change caps_lock to control if pressed with other keys, to escape if pressed alone.
   ; {:des "Change caps_lock to control if pressed with other keys, to escape if pressed alone."
   ;  :rules [[]] ;; Disabled rule
   ;  :enabled false}
   
   ;; CapsLock to Esc when press & to Control when hold
   ; {:des "CapsLock to Esc when press & to Control when hold"
   ;  :rules [[:condi :terminals]
   ;          [:##caps_lock :right_control nil {:to_if_alone :escape}]]}
        {:des "CapsLock to Esc when press & to Control when hold"
         :rules [[:##caps_lock :right_control nil {:to_if_alone :escape :condi [:terminals]}]
                 [:##caps_lock :right_gui nil {:to_if_alone :escape}]]}
            
     
   ;; Device-specific modifications
        {:des "Device-specific modifications for Mode65"

         :rules [:mode65
                 [:right_control :right_command]]}

   ;; Function key mappings
   ; {:des "Function key mappings"
   ;  :rules [[:f3 :mission_control]
   ;          [:f4 :launchpad]]}
        {:des "simultaneous j l press to F18" :rules [[[:j :l] :f18]]}]}
; check https://github.com/alex35mil/dotfiles/blob/98c4539994572df10c4b941b04d43a14c6024ccc/home/.config/karabiner.edn
; for integration between karabiner and hammerspoon
{
 :devices {:mode65 [{:vendor_id 222 :product_id 22356}]}
 
 :applications {:terminals ["^net\\.kovidgoyal\\.kitty$" 
                            "^io\\.alacritty$" 
                            "^com\\.mitchellh\\.ghostty$"]}
 
 :main [
   ;; Change caps_lock key to command+control+option+shift. (Use shift+caps_lock as caps_lock)
        {:des "Change caps_lock key to command+control+option+shift. (Use shift+caps_lock as caps_lock)"
         :rules [[:!Scaps_lock :caps_lock]
                 [:##caps_lock :!CTOleft_shift :!terminals]]}
   
   ;; Change caps_lock to control if pressed with other keys, to escape if pressed alone.
   ; {:des "Change caps_lock to control if pressed with other keys, to escape if pressed alone."
   ;  :rules [[]] ;; Disabled rule
   ;  :enabled false}
   
   ;; CapsLock to Esc when press & to Control when hold
   ; {:des "CapsLock to Esc when press & to Control when hold"
   ;  :rules [[:condi :terminals]
   ;          [:##caps_lock :right_control nil {:to_if_alone :escape}]]}
        {:des "CapsLock to Esc when press & to Control when hold"
         :rules [[:##caps_lock :right_control nil {:to_if_alone :escape :condi [:terminals]}]
                 [:##caps_lock :right_gui nil {:to_if_alone :escape}]]}
            
     
   ;; Device-specific modifications
        {:des "Device-specific modifications for Mode65"
         :rules [:mode65
                 [:right_control :right_command]]}

   ;; Function key mappings
   ; {:des "Function key mappings"
   ;  :rules [[:f3 :mission_control]
   ;          [:f4 :launchpad]]}
        {:des "simultaneous j l press to F18" :rules [[[:j :l] :f18]]}]} 
 

 
 
  
 
