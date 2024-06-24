#!/bin/bash

set -e

minikube start --static-ip 192.168.49.2 

kubectl apply -f services-deploy.yaml

SERVICE_NAME="django-api-service"

echo "Esperando que el LoadBalancer tenga asignada una dirección IP..."

while true; do
  # Obtener la dirección IP del LoadBalancer
  LB_IP=$(kubectl get svc $SERVICE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

  if [ ! -z "$LB_IP" ]; then
    echo "LoadBalancer IP asignada: $LB_IP"
    break
  fi

  echo "Esperando..."
  sleep 10
done

ENV_FILE_FRONTEND="./frontend/.env"

if grep -qF "REACT_APP_BACK_IP=" $ENV_FILE_FRONTEND; then
  sed -i "s/^REACT_APP_BACK_IP=.*/REACT_APP_BACK_IP=$LB_IP/" $ENV_FILE_FRONTEND
else
  echo "REACT_APP_BACK_IP=$LB_IP" >> $ENV_FILE_FRONTEND
fi

kubectl create configmap front-config --from-env-file=./frontend/.env
kubectl create configmap db-config --from-env-file=./backend/.env.postgres
kubectl create configmap back-config --from-env-file=./backend/.env

docker compose build
docker compose push

sleep 20

kubectl apply -f db-deployment.yaml
kubectl apply -f react-django-deploy.yaml

# kubectl get svc django-api-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'