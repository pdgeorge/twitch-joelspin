SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id twitch-joelspinvt-streamkey --query SecretString --output text)
STREAM_KEY=$(echo "$SECRET_JSON" | grep -oP '"stream_key":\s*"\K([^"]*)')
sudo -E ffmpeg -stream_loop -1 -i ./JoelSpinLonger.mp4 -c:v libx264 -preset fast -b:v 6000k -c:a aac -b:a 128k -ar 44100 -f flv rtmp://jfk.contribute.live-video.net/app/$STREAM_KEY
echo "Running"