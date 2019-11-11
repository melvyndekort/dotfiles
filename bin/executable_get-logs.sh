#!/bin/sh

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cmd-ecs-cli-logs.html

for i in $(aws ecs list-tasks --cluster hinterland-sc --service-name mca_edi_integration | jq -r '.taskArns[]'); do
  ecs-cli logs --task-id $i --filter-pattern test --since 86400 --timestamps
done
