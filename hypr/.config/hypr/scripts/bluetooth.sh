#!/bin/bash
# Audio connection monitor script. Runs status checks upon execution, designed to be called by systemd/daemon.
# Logs output to ~/.local/share/bluetooth_audio_connect.log and STDOUT.

LOG_FILE="$HOME/.local/share/bluetooth_audio_connect.log"

echo "$(date): -----------------------------------------------------------" > "$LOG_FILE"
echo "$(date): Initializing Bluetooth Audio Connection Check." | tee "$LOG_FILE"

# Function to handle connection check and sink switching
check_and_switch_audio() {
    echo "$(date): --- Running connection check against current Bluetooth state ---" | tee -a "$LOG_FILE"
    
    # Attempt to get general connection info
    bluetoothctl show | tee -a "$LOG_FILE"

    # Detect connected devices
    bluetoothctl connected | while read LINE; do
        if [[ $LINE =~ "Device" ]] && [[ $LINE =~ "Connected: yes" ]]; then
            MAC=$(echo "$LINE" | awk '{print $2}')
            
            MODEL_NAME=$(bluetoothctl info "$MAC" 2>&1 | grep "Name:" | awk '{print $2}' | head -n 1)

            if [ -z "$MODEL_NAME" ]; then
                echo "$(date): [ERROR] Could not retrieve model name for $MAC. Check bluetoothctl logs." | tee -a "$LOG_FILE"
                continue
            fi
            
            local DEVICENAME="bluetooth_$MAC"
            echo "$(date): [INFO] Device detected: $MODEL_NAME ($MAC). Running logic for $DEVICENAME." | tee -a "$LOG_FILE"
            
            # 1. Detect and switch Bluetooth Sink
            SINK_OUTPUT=$(pactl list sinks 2>&1)
            SINK_NAME=$(echo "$SINK_OUTPUT" | grep -B 1 "$MAC" | grep "Name:" | awk '{print $3}' | head -n 1)
            
            if [ -n "$SINK_NAME" ]; then
                echo "$(date): [ACTION] Setting default sink to Bluetooth: '$SINK_NAME'..." | tee -a "$LOG_FILE"
                pactl set-default-sink "$SINK_NAME" 2>&1 | tee -a "$LOG_FILE"
            else
                echo "$(date): [WARNING] Could not identify a Bluetooth sink for $MAC." | tee -a "$LOG_FILE"
            fi

            # 2. Force onboard jack profile switch
            ONBOARD_JACK_INFO=$(pactl list cards | grep -i "headphone")
            
            if [[ "$ONBOARD_JACK_INFO" ]]; then
                 echo "$(date): [ACTION] Checking onboard jack settings..." | tee -a "$LOG_FILE"
                card_name=$(echo "$ONBOARD_JACK_INFO" | grep -oP '.*card\s+\K\S+' | head -n 1)
                if [ -n "$card_name" ]; then
                    echo "$(date): [ACTION] Attempting to set $card_name profile to 'headphone'..." | tee -a "$LOG_FILE"
                    pactl set-card-profile "$card_name" headphone 2>&1 | tee -a "$LOG_FILE"
                else
                    echo "$(date): [WARNING] Could not extract a clear card name from 'headphone' searches." | tee -a "$LOG_FILE"
                fi
            else
                echo "$(date): [INFO] No obvious onboard headphone jack sink detected via pactl list cards." | tee -a "$LOG_FILE"
            fi
        fi
    done
    echo "$(date): --- Check complete ---" | tee -a "$LOG_FILE"
}

# Execute the check once when the script is run manually (for testing connectivity)
check_and_switch_audio

# For daemon use, this script *should be* managed by systemd which calls it periodically.
# If you must keep it as a listener, the dbus-monitor loop from the previous attempt is required,
# but it should NEVER be executed directly in a terminal session.