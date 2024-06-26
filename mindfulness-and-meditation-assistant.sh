#!/bin/bash

# Function to display usage
function usage() {
    echo "Usage: $0 [--help]"
    echo
    echo "Options:"
    echo "  --help    Display this help message and exit"
    echo
    echo "This script guides you through a mindfulness and meditation session."
    echo "You can customize the session by setting preferences for voices, durations, and sound files."
    echo "You can also log the session, repeat the session, and set a reminder for the next session."
    exit 0
}

# Check command line options
for i in "$@"
do
case $i in
    --help)
    usage
    shift
    ;;
    *)
    # unknown option
    ;;
esac
done

# Function to save preferences
function save_preferences() {
    read -p "Would you like to save your preferences for future sessions? (yes/no): " save_choice
    if [ "$save_choice" == "yes" ]; then
        echo "default_voice=$default_voice" >> preferences.txt
        echo "breathing_duration=$breathing_duration" > preferences.txt
        echo "mindfulness_duration=$mindfulness_duration" >> preferences.txt
        echo "reflection_duration=$reflection_duration" >> preferences.txt
        echo "breathing_voice=$breathing_voice" >> preferences.txt
        echo "mindfulness_voice=$mindfulness_voice" >> preferences.txt
        echo "reflection_voice=$reflection_voice" >> preferences.txt
        echo "custom_sound_file=$custom_sound_file" >> preferences.txt
        echo "reflection_sound_file=$reflection_sound_file" >> preferences.txt
        echo "guided_meditation_voice=$guided_meditation_voice" >> preferences.txt
        echo "guided_meditation_text=$guided_meditation_text" >> preferences.txt
        echo "VOICE=$VOICE" >> preferences.txt
    fi
}

# Function to load preferences
function load_preferences() {
    if [[ -f preferences.txt ]]; then
        source preferences.txt
    fi
}

# Load preferences at the start of the script
load_preferences

# Function to validate if input is a number
function validate_number() {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        echo "Error: Not a number" >&2; exit 1
    fi
}

# Function to validate if file exists
function validate_file() {
    if ! [[ -f $1 ]]; then
        echo "Error: File does not exist" >&2; exit 1
    fi
}

# Function to get default voice
function get_default_voice() {
    read -p "Would you like to set a default voice for the session? (yes/no): " default_voice_choice
    if [ "$default_voice_choice" == "yes" ]; then
        read -p "Please enter the default voice you want to use: " default_voice
    fi
}

# Get default voice at the start of the script
get_default_voice

# Function to get voice
function get_voice() {
    read -p "Would you like to use the default voice (English) or a custom voice for $1? (default/custom): " voice_choice
    if [ "$voice_choice" == "custom" ]; then
        read -p "Please enter the voice you want to use: " voice
    else
        voice="en"
    fi
    echo $voice
}

# Function to get global voice
function get_global_voice() {
    read -p "Would you like to use the same voice for all parts of the session? (yes/no): " global_voice_choice
    if [ "$global_voice_choice" == "yes" ]; then
        read -p "Please enter the voice you want to use: " global_voice
    else
        global_voice=""
    fi
    echo $global_voice
}

# Function to get meditation text
function get_meditation_text() {
    read -p "Would you like to use the default meditation text or a custom text? (default/custom): " text_choice
    if [ "$text_choice" == "custom" ]; then
        read -p "Please enter the meditation text you want to use: " text
    else
        text="Now, imagine you are in a peaceful place. It could be a forest, a beach, or anywhere you find calming. Visualize the details of this place. What do you see? What do you hear? What do you smell? Stay in this place for as long as you need."
    fi
    echo $text
}

# Function to log meditation session
function log_session() {
    read -p "Would you like to log this meditation session? (yes/no): " log_choice
    if [ "$log_choice" == "yes" ]; then
        echo "$(date): Meditation session completed" >> meditation_log.txt
    fi
}

# Function to skip part
function skip_part() {
    read -p "Would you like to skip $1? (yes/no): " skip_choice
    if [ "$skip_choice" == "yes" ]; then
        return 1
    else
        return 0
    fi
}

# Function to get default durations
function get_default_durations() {
    read -p "Would you like to set default durations for the breathing exercises, mindfulness exercise, and reflection time? (yes/no): " default_durations_choice
    if [ "$default_durations_choice" == "yes" ]; then
        read -p "Please enter the default duration (in seconds) for the breathing exercises: " default_breathing_duration
        validate_number $default_breathing_duration
        read -p "Please enter the default duration (in seconds) for the mindfulness exercise: " default_mindfulness_duration
        validate_number $default_mindfulness_duration
        read -p "Please enter the default duration (in seconds) for the reflection time: " default_reflection_duration
        validate_number $default_reflection_duration
        echo "default_breathing_duration=$default_breathing_duration" >> preferences.txt
        echo "default_mindfulness_duration=$default_mindfulness_duration" >> preferences.txt
        echo "default_reflection_duration=$default_reflection_duration" >> preferences.txt
    fi
}

# Function to get default sound files
function get_default_sound_files() {
    read -p "Would you like to set default sound files for the mindfulness exercise and reflection time? (yes/no): " default_sound_files_choice
    if [ "$default_sound_files_choice" == "yes" ]; then
        read -p "Please enter the path to the default sound file for the mindfulness exercise: " default_mindfulness_sound_file
        validate_file $default_mindfulness_sound_file
        read -p "Please enter the path to the default sound file for the reflection time: " default_reflection_sound_file
        validate_file $default_reflection_sound_file
        echo "default_mindfulness_sound_file=$default_mindfulness_sound_file" >> preferences.txt
        echo "default_reflection_sound_file=$default_reflection_sound_file" >> preferences.txt
    fi
}

# Load default sound files at the start of the script
get_default_sound_files

# Function to run the meditation session
function run_session() {
    # Welcome message
    GLOBAL_VOICE=$(get_global_voice)
    if [ -z "$GLOBAL_VOICE" ]; then
        VOICE=$(get_voice "Welcome to your mindfulness and meditation session. Let's start with a deep breath.")
    else
        VOICE=$GLOBAL_VOICE
    fi
    spd-say -l $VOICE "Welcome to your mindfulness and meditation session. Let's start with a deep breath."

    # Load default durations at the start of the script
    get_default_durations

    # Use default durations if they are set
    if [[ -n $default_breathing_duration ]]; then
        breathing_duration=$default_breathing_duration
    fi
    if [[ -n $default_mindfulness_duration ]]; then
        mindfulness_duration=$default_mindfulness_duration
    fi
    if [[ -n $default_reflection_duration ]]; then
        reflection_duration=$default_reflection_duration
    fi

    # Get voice for each part
    echo "For the breathing exercises:"
    breathing_voice=$(get_voice "Inhale deeply.")
    echo "For the mindfulness exercise:"
    mindfulness_voice=$(get_voice "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body.")
    echo "For the reflection time:"
    reflection_voice=$(get_voice "Now, reflect on your day. Think about what went well and what you could improve.")

    # Breathing exercises
    if skip_part "breathing exercises"; then
        for i in {1..5}
        do
            spd-say -l $breathing_voice "Inhale deeply."
            sleep $breathing_duration
            spd-say -l $breathing_voice "Hold your breath."
            sleep $breathing_duration
            spd-say -l $breathing_voice "Exhale slowly."
            sleep $breathing_duration
        done
    fi

    # Ask user if they want to play a custom sound file during the mindfulness exercise
    read -p "Would you like to play a custom sound file during the mindfulness exercise? (yes/no): " custom_sound_answer

    if [ "$custom_sound_answer" == "yes" ]; then
        # Ask user for the path to the custom sound file
        read -p "Please enter the path to the custom sound file: " custom_sound_file
        validate_file $custom_sound_file
    elif [[ -n $default_mindfulness_sound_file ]]; then
        custom_sound_file=$default_mindfulness_sound_file
    fi

    # Mindfulness exercise
    spd-say -l $mindfulness_voice "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body."

    if [[ -n $custom_sound_file ]]; then
        # Play the custom sound file
        aplay $custom_sound_file &
    fi

    sleep $mindfulness_duration

    # Ask user if they want a guided meditation
    read -p "Would you like a guided meditation? (yes/no): " guided_meditation_answer

    # Guided meditation
    if [ "$guided_meditation_answer" == "yes" ]; then
        # Get voice for guided meditation
        echo "For the guided meditation:"
        guided_meditation_voice=$(get_voice "Now, imagine you are in a peaceful place. It could be a forest, a beach, or anywhere you find calming. Visualize the details of this place. What do you see? What do you hear? What do you smell? Stay in this place for as long as you need.")
        # Get meditation text
        guided_meditation_text=$(get_meditation_text)
        spd-say -l $guided_meditation_voice "$guided_meditation_text"
        sleep $mindfulness_duration
    fi

    # Ask user if they want to play a custom sound file during the reflection time
    read -p "Would you like to play a custom sound file during the reflection time? (yes/no): " reflection_sound_answer

    if [ "$reflection_sound_answer" == "yes" ]; then
        # Ask user for the path to the custom sound file
        read -p "Please enter the path to the custom sound file for reflection time: " reflection_sound_file
        validate_file $reflection_sound_file
    elif [[ -n $default_reflection_sound_file ]]; then
        reflection_sound_file=$default_reflection_sound_file
    fi

    # Reflection
    spd-say -l $reflection_voice "Now, reflect on your day. Think about what went well and what you could improve."

    if [[ -n $reflection_sound_file ]]; then
        # Play the custom sound file
        aplay $reflection_sound_file &
    fi

    sleep $reflection_duration

    # Conclusion
    VOICE=$(get_voice "Great job! You have completed your mindfulness and meditation session. Remember to take a few moments each day to practice mindfulness. Have a great day!")
    spd-say -l $VOICE "Great job! You have completed your mindfulness and meditation session. Remember to take a few moments each day to practice mindfulness. Have a great day!"

    # Log the completed session
    VOICE=$(get_voice "Would you like to log this meditation session?")
    log_session
}

# Run the session
run_session

# Ask user if they want to repeat the session
read -p "Would you like to repeat the session? (yes/no): " repeat_session

if [ "$repeat_session" == "yes" ]; then
    # Ask user for the number of repetitions and the delay between each repetition
    read -p "Please enter the number of repetitions: " repetitions
    validate_number $repetitions
    read -p "Please enter the delay (in seconds) between each repetition: " delay
    validate_number $delay

    for ((i=1; i<=$repetitions; i++))
    do
        sleep $delay
        run_session
    done
fi

# Function to set reminder
function set_reminder() {
    read -p "Would you like to set a reminder for your next meditation session? (yes/no): " reminder_choice
    if [ "$reminder_choice" == "yes" ]; then
        read -p "Please enter the number of hours until the next reminder: " reminder_hours
        validate_number $reminder_hours
        echo "Reminder set for $reminder_hours hours from now."
        echo "Reminder set for $reminder_hours hours from now." | at now + $reminder_hours hours
    fi
}

# Set reminder at the end of the script
set_reminder

# Save preferences at the end of the script
save_preferences

exit 0
