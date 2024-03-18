#!/bin/bash

# Welcome message
spd-say "Welcome to your mindfulness and meditation session. Let's start with a deep breath."

# Ask user for the duration of the breathing exercises, mindfulness exercise and reflection time
echo "Please enter the duration (in seconds) for each part of the breathing exercises:"
read breathing_duration
echo "Please enter the duration (in seconds) for the mindfulness exercise:"
read mindfulness_duration
echo "Please enter the duration (in seconds) for the reflection time:"
read reflection_duration

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

# Mindfulness exercise
spd-say "Now, let's practice mindfulness. Close your eyes and focus on your breath. Notice the sensation of the air entering and leaving your body."
sleep $mindfulness_duration

# Ask user if they want a guided meditation
echo "Would you like a guided meditation? (yes/no):"
read guided_meditation_answer

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

exit 0
