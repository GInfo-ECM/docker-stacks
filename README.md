# 🐳 Docker Stacks GInfo

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![Traefik](https://img.shields.io/badge/Reverse%20Proxy-Traefik-orange.svg)](https://traefik.io)

Collection de stacks Docker orchestrés pour le déploiement d'infrastructure moderne sur les serveurs Tyr/Bor du GInfo. Ce dépôt fournit une approche modulaire et scalable pour déployer des services avec reverse proxy automatisé, SSL/TLS, et gestion centralisée des conteneurs.

## 📚 Table des matières

- [🏗️ Architecture](#️-architecture)
- [⚡ Démarrage rapide](#-démarrage-rapide)
- [📦 Stacks disponibles](#-stacks-disponibles)
- [🔧 Prérequis](#-prérequis)
- [📖 Guide d'utilisation](#-guide-dutilisation)
- [⚙️ Configuration](#️-configuration)
- [🔍 Troubleshooting](#-troubleshooting)
- [🤝 Contribution](#-contribution)

## 🏗️ Architecture

L'infrastructure repose sur **Traefik** comme reverse proxy central qui :
- Route automatiquement le trafic vers les services appropriés
- Gère les certificats SSL/TLS automatiquement (Let's Encrypt)
- Fournit un tableau de bord pour surveiller les services
- Permet l'ajout de nouveaux services sans configuration manuelle

```
Internet → Traefik (ports 80/443) → Services Docker
                   ↓
              Portainer (gestion)
```

## ⚡ Démarrage rapide

### 1. Déployer la stack de base

La stack `base` est **obligatoire** et doit être déployée en premier. Elle contient Portainer et Traefik.

```bash
cd docker-stacks/base
cp .env.template .env
# Éditez .env selon vos besoins
docker compose up -d
```

### 2. Vérifier le déploiement

- **Portainer** : http://votre-serveur:9000 (gestion des conteneurs)
- **Traefik Dashboard** : http://votre-serveur:8080 (monitoring du reverse proxy)

### 3. Déployer des stacks additionnelles

```bash
cd docker-stacks/[nom-du-stack]
cp .env.template .env
# Configurez les variables d'environnement
docker compose up -d
```

## 📦 Stacks disponibles

### 🔧 Infrastructure de base

| Stack | Description | Status | Ports |
|-------|-------------|--------|-------|
| **base** | Portainer + Traefik (requis) | ✅ Stable | 80, 443, 8080, 9000 |

### 🛠️ Développement et DevOps

| Stack | Description | Status | Prérequis |
|-------|-------------|--------|-----------|
| **gitlab** | GitLab CE/EE avec GitLab Runner | ✅ Stable | `base` |
| **monitoring** | Stack LGTM (Loki, Grafana, Tempo, Prometheus, Pyroscope) | ✅ Stable | `base` |

### 🎮 Applications

| Stack | Description | Status | Prérequis |
|-------|-------------|--------|-----------|
| **minecraft** | Serveur Minecraft avec proxy Velocity | ✅ Stable | `base` |
| **zitadel** | Gestion d'identité et d'accès (IAM) | ✅ Stable | `base` |

### 📝 Templates et modèles

| Stack | Description | Status | Prérequis |
|-------|-------------|--------|-----------|
| **static-template** | Template pour sites statiques avec webhook Git | 📋 Template | `base` |
| **wordpress-template** | Template WordPress avec MySQL | 📋 Template | `base` |

### 🔄 Utilitaires

| Stack | Description | Status | Prérequis |
|-------|-------------|--------|-----------|
| **backup** | Solutions de sauvegarde | 🚧 En développement | `base` |

### 🏗️ Stacks en développement

| Stack | Description | Status |
|-------|-------------|--------|
| **cocoweb** | Application web personnalisée | 🚧 Template vide |
| **forrest** | Service personnalisé | 🚧 Template vide |
| **myca** | Autorité de certification | 🚧 Template vide |

## 🔧 Prérequis

### Système
- **Docker** ≥ 20.10
- **Docker Compose** ≥ 2.0
- **Serveur Linux** (Ubuntu/Debian recommandé)
- **Accès root** ou utilisateur dans le groupe `docker`

### Réseau
- **Ports ouverts** : 80 (HTTP), 443 (HTTPS)
- **DNS configuré** pour pointer vers votre serveur
- **Nom de domaine** (recommandé pour SSL automatique)

### Ressources recommandées
- **RAM** : 4GB minimum, 8GB recommandé
- **Stockage** : 50GB minimum
- **CPU** : 2 cores minimum

## 📖 Guide d'utilisation

### Configuration générale

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/GInfo-ECM/docker-stacks.git
   cd docker-stacks
   ```

2. **Déployer la stack de base**
   ```bash
   cd base
   cp .env.template .env
   # Configurez les variables dans .env
   docker compose up -d
   ```

3. **Vérifier les logs**
   ```bash
   docker compose logs -f traefik
   docker compose logs -f portainer
   ```

### Déploiement d'une stack

1. **Préparer l'environnement**
   ```bash
   cd [nom-du-stack]
   cp .env.template .env
   ```

2. **Configurer les variables** (voir section Configuration)

3. **Déployer**
   ```bash
   docker compose up -d
   ```

4. **Vérifier le déploiement**
   ```bash
   docker compose ps
   docker compose logs
   ```

### Gestion des stacks

```bash
# Arrêter une stack
docker compose down

# Mettre à jour une stack
docker compose pull
docker compose up -d

# Voir les logs
docker compose logs -f [service]

# Redémarrer un service
docker compose restart [service]
```

## ⚙️ Configuration

### Variables d'environnement communes

Chaque stack utilise un fichier `.env` basé sur `.env.template` :

```bash
# Copier le template
cp .env.template .env

# Éditer les variables
nano .env
```

### Configuration Traefik

Le fichier `base/traefik.yml` contient la configuration principale de Traefik. Personnalisez selon vos besoins :

- **Certificats SSL** : Configuration Let's Encrypt
- **Tableau de bord** : Accès et sécurité
- **Entry points** : Ports d'écoute
- **Providers** : Sources de configuration

### Réseau Docker

Toutes les stacks utilisent le réseau `traefik-proxy` créé par la stack de base. Les services exposés doivent :

1. Se connecter au réseau `traefik-proxy`
2. Utiliser les labels Traefik appropriés
3. Définir les règles de routage

## 🔍 Troubleshooting

### Problèmes courants

#### Services inaccessibles

```bash
# Vérifier que Traefik fonctionne
docker compose -f base/compose.yaml ps

# Vérifier les logs Traefik
docker compose -f base/compose.yaml logs traefik

# Vérifier la configuration réseau
docker network ls
docker network inspect traefik-proxy
```

#### Erreurs de certificats SSL

```bash
# Vérifier la configuration ACME
docker compose -f base/compose.yaml logs traefik | grep -i acme

# Vérifier les certificats générés
ls -la base/data/certs/
```

#### Conflits de ports

```bash
# Vérifier les ports utilisés
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :443

# Arrêter les services conflictuels
sudo systemctl stop apache2  # ou nginx
```

### Logs et debugging

```bash
# Logs détaillés pour une stack
cd [nom-du-stack]
docker compose logs -f --tail=100

# Inspecter un conteneur
docker inspect [container-name]

# Accéder à un conteneur
docker exec -it [container-name] /bin/bash
```

### Réinitialisation complète

```bash
# Arrêter toutes les stacks
docker compose down

# Nettoyer les volumes (ATTENTION: perte de données)
docker volume prune

# Nettoyer les réseaux
docker network prune

# Redéployer la stack de base
cd base && docker compose up -d
```

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
         - "traefik.http.routers.mon-service.tls.certresolver=myresolver"
   
   networks:
     traefik-proxy:
       external: true
   ```

4. **Documenter la stack** dans ce README

### Standards de qualité

- ✅ Utiliser les réseaux Docker appropriés
- ✅ Inclure les labels Traefik nécessaires
- ✅ Fournir un fichier `.env.template` documenté
- ✅ Tester le déploiement et la connectivité
- ✅ Documenter les prérequis et la configuration

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🔗 Liens utiles

- [Documentation Docker](https://docs.docker.com/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)
- [Documentation Traefik](https://doc.traefik.io/traefik/)
- [Documentation Portainer](https://documentation.portainer.io/)

---

*Maintenu par l'équipe GInfo ECM*