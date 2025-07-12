# Docker-stacks
Dépôt pour les stacks Docker du GInfo déployé sur Tyr/Bor

## Démarrage du serveur (stack base)

Pour ramener un serveur à la vie, commencez par déployer le stack `base` :

```fish
cd ~/Documents/dev/Docker/docker-stacks/base
docker compose up -d
```

Cela démarre Portainer (gestion des conteneurs) et Traefik (reverse proxy).

- Accédez à Portainer sur le port 9000 pour gérer vos conteneurs.
- Traefik est prêt à être configuré pour le routage et la sécurité.

Poursuivez ensuite avec les autres stacks selon vos besoins.
