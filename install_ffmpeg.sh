#!/bin/bash
sudo -E aws s3 cp s3://joelspin-bucket/ffmpeg-release-amd64-static.tar.xz /usr/local/bin/ffmpeg/ffmpeg-release-amd64-static.tar.xz
cd /usr/local/bin/ffmpeg/
sudo -E tar -xf ffmpeg-release-amd64-static.tar.xz
cd ffmpeg-6.0-amd64-static
sudo -E cp -a ./* /usr/local/bin/ffmpeg/
sudo -E ln -s /usr/local/bin/ffmpeg/ffmpeg /usr/bin/ffmpeg
sudo -E aws s3 cp s3://joelspin-bucket/JoelSpinLonger.mp4 /vids/JoelSpinLonger.mp4
cd ~
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id twitch-joelspinvt-streamkey --query SecretString --output text --region us-east-1)
STREAM_KEY=$(echo "$SECRET_JSON" | grep -oP '"stream_key":\s*"\K([^"]*)')
sudo -E nohup ffmpeg -stream_loop -1 -i /vids/JoelSpinLonger.mp4 -c:v libx264 -preset fast -b:v 6000k -c:a aac -b:a 128k -ar 44100 -f flv rtmp://jfk.contribute.live-video.net/app/$STREAM_KEY > ~/ffmpeg_output.log 2>&1 &