DIR="$HOME/.config/hypr/.wallpapers/"
SCRIPTS="$HOME/.config/hypr/scripts"

PICS=($(find ${DIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

# Transition
FPS=30
TYPE="any"
DURATION=2
SWWW_TRANSITION="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

swww query || swww init && swww img ${RANDOMPICS} $SWWW_TRANSITION
