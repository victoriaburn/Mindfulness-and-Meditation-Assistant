#!/bin/bash

# Welcome message
spd-say "Welcome to your mindfulness and meditation session. Let's start with a deep breath."

# Ask user for the duration of the breathing exercises, mindfulness exercise and reflection time
read -p "Please enter the duration (in seconds) for each part of the breathing exercises: " breathing_duration
read -p "Please enter the duration (in seconds) for the mindfulness exercise: " mindfulness_duration
read -p "Please enter the duration (in seconds) for the reflection time: " reflection_duration

# Breathing exercises
for i in {1..5}
do
    spd-say "Inhale deeply."
    sleep $breathing_duration
    spd-say "Hold your breath."
    sleep $breathing_duration
    spd-say "Exhale slowly."
    sleep $breathing_duration
done

# Ask user if they want to play a custom sound file during the mindfulness exercise
read -p "Would you like to play a custom sound file during the mindfulness exercise? (yes/no): " custom_sound_answer

if [ "$custom_sound_answer" == "yes" ]; then
    # Ask user for the path to the custom sound file
    read -p "Please enter the path to the custom sound file: " custom_sound_file
fi

# Mindfulness exercise
spd-say "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body."

if [ "$custom_sound_answer" == "yes" ]; then
    # Play the custom sound file
    aplay $custom_sound_file &
fi

sleep $mindfulness_duration

# Ask user if they want a guided meditation
read -p "Would you like a guided meditation? (yes/no): " guided_meditation_answer

if [ "$guided_meditation_answer" == "yes" ]; then
    # Guided meditation
    spd-say "Now, imagine you are in a peaceful place. It could be a forest, a beach, or anywhere you find calming. Visualize the details of this place. What do you see? What do you hear? What do you smell? Stay in this place for as long as you need."
    sleep $mindfulness_duration
fi

# Reflection
spd-say "Now, reflect on your day. Think about what went well and what you could improve."
sleep $reflection_duration

# Conclusion
spd-say "Great job! You have completed your mindfulness and meditation session. Remember to take a few moments each day to practice mindfulness. Have a great day!"

# Ask user if they want to schedule the next session
read -p "Would you like to schedule your next session? (yes/no): " schedule_next_session

if [ "$schedule_next_session" == "yes" ]; then
    # Schedule the next session
    read -p "Please enter the date and time for your next session (format: YYYY-MM-DD HH:MM): " next_session_datetime
    next_session_datetime_unix=$(date -d"$next_session_datetime" +%s)
    (crontab -l 2>/dev/null; echo "$next_session_datetime_unix $0") | crontab -
    spd-say "Your next session has been scheduled for $next_session_datetime. Looking forward to seeing you then!"
fi

exit 0
