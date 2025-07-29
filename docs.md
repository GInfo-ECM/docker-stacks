# 📖 Documentation détaillée - Docker Stacks GInfo

Ce document contient la documentation complète pour l'utilisation et la configuration des stacks Docker du GInfo.

## 📚 Table des matières

- [🔧 Prérequis](#-prérequis)
- [📖 Guide d'utilisation](#-guide-dutilisation)
- [⚙️ Configuration](#️-configuration)
- [🔍 Troubleshooting](#-troubleshooting)
- [🔗 Liens utiles](#-liens-utiles)

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

## 🔗 Liens utiles

- [Documentation Docker](https://docs.docker.com/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)
- [Documentation Traefik](https://doc.traefik.io/traefik/)
- [Documentation Portainer](https://documentation.portainer.io/)

---

*Maintenu par l'équipe GInfo ECM*