
We can see the repository we had used some time before.
```
aws ecr describe-repositories --repository-names osm-osmosis 
```
Given the contents of the VERSION file that show 2.0.0, we can use that as the tag
```
docker build -t osm-osmosis:2.0.0 -f docker/OSM/Dockerfile .
```
The tricky part is where we associate that local tag with the ECR repository.
```
docker tag osm-osmosis:2.0.0 126924000548.dkr.ecr.us-east-1.amazonaws.com/osm-osmosis:2.0.0
```
Then we push it up to AWS using this.
```
docker push 126924000548.dkr.ecr.us-east-1.amazonaws.com/osm-osmosis:2.0.0
```
Some folks like to use the latest tag . . . so you could also tag that version as such.
```
docker tag osm-osmosis:2.0.0 126924000548.dkr.ecr.us-east-1.amazonaws.com/osm-osmosis:latest
```
then pushing the latest is easy as all the layers are already there . . .
```
docker push 126924000548.dkr.ecr.us-east-1.amazonaws.com/osm-osmosis:latest   
```
We can see what is in the repository using this.
```
aws ecr describe-images --repository-name osm-osmosis    
```
For example, one which shows a single image, with two tags.
```
{
    "imageDetails": [
        {
            "registryId": "126924000548",
            "repositoryName": "osm-osmosis",
            "imageDigest": "sha256:06cefe4edc8996937f0e0a2a5e83544ca0a4abd85cd54456652c26af5649b5c8",
            "imageTags": [
                "latest",
                "2.0.0"
            ],
            "imageSizeInBytes": 449931928,
            "imagePushedAt": "2024-02-27T20:22:13-05:00",
            "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
            "artifactMediaType": "application/vnd.docker.container.image.v1+json"
        }
    ]
}
```
In cases where we might deploy to multiple target environments, we can pull the ECR URI for the currently configured account.
```
aws ecr describe-repositories --repository-name osm-osmosis | jq '.repositories[] | .repositoryUri'
```
Given the VERSION file contents, we can use that for the semantic version as a tag.
```
docker build -t osm-osmosis:$(cat VERSION) -f docker/OSM/Dockerfile .
```
Putting these two together, we can tag the image and push it with the following commands.
```
docker tag osm-osmosis:$(cat VERSION) $(aws ecr describe-repositories --repository-name osm-osmosis | jq '.repositories[] | .repositoryUri' |  tr -d '"' ):$(cat VERSION) 
```
... and then ...
```
docker push $(aws ecr describe-repositories --repository-name osm-osmosis | jq '.repositories[] | .repositoryUri' |  tr -d '"' ):$(cat VERSION)
```

# FAQ: 

## frondender authorization failure

Issue: 

So for
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 126924000548.dkr.ecr.us-east-1.amazonaws.com
```
I get
```
 operation: User: arn:aws:iam::126924000548:user/alex.crane@unity3d.com is not authorized to perform: ecr:GetAuthorizationToken on resource: * because no identity-based policy allows the ecr:GetAuthorizationToken action
Error: Cannot perform an interactive login from a non TTY device
```

Resolution:

Add photogrammetrist permissions.





