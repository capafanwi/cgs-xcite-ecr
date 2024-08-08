
# prerequisites

In a directory have the following projects checked out.
* some-sfm-utils, 
```
https://github.com/Unity-Technologies/some-sfm-utils.git
```
* OpenSfM, 
```
https://github.com/mapillary/OpenSfM
```
* urbaneng, 
```
https://github.com/Unity-Technologies/bda-argo-workflows
```
* 360toFrames,
```
https://github.com/Unity-Technologies/bda-360-to-frames
```
* gopro2gpx,
```
https://github.com/juanmcasillas/gopro2gpx.git
```

# 3rd party software

## ffmpeg v5 
This is needed as ffprobe does not recognize .360 files.  The docker file will get it from the below lin and then copy into bin path
```
wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz
tar xvf ffmpeg-git-amd64-static.tar.xz
cp /tmp/ffmpeg-git-20220910-amd64-static/ffprobe /usr/local/bin/ffprobe
```

# Authenticate to the ECR hosted repository.
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 1234567890.dkr.ecr.us-east-1.amazonaws.com
```

# build and push

Build from directory containing the other projects.
```
docker build -t opensfm:current -f urbaneng/docker/opensfm/Dockerfile.golang . 
```
Tag the build for the remote repository.
```
docker tag opensfm:current 1234567890.dkr.ecr.us-east-1.amazonaws.com/opensfm:current
```
Push the image to the remote repository.
```
docker push 1234567890.dkr.ecr.us-east-1.amazonaws.com/opensfm:current
```

# listing repository images

Now we can see the three images constructed here, and one mystery image :D

```
aws ecr list-images --repository-name opensfm

```

# Running

First login to ECR.
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 1234567890.dkr.ecr.us-east-1.amazonaws.com
```

Next run the image of your choice, mounting the local `/opt/data` filesystem as a volume.
```
docker run -it -v /opt/data:/opt/data 1234567890.dkr.ecr.us-east-1.amazonaws.com/opensfm:latest /bin/bash 
```
Do something fun.
```
root@43819b0b8a11:/source/OpenSfM# ls -la /opt/data/clear/data/04_SFMUtils/
total 16
drwxrwxr-x 4 1000 1000 4096 Oct 31 19:40 .
drwxrwxr-x 6 1000 1000 4096 Oct 31 19:26 ..
drwxrwxr-x 2 1000 1000 4096 Oct 31 19:26 images
drwxrwxr-x 2 1000 1000 4096 Oct 31 19:44 skymask
```
You might notice that on exit the container stops, though it is still there . . . 
```
ubuntu@ip-10-0-5-205:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-10-0-5-205:~$ docker ps -a
CONTAINER ID   IMAGE                                                         COMMAND       CREATED         STATUS                     PORTS     NAMES
43819b0b8a11   1234567890.dkr.ecr.us-east-1.amazonaws.com/opensfm:latest   "/bin/bash"   2 minutes ago   Exited (0) 5 seconds ago             infallible_tereshkova
```
