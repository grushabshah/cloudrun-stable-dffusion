PROJECT_ID=rushabshah-crun
REGION=asia-southeast1
NETWORK_NAME=crun-nat
SUBNET_NAME=crun-nat-ase1
CRUN_SERVICE=stablediff
SD_SERVER_URL=https://stable-diffusion-server-cblr5e2ayq-as.a.run.app/predictions/stable_diffusion

gcloud beta run deploy $CRUN_SERVICE \
    --source=. \
    --set-env-vars=SD_SERVER_URL=$SD_SERVER_URL \
    --region $REGION \
    --project $PROJECT_ID \
    --execution-environment=gen2 \
    --min-instances 1 \
    --network $NETWORK_NAME --subnet=$SUBNET_NAME \
    --vpc-egress all-traffic \
    --no-allow-unauthenticated

gcloud run services update-traffic $CRUN_SERVICE --to-latest