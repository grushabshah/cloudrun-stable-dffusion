PROJECT_ID=rushabshah-crun
REGION=asia-southeast1
NETWORK_NAME=crun-nat
SUBNET_NAME=crun-nat-ase1
CRUN_SERVICE=stable-diffusion-server
GAR_REPOSITORY=asia-docker.pkg.dev/rushabshah-crun/ai
IMAGE=asia-docker.pkg.dev/rushabshah-crun/ai/stable-diffusion-server:latest

gcloud beta run deploy $CRUN_SERVICE \
    --set-secrets=HG_TOKEN=hg_token:latest \
    --source=. \
    --cpu=8 \
    --memory=32Gi \
    --gpu=1 \
    --no-cpu-throttling \
    --gpu-type=nvidia-l4 \
    --region $REGION \
    --project $PROJECT_ID \
    --execution-environment=gen2 \
    --min-instances 1 \
    --network $NETWORK_NAME --subnet=$SUBNET_NAME \
    --vpc-egress all-traffic \
    --allow-unauthenticated

gcloud run services update-traffic $CRUN_SERVICE --to-latest