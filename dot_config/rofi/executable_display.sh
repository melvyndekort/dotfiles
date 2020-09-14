#!/bin/sh

if [ $# -eq 0 ]; then
  cat <<-END
laptop 
desktop-1 度度
desktop-2 度
dock-clone 
dock-expand-1 度度 
dock-expand-2 度度 
dock-expand-3  度度
dock-expand-4  度度
hdmi-clone 
hdmi-expand-1  度
hdmi-expand-2  度度
END
  
  exit 0
fi

case $(echo "$1" | cut -d' ' -f1) in
  *laptop*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --off \
      --output DVI-I-1-1 --off \
      --output DVI-I-2-2 --off ;;

  *desktop-1*)
    xrandr \
      --output DP-1 --primary --dpi 96 --mode 1680x1050 --pos 0x0 \
      --output DVI-I-1 --dpi 96 --mode 1680x1050 --pos 1680x0 \
      --output DP-0 --off \
      --output DVI-I-0 --off ;;

  *desktop-2*)
    xrandr \
      --output DP-1 --primary --dpi 96 --mode 1680x1050 --pos 0x0 \
      --output DVI-I-1 --off \
      --output DP-0 --off \
      --output DVI-I-0 --off ;;

  *dock-clone*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output DVI-I-1-1 --same-as eDP-1 \
      --output DVI-I-2-2 --same-as eDP-1 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --off ;;

  *dock-expand-1*)
    xrandr \
      --output DVI-I-1-1 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output DVI-I-2-2 --dpi 96 --mode 1920x1080 --pos 1920x0 \
      --output eDP-1 --dpi 96 --mode 1920x1080 --pos 3840x504 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --off ;;

  *dock-expand-2*)
    xrandr \
      --output DVI-I-2-2 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output DVI-I-1-1 --dpi 96 --mode 1920x1080 --pos 1920x0 \
      --output eDP-1 --dpi 96 --mode 1920x1080 --pos 3840x504 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --off ;;

  *dock-expand-3*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x504 \
      --output DVI-I-1-1 --dpi 96 --mode 1920x1080 --pos 1920x0 \
      --output DVI-I-2-2 --dpi 96 --mode 1920x1080 --pos 3840x0 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --off ;;

  *dock-expand-4*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x504 \
      --output DVI-I-2-2 --dpi 96 --mode 1920x1080 --pos 1920x0 \
      --output DVI-I-1-1 --dpi 96 --mode 1920x1080 --pos 3840x0 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --off \
      --output HDMI-2 --off ;;

  *hdmi-clone*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output HDMI-1 --same-as eDP-1 \
      --output HDMI-2 --off \
      --output DVI-I-1-1 --off \
      --output DVI-I-2-2 --off ;;

  *hdmi-expand-1*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output HDMI-1 --dpi 96 --mode 1920x1080 --pos 1920x0 \
      --output HDMI-2 --off \
      --output DP-1 --off \
      --output DP-2 --off \
      --output DVI-I-1-1 --off \
      --output DVI-I-2-2 --off ;;

  *hdmi-expand-2*)
    xrandr \
      --output eDP-1 --primary --dpi 96 --mode 1920x1080 --pos 0x0 \
      --output HDMI-1 --dpi 96 --mode 1920x1080 --pos 1920x0 \
      --output HDMI-2 --dpi 96 --mode 1920x1080 --pos 3840x0 \
      --output DP-1 --off \
      --output DP-2 --off \
      --output DVI-I-1-1 --off \
      --output DVI-I-2-2 --off ;;
esac

notify-send "Configured display setup: $(echo $1 | cut -d' ' -f1)"

