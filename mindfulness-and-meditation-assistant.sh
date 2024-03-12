#!/bin/bash

# Welcome message
spd-say "Welcome to your mindfulness and meditation session. Let's start with a deep breath."

# Ask user for the duration of the breathing exercises
echo "Please enter the duration (in seconds) for each part of the breathing exercises:"
read breathing_duration

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

# Ask user for the duration of the mindfulness exercise
echo "Please enter the duration (in seconds) for the mindfulness exercise:"
read mindfulness_duration

# Mindfulness exercise
spd-say "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body."
sleep $mindfulness_duration

# Ask user for the duration of the reflection time
echo "Please enter the duration (in seconds) for the reflection time:"
read reflection_duration

# Reflection
spd-say "Now, reflect on your day. Think about what went well and what you could improve."
sleep $reflection_duration

# Conclusion
spd-say "Great job! You have completed your mindfulness and meditation session. Remember to take a few moments each day to practice mindfulness. Have a great day!"

exit 0
