#!/bin/bash

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

# Welcome message
VOICE=$(get_voice "Welcome to your mindfulness and meditation session. Let's start with a deep breath.")
spd-say -l $VOICE "Welcome to your mindfulness and meditation session. Let's start with a deep breath."

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

# Ask user for the duration of the breathing exercises, mindfulness exercise and reflection time
read -p "Please enter the duration (in seconds) for each part of the breathing exercises: " breathing_duration
validate_number $breathing_duration
read -p "Please enter the duration (in seconds) for the mindfulness exercise: " mindfulness_duration
validate_number $mindfulness_duration
read -p "Please enter the duration (in seconds) for the reflection time: " reflection_duration
validate_number $reflection_duration

# Get voice for each part
echo "For the breathing exercises:"
breathing_voice=$(get_voice "Inhale deeply.")
echo "For the mindfulness exercise:"
mindfulness_voice=$(get_voice "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body.")
echo "For the reflection time:"
reflection_voice=$(get_voice "Now, reflect on your day. Think about what went well and what you could improve.")

# Breathing exercises
for i in {1..5}
do
    spd-say -l $breathing_voice "Inhale deeply."
    sleep $breathing_duration
    spd-say -l $breathing_voice "Hold your breath."
    sleep $breathing_duration
    spd-say -l $breathing_voice "Exhale slowly."
    sleep $breathing_duration
done

# Ask user if they want to play a custom sound file during the mindfulness exercise
read -p "Would you like to play a custom sound file during the mindfulness exercise? (yes/no): " custom_sound_answer

if [ "$custom_sound_answer" == "yes" ]; then
    # Ask user for the path to the custom sound file
    read -p "Please enter the path to the custom sound file: " custom_sound_file
    validate_file $custom_sound_file
fi

# Mindfulness exercise
spd-say -l $mindfulness_voice "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body."

if [ "$custom_sound_answer" == "yes" ]; then
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
fi

# Reflection
spd-say -l $reflection_voice "Now, reflect on your day. Think about what went well and what you could improve."

if [ "$reflection_sound_answer" == "yes" ]; then
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

# Ask user if they want to schedule the next session
read -p "Would you like to schedule your next session? (yes/no): " schedule_next_session

if [ "$schedule_next_session" == "yes" ]; then
    # Schedule the next session
    read -p "Please enter the date and time for your next session (format: YYYY-MM-DD HH:MM): " next_session_datetime
    next_session_datetime_unix=$(date -d"$next_session_datetime" +%s)
    (crontab -l 2>/dev/null; echo "$((next_session_datetime_unix/60)) * * * * $0") | crontab -
    spd-say -l $VOICE "Your next session has been scheduled for $next_session_datetime. Looking forward to seeing you then!"

    # Ask user if they want to repeat the session
    read -p "Would you like to repeat this session? (yes/no): " repeat_session

    if [ "$repeat_session" == "yes" ]; then
        # Ask user for the frequency of repetition
        read -p "Please enter the frequency of repetition (in days): " repeat_frequency
        validate_number $repeat_frequency
        (crontab -l 2>/dev/null; echo "0 0 */$repeat_frequency * * $0") | crontab -
        spd-say -l $VOICE "Your session has been scheduled to repeat every $repeat_frequency day(s)."
    fi
fi

exit 0