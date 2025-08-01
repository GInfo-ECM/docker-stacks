# 🐳 Docker Stacks GInfo

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![Traefik](https://img.shields.io/badge/Reverse%20Proxy-Traefik-orange.svg)](https://traefik.io)

Collection de stacks Docker orchestrés pour le déploiement d'infrastructure moderne sur les serveurs Tyr/Bor du GInfo. Ce dépôt fournit une approche modulaire et scalable pour déployer des services avec reverse proxy automatisé, SSL/TLS, et gestion centralisée des conteneurs.

## ⚡ Démarrage rapide

### Déployer la stack de base

La stack `base` est **obligatoire** et doit être déployée en premier. Elle contient Portainer et Traefik.

```bash
cd docker-stacks/base
cp .env.template .env
# Éditez .env selon vos besoins
docker compose up -d
```

**Structure des dossiers** : Chaque stack contient un dossier avec le fichier `compose.yaml`, le fichier `.env` et des fichiers de configuration possibles.

📖 **Documentation complète** : Consultez [docs.md](docs.md) pour les guides détaillés, la configuration et le troubleshooting.

## 📦 Stacks disponibles

### 🔧 Infrastructure de base

| Stack | Description | Status | Ports |
|-------|-------------|--------|-------|
| **base** | Portainer + Traefik (requis) | ✅ Stable | 80, 443, 25565 |

### 🛠️ Développement et DevOps

| Stack | Description | Status |
|-------|-------------|--------|
| **gitlab** | GitLab CE avec GitLab Runner | ✅ Stable |
| **monitoring** | Stack LGTM (Loki, Grafana, Tempo, Prometheus, Pyroscope) | ✅ Stable |

### 🎮 Applications

| Stack | Description | Status |
|-------|-------------|--------|
| **minecraft** | Serveur Minecraft avec proxy Velocity | ✅ Stable |
| **zitadel** | Gestion d'identité et d'accès (IAM) | ✅ Stable |

### 📝 Templates et modèles

| Stack | Description | Status |
|-------|-------------|--------|
| **static-template** | Template pour sites statiques avec webhook Git | 📋 Template |
| **wordpress-template** | Template WordPress avec MySQL | 📋 Template |

### 🔄 Utilitaires

| Stack | Description | Status |
|-------|-------------|--------|
| **backup** | Solutions de sauvegarde | 🚧 En développement |

### 🏗️ Stacks en développement

| Stack | Description | Status |
|-------|-------------|--------|
| **cocoweb** | Bar'bu | 🚧 Template vide |
| **forrest** | Successeur des Drupannales | 🚧 Template vide |
| **myca** | Association applicative | 🚧 Template vide |

## 🤝 Contribution

### Ajouter une nouvelle stack

1. **Créer le répertoire**
   ```bash
   mkdir nouvelle-stack
   cd nouvelle-stack
   ```

2. **Créer les fichiers requis**
   ```bash
   touch .env.template
   touch .gitignore
   touch compose.yaml
   ```

3. **Structure recommandée**
   ```yaml
   # compose.yaml
   services:
     mon-service:
       image: mon-image:latest
       networks:
         - traefik-proxy
       labels:
         - "traefik.enable=true"
         - "traefik.http.routers.mon-service.rule=Host(`mon-service.example.com`)"
         - "traefik.http.routers.mon-service.entrypoints=websecure"
         - "traefik.http.routers.mon-service.tls.certresolver=cloudflare"
   
   networks:
     traefik-proxy:
       external: true
   ```

4. **Documenter la stack** dans ce README

### Standards de qualité

- ✅ Utiliser les réseaux Docker appropriés
- ✅ Inclure les labels Traefik nécessaires
- ✅ Fournir un fichier `.env.template` documenté
- ✅ Mettre les données dans un dossier adjacent
- ✅ Tester le déploiement et la connectivité
- ✅ Documenter les prérequis et la configuration

---

## 📄 Licence

Ce projet est sous licence Apache 2.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

*Maintenu par l'équipe GInfo ECM*
