#!/usr/bin/env python3
"""
Add SIGUSR1/SIGUSR2 signal handlers to PCSX-ReARMed for spruceOS integration.

SIGUSR1: Save state to slot 0 and exit cleanly (home button hold → game switcher)
SIGUSR2: Open emulator menu (home button tap → emulator menu)
"""
import re

import os
# Handle being run from either /build or /build/pcsx_rearmed
if os.path.exists("frontend/main.c"):
    MAIN_C = "frontend/main.c"
elif os.path.exists("pcsx_rearmed/frontend/main.c"):
    MAIN_C = "pcsx_rearmed/frontend/main.c"
else:
    raise FileNotFoundError("Cannot find frontend/main.c")

with open(MAIN_C, "r") as f:
    src = f.read()

# 1. Add signal handler functions before main()
#    Insert right before "int main(int argc"
signal_handlers = '''
static volatile int sigusr1_triggered;

static void SignalSaveAndQuit(int sig) {
\t// SIGUSR1: flag save-and-quit for main loop
\tsigusr1_triggered = 1;
\temu_action = SACTION_SAVE_STATE;
\tpsxRegs.stop++;
}

static void SignalEnterMenu(int sig) {
\t// SIGUSR2: open emulator menu
\temu_action = SACTION_ENTER_MENU;
\tpsxRegs.stop++;
}

'''

anchor = "int main(int argc, char *argv[])"
assert anchor in src, f"Could not find '{anchor}' in {MAIN_C}"
src = src.replace(anchor, signal_handlers + anchor, 1)

# 2. Register signal handlers in main(), after signal(SIGPIPE, SignalExit)
#    Find the _OpenPlugins signal registrations and add ours after
signal_reg = "\tsignal(SIGPIPE, SignalExit);\n"
new_signal_reg = signal_reg + "\tsignal(SIGUSR1, SignalSaveAndQuit);\n\tsignal(SIGUSR2, SignalEnterMenu);\n"
assert signal_reg in src, f"Could not find signal(SIGPIPE) in {MAIN_C}"
src = src.replace(signal_reg, new_signal_reg, 1)

# 3. In the main loop, after do_emu_action(), check if sigusr1 means quit
#    Find: "if (emu_action != SACTION_NONE)\n\t\t\tdo_emu_action();"
#    Add quit check after it
loop_action = "if (emu_action != SACTION_NONE)\n\t\t\tdo_emu_action();"
quit_check = loop_action + "\n\t\tif (sigusr1_triggered)\n\t\t\tg_emu_want_quit = 1;"
assert loop_action in src, f"Could not find emu_action loop check in {MAIN_C}"
src = src.replace(loop_action, quit_check, 1)

with open(MAIN_C, "w") as f:
    f.write(src)

print("Patched: SIGUSR1 (save+quit) and SIGUSR2 (enter menu) signal handlers added")
